# Architecture — RAG Chatbot v5 Production

## Übersicht

Zwei separate n8n-Workflows, gemeinsam genutzter Vector-Store und Supabase-Sidecar
für Audit, DLQ und Circuit-Breaker-State.

```
                  ┌──────────────────────────────────────┐
                  │            Supabase                  │
                  │  ┌────────────┬───────────────────┐ │
                  │  │ documents  │ pgvector store    │ │
                  │  ├────────────┼───────────────────┤ │
                  │  │ audit_     │ append-only log   │ │
                  │  │  events    │ (Pattern 7)       │ │
                  │  ├────────────┼───────────────────┤ │
                  │  │ failed_    │ DLQ retry source  │ │
                  │  │  jobs      │ (Pattern 3)       │ │
                  │  ├────────────┼───────────────────┤ │
                  │  │ circuit_   │ per-service CB    │ │
                  │  │  breaker_  │ state (Pattern 6) │ │
                  │  │  state     │                   │ │
                  │  └────────────┴───────────────────┘ │
                  └──────────────┬───────────────────────┘
                                 │
              ┌──────────────────┴───────────────────┐
              │                                       │
   ┌──────────▼──────────┐               ┌────────────▼─────────┐
   │  Ingestion v5       │               │  Query v5            │
   │  (Manual Trigger)   │               │  (Webhook + HMAC)    │
   └─────────────────────┘               └──────────────────────┘
```

## Ingestion v5 — Node-Sequenz

```
Manual Trigger
   │
   ▼
Read MD Files               ← Files aus /Users/stm/.n8n-files/company-docs/
   │
   ▼
Validate + Hash             ← Pattern 1 (Validation) + Pattern 7 (Idempotency)
   │                           - path_pattern, size, content checks
   │                           - file_hash (sha256) für Dedup
   │                           - structured log JSON
   │
   ▼
Valid?  ──── NO ──► Audit: Skipped → END
   │ YES
   ▼
CB Check (OpenAI)           ← Pattern 6: Circuit Breaker openai_embeddings
   │
   ▼
Audit: Started              ← Pattern 2: doc_ingestion_started
   │
   ▼
Supabase Vector Insert      ← onError: continueErrorOutput → DLQ
   │           │
   │ OK        │ FAIL
   ▼           ▼
Audit: ✓     DLQ Insert → Audit: doc_ingestion_failed
```

## Query v5 — Node-Sequenz

```
Webhook POST /rag-chat-v5
   │
   ▼
Verify HMAC                 ← Pattern 1: HMAC-SHA256 mit X-Webhook-Signature
   │
   ▼
HMAC OK? ──── NO ──► 401 Unauthorized
   │ YES
   ▼
Validate Schema             ← Pattern 2: length 3..1000, prompt-injection-regex
   │
   ▼
Valid? ──── NO ──► Audit: Rejected → 400 Bad Request
   │ YES
   ▼
CB Check                    ← Pattern 6: anthropic_chat, supabase_vector
   │
   ▼
Audit: Received             ← Pattern 2: query_received
   │
   ▼
AI Agent (Claude Haiku)     ← onError: continueErrorOutput
   │   ├─ Chat Model Anthropic     (Pattern 5: 429-Backoff in lib)
   │   ├─ Vector Store Tool        (Retrieve-as-tool)
   │   └─ Embeddings OpenAI
   │
   ├── OK ──────► Audit: Completed → 200 OK
   │
   └── FAIL ───► DLQ Insert → 500 Error
```

## Datenfluss pro Request

```
1. HTTP POST → Webhook
2. HMAC-Header parsen → timingSafeEqual gegen Secret
3. Body validieren → length, prompt-injection-pattern
4. request_id generieren → process_started_at speichern
5. CB-State lesen (Supabase RPC cb_is_open)
6. audit_events insert: query_received
7. AI Agent ruft Vector Store Tool für Retrieval
8. LLM generiert Antwort mit System-Prompt-Grounding
9. audit_events insert: query_completed (mit latency, response_preview)
10. 200 OK Response mit request_id für Tracing
```

## Failure Modes (was wann passiert)

| Failure | Erkennung | Handling | Audit-Event |
|---|---|---|---|
| Bad HMAC | `verify-hmac` Code-Node | 401 Response | (nicht geloggt, da Bot/Scraper-Schutz) |
| Empty/too-long Query | `validate-schema` Code-Node | 400 Response | `query_rejected` |
| Prompt Injection | Regex-Pattern-Match | 400 Response | `query_rejected` (error=prompt_injection_suspected) |
| Anthropic 429 (Rate Limit) | LangChain-Library handle | Wait + Retry (lib-intern) | (Library-Log) |
| Anthropic Down | LangChain-Library fail nach Retries | `continueErrorOutput` → DLQ | `query_completed` (status=error) |
| Supabase Down (Vector) | Tool-Aufruf fail | LLM antwortet ohne Kontext (degraded) | `query_completed` (mit error-Note) |
| Embedding 429 (Ingestion) | OpenAI client fail | `continueErrorOutput` → DLQ | `doc_ingestion_failed` |
| File too large | `validate+hash` Code-Node | Skip + Log | `doc_validation_failed` |

## DSGVO-Mapping

| Art. | Anforderung | Erfüllt durch |
|---|---|---|
| Art. 5  | Rechenschaftspflicht | `audit_events` Tabelle (immutable, request_id-Tracing) |
| Art. 17 | Recht auf Löschung | Hard-Delete in `documents` möglich; `audit_events` enthält keine Klartext-PII außer query_preview (200 chars), kann gepurged werden |
| Art. 30 | Verzeichnis Verarbeitungstätigkeiten | `audit_events` als operatives Verzeichnis |
| Art. 32 | Sicherheit der Verarbeitung | HMAC für Webhook, Service-Role-RLS für Audit-Tabellen, Prompt-Injection-Filter |
| Art. 33 | Meldepflicht Datenschutzverletzung | DLQ macht Failed Events forensisch nachvollziehbar |

## Operational Metrics (aus audit_events ableitbar)

Beispiel-Queries für Sailes Q&A oder Dashboard:

```sql
-- Query-Latency P95 letzte 24h
select percentile_cont(0.95) within group (order by latency_ms)
from audit_events
where source = 'query-v5' and action = 'query_completed'
  and ts > now() - interval '24 hours';

-- Error-Rate (status=error / total) letzte 24h
select
  count(*) filter (where status = 'error')::float / count(*)::float as error_rate
from audit_events
where source = 'query-v5' and action = 'query_completed'
  and ts > now() - interval '24 hours';

-- Top Prompt-Injection-Versuche
select payload->'query_preview', count(*)
from audit_events
where action = 'query_rejected' and error like '%injection%'
group by payload->'query_preview'
order by count desc;

-- Failed Ingestions die noch nicht retry'd wurden
select * from failed_jobs
where resolved_at is null
  and source = 'ingestion-v5'
  and retry_count < max_retries
  and (last_retry_at is null or last_retry_at < now() - interval '15 minutes')
order by ts;
```

## Erweiterungen v6 (nicht in v5)

1. **Retry-Worker** als separater n8n-Workflow: liest `failed_jobs` mit `resolved_at IS NULL`, retried gemäss exponential backoff.
2. **Reconciliation**: Diff zwischen `documents` und Quell-Files (z.B. modified_since); orphan-cleanup.
3. **OpenTelemetry Traces** statt nur Audit-Logs.
4. **Multi-Tenant HMAC**: pro Kunde eigenes Secret, lookup via Tenant-ID-Header.
5. **Semantic Prompt-Guardrails** statt Regex (NeMo Guardrails oder LLamaGuard).
