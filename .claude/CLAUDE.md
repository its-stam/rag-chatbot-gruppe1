# RAG Chatbot — LLM & Agentics (Saile)
## Gruppe 1: Anastasiia (Nastja), Juliana, Rustam

**Abgabe:** 31.05.2026 | **Präsentation:** 01.06.2026

## Projekt-Kontext (von Hermes und Claude Code geteilt)

Lade beim Session-Start immer diese Dateien (falls vorhanden):
- `CONTEXT_SAVE_*.md` — letzter gespeicherter Stand (von /context-save)
- `docs/projektjournal.md` — Timeline und offene Punkte
- `docs/praesentation-leitfaden.md` — Step-by-Step für die Live-Demo

## Wichtige Dateien

- Workflow: `workflows/v4.7/rag-workflows-v4.7.2.json` (gpt-5-mini, topK 8, nur anastasiia/-Set)
- Architektur: `docs/architecture.html`
- Gruppendoku: `docs/BergTech_RAG_Dokumentation_Final_1.docx`
- Feedback an Nastja: `docs/gruppendoku-feedback-anastasiia.md`

## Tech Stack

- n8n (lokal, Docker) + Supabase pgvector
- LLM: OpenAI gpt-5-mini (OpenAI Functions Agent)
- Embeddings: text-embedding-3-small
- Chunking: 500 Zeichen, Overlap 50
- Retrieve: topK=8, Cosine Similarity

## Regeln

- NIE Committen/Pushen ohne Rustams explizites "ja"
- Individual Reports + Unterschriften NIEMALS committen
- Gruppendoku ist Nastjas Ownership — nur Feedback, keine direkten Edits
