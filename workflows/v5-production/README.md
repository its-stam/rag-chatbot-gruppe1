# RAG Chatbot v5 — Production-Ready Variant

Production-fähige Variante des validierten v4.7-Workflows. Baut die 7 Patterns aus
Enterprise Integration (Hohpe/Woolf, 2003) und Site Reliability Engineering
(Google, 2016) in den BergTech-HR-Chatbot ein.

> **Wichtig:** v4.7 bleibt unverändert (Prof. Saile abgenommen, "Flows sehen richtig gut aus").
> v5 ist ein paralleler Build, der zeigt, was beim Übergang in Produktion zusätzlich nötig ist.

## Warum v5?

v4.7 erfüllt die akademische Anforderung sauber: Chunking, Embedding, Vector Search,
LLM-Antwort mit Quellenbelegen. Was fehlt, sobald die App im echten BergTech-Betrieb
hängt: Resilienz, Compliance, Forensics, Multi-Provider-Vergleichbarkeit.

Die 7 Patterns adressieren genau diese Lücke. Keine Spielerei — Pflichtkost für
DSGVO Art. 30 (Verzeichnis Verarbeitungstätigkeiten) und ISO 27001 Audit Trails.

## Stack

| Komponente | v4.7 | v5-production |
|---|---|---|
| Trigger Ingestion | Manual | Manual |
| Trigger Query | Chat Trigger | Webhook + HMAC-SHA256 |
| Vector Store | Supabase pgvector | Supabase pgvector |
| Embeddings | OpenAI text-embedding-3-small | OpenAI text-embedding-3-small |
| LLM | Anthropic Claude 3.5 Haiku | Anthropic Claude 3.5 Haiku |
| Audit Storage | — | Supabase `audit_events` |
| DLQ | — | Supabase `failed_jobs` |
| Circuit Breaker | — | Supabase `circuit_breaker_state` + RPC |

## Setup

1. **Supabase Schemas anwenden:**
   ```bash
   psql $SUPABASE_URL -f ../../schemas/audit_events.sql
   psql $SUPABASE_URL -f ../../schemas/failed_jobs.sql
   psql $SUPABASE_URL -f ../../schemas/circuit_breaker_state.sql
   ```
   Oder via Supabase SQL Editor manuell.

2. **n8n Env-Variablen setzen:**
   ```
   RAG_WEBHOOK_SECRET=<32+-zeichen-secret>
   ```

3. **Workflows importieren:**
   - `rag-ingestion-v5.json`
   - `rag-query-v5.json`

4. **Credentials in n8n:**
   - Anthropic API (gleicher Credential wie v4.7)
   - OpenAI API (gleicher Credential wie v4.7)
   - Supabase (Service-Role-Key, da audit_events/failed_jobs RLS-protected sind)

## Test (Query-Workflow, HMAC)

```bash
SECRET="changeme-dev-only"
BODY='{"query":"Wie viele Urlaubstage habe ich?","user_id":"u123"}'
SIG="sha256=$(echo -n "$BODY" | openssl dgst -sha256 -hmac "$SECRET" -hex | cut -d ' ' -f 2)"

curl -X POST "http://localhost:5678/webhook/rag-chat-v5" \
  -H "Content-Type: application/json" \
  -H "X-Webhook-Signature: $SIG" \
  -d "$BODY"
```

Erwartete Antwort: `200 OK` mit `{response, request_id}`.
Ohne Signatur: `401 Unauthorized`.
Bei Prompt-Injection-Versuch (z.B. "ignore previous instructions ..."): `400 Bad Request`.

## Pattern-Map

| # | Pattern | Wo im Workflow |
|---|---|---|
| 1 | **HMAC Signature** | Query: `Verify HMAC` Code-Node |
| 2 | **Schema Validation** | Ingestion: `Validate + Hash`. Query: `Validate Schema` |
| 3 | **Dead-Letter Queue (DLQ)** | Ingestion + Query: `DLQ: Failed Job` Supabase-Insert |
| 4 | **Structured Logging** | Jeder Code-Node setzt `log` als JSON-String |
| 5 | **Rate Limit + Backoff** | LangChain-Nodes handhaben 429 nativ (max_retries) |
| 6 | **Circuit Breaker** | `CB Check` Code-Node + `circuit_breaker_state` Tabelle |
| 7 | **Audit Logs** | Jeder kritische Punkt: `Audit: Started/Skipped/Failed/Completed` |

Zusätzlich: **Idempotency** über `file_hash` (sha256) in Ingestion — Re-Ingest desselben
Dokuments erzeugt kein Duplikat im Vector Store, sondern wird beim nächsten Schritt
deduplizierbar (über Metadata-Filter).

## Akademischer Bezug

- **Hohpe, Gregor; Woolf, Bobby:** "Enterprise Integration Patterns" (Addison-Wesley, 2003) — DEC-Pflichtliteratur Modul 52040 "Application Systems Platforms"
- **Nygard, Michael:** "Release It! Design and Deploy Production-Ready Software" (Pragmatic Bookshelf, 2007/2018) — Quelle des Circuit-Breaker-Patterns
- **Beyer, Betsy et al.:** "Site Reliability Engineering" (O'Reilly, 2016) — Structured Logging, SLI/SLO-Konzept

## Nicht enthalten (bewusst skipped für v5)

- **Reconciliation Worker** für DLQ (eigene Sub-Workflows): Phase v6
- **Real Distributed Tracing** (OpenTelemetry): out-of-scope für Studi-Demo
- **Embedding-Drift-Monitoring**: gehört in MLOps, nicht in den Workflow

## Limitationen für Saile-Q&A

Ehrlich antworten:

- **Circuit Breaker State liegt in Supabase** — bei Supabase-Ausfall kein CB-Schutz mehr. In Produktion: Redis oder lokaler Memcached.
- **HMAC-Secret in Env** — bei Multi-Tenant pro-User-Secret nötig (HMAC mit per-user-keys). Aktuell single-shared-secret reicht für single-tenant BergTech.
- **Prompt-Injection-Filter ist regex-basiert** — fängt Standard-Angriffe ab, aber kein semantischer Schutz. Für High-Stakes: dediziertes Guardrails-Modell (z.B. NeMo Guardrails) davorschalten.
