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
- Workflow 1 Skeleton: Ingestion (Manual Trigger → Read Files → Extract Text → Embedding → Supabase Insert) — 5 Nodes
- Workflow 2 Skeleton: Query (Webhook → Parse Question → Embed → Similarity Search → Build Prompt → LLM Call → Format → Response) — 8 Nodes
- Workflow-JSONs in `/workflows/ingestion-v1.json` + `/workflows/query-v1.json`

**Konfiguration:**
- Umgebungsvariablen benötigt: `LLM_API_BASE`, `LLM_CHAT_MODEL`, `EMBEDDING_MODEL`, Supabase Credentials
- Embedding-Model separat konfigurierbar (nicht an Chat-Model gebunden)
- System-Prompt vorbereitet mit NovaWork-Kontext + "Ich weiß nicht"-Fallback

**Probleme:**
- Supabase noch nicht aufgesetzt (Juliana-Task, blockiert E2E-Test)
- Read Binary Files Node in n8n liest nur lokale Pfade — für Docker muss Volume gemountet sein
- Webhook-Authentifizierung (HMAC) noch nicht eingebaut, für Phase 3 eingeplant

**Screenshots:**
- Noch keine (erst nach Import in n8n)

**Doku-Take-Aways (für Juliana):**
- Architecture Overview: Node-by-Node Diagramm aus Ingestion + Query Workflow
- Workflow Details: genau diese 5+8 Nodes mit Screenshots dokumentieren

**Slide-Take-Aways (für Anastasiia):**
- Live Demo: beide Workflows nacheinander zeigen (Ingestion auslösen → Chat-Frage stellen → Antwort erscheint)
- Architektur-Slide: diese Pipelines visualisieren

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
