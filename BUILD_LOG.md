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

### [TBD] Iteration 0 — Setup-Plan

**Phase:** Setup
**Status:** Pending

**Was gebaut:**
- Noch nichts, Build startet nach Phase 2 (Doku-Erstellung 10.-12.05)

**Nächste Schritte:**
1. Supabase Project anlegen + pgvector Extension aktivieren
2. LLM API Key besorgen
3. n8n via Docker lokal starten
4. Erste Workflow-Skeletons

---

## Sprint-Übersicht (geplant)

| Sprint | Datum | Iteration | Owner | Output |
|--------|-------|-----------|-------|--------|
| 1 | 13.05 | Setup (Supabase + n8n + Keys) | Rustam | Funktionierende Basis |
| 2 | 14.05 | Workflow 1: Ingestion Skeleton | Rustam | PDFs lesen + chunken |
| 3 | 15.05 | Workflow 1: Vector Store Insert | Rustam | Embeddings in Supabase |
| 4 | 16.-17.05 | Workflow 2: Chat Trigger + AI Agent | Rustam | Erste Antworten |
| 5 | 18.-19.05 | Retrieval Tuning + System Prompt | Rustam | 3 Demo-Fragen funktionieren |
| 6 | 20.05 | E2E Test + JSON Export | Rustam | Submission-fähig |
| 7 | 21.-22.05 | (Optional) Online Deployment | Rustam | 1.0-Bonus |

---

## Konventionen

- **Screenshots:** `/workflows/screens/iter-N-titel.png`
- **JSON Exports:** `/workflows/ingestion-vN.json`, `/workflows/query-vN.json`
- **System Prompts:** `/workflows/prompts/system-vN.md`
- **API Keys:** **NIEMALS** in Files committen, nur lokal in `.env`
