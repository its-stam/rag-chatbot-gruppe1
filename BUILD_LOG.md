# Build Log — n8n RAG Chatbot
## Iterationsprotokoll für Doku + Präsi

**Owner:** Rustam (Tech)
**Konsumenten:** Juliana (Doku), Anastasiia (Slides)
**Update-Frequenz:** Nach jedem signifikanten Schritt

---

## Format pro Eintrag

```
### [YYYY-MM-DD HH:MM] Iteration N — Kurztitel

**Phase:** Setup / Ingestion / Query / Demo / Deployment
**Status:** in progress / done / blocked

**Was gebaut:**
- Konkreter Schritt 1
- Konkreter Schritt 2

**Konfiguration:**
- Node-Typ, Parameter, API-Endpoints

**Probleme:**
- Was lief nicht, wie gelöst (für Reflection)

**Screenshots:**
- /workflows/screens/iter-N-title.png

**Doku-Take-Aways (für Juliana):**
- Was muss in welchen Doku-Abschnitt

**Slide-Take-Aways (für Anastasiia):**
- Welche Visuals/Erklärungen für Präsi
```

---

## Iterationen

### [2026-05-10 01:00] Iteration 0 — Workflow-Skeletons

**Phase:** Setup (Pre-Sprint)
**Status:** done

**Was gebaut:**
- Workflow 1 v1: Ingestion (5 Nodes) — Erstversion
- Workflow 2 v1: Query (8 Nodes) — Erstversion
- v1 Issues identifiziert (kein Chunking, Binary-Data-Bug, kein Auth)

### [2026-05-10 01:30] Iteration 0.5 — v2 Fixes

**Phase:** Setup (Pre-Sprint)
**Status:** done

**Was gefixt (alle 5 Issues aus v1):**
- ✅ Chunking: Text-Splitter mit 500 Token + 50 Overlap
- ✅ Binary-Data: Extract liest jetzt `item.binary` (Base64 decode), nicht `item.json.data`
- ✅ Dedup: chunk_id-basierte Deduplizierung vor Embedding
- ✅ Webhook Auth: `callerPolicy` auf `headerAuth`, Validate-Node vorbereitet
- ✅ max_tokens: 500 → 1000

**Probleme:**
- Dedup ist noch Pass-Through (braucht Supabase-Verbindung für echte Query)
- Chunk-Size 500 Tokens geschätzt (Wort-basiert) — genauer mit n8n Text-Splitter-Node in Phase 3
- Embedding API Rate-Limiting: batchInterval 3000ms gesetzt, muss live getestet werden

**Nächste Schritte:**
1. Supabase Project anlegen + pgvector Extension aktivieren (Juliana-Task)
2. LLM API Key bereitstellen (in .env, niemals committen)
3. Workflows in n8n importieren (localhost:5678)
4. Nodes verkabeln mit echten Credentials

---

## Sprint-Übersicht (geplant)

| Sprint | Datum | Iteration | Owner | Output |
|--------|-------|-----------|-------|--------|
| Pre   | 10.05 | Workflow-Skeletons | Rustam | ingestion-v1.json + query-v1.json |
| 1 | 13.05 | Setup (Supabase + n8n + Keys) | Rustam + Juliana | Funktionierende Basis |
| 2 | 14.05 | Workflow 1: Ingestion live | Rustam | MDs lesen + embedden + insert |
| 3 | 15.05 | Workflow 2: Query live | Rustam | Erste Antworten auf Demo-Fragen |
| 4 | 16.-17.05 | Retrieval Tuning + System Prompt | Rustam | 3 Demo-Fragen funktionieren |
| 5 | 18.-19.05 | E2E Test + JSON Export | Rustam | Submission-fähig |
| 6 | 20.-21.05 | (Optional) Online Deployment | Rustam | 1.0-Bonus |

---

## Konventionen

- **Screenshots:** `/workflows/screens/iter-N-titel.png`
- **JSON Exports:** `/workflows/ingestion-vN.json`, `/workflows/query-vN.json`
- **System Prompts:** `/workflows/prompts/system-vN.md`
- **API Keys:** **NIEMALS** in Files committen, nur lokal in `.env`
