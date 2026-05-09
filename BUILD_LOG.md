# Build Log — n8n RAG Chatbot

**Owner:** Rustam (Tech)
**Konsumenten:** Juliana (Doku), Anastasiia (Slides)
**Update-Frequenz:** Nach jedem signifikanten Schritt

---

## Iterationen

### [2026-05-10 02:45] Iteration 1 — Workflow v4.2 Final

**Phase:** Setup (Pre-Sprint)
**Status:** done

**Was gebaut:**
- Workflow v4.2: Ingestion + Query kombiniert in einem n8n-Export
- Ingestion: Manual Trigger → Read Files → Supabase Vector Store + Embeddings (OpenAI) + Data Loader + Text Splitter (500/50)
- Query: Chat Trigger → AI Agent → Respond + Chat Model (Anthropic Claude Haiku) + Supabase Vector Tool + Embeddings (OpenAI)
- 3 sichtbare Nodes pro Section (Saile-konform)

**Konfiguration:**
- Embedding: OpenAI text-embedding-3-small
- Chat: Anthropic Claude 3 Haiku (temperature 0.3)
- Chunking: 500 Tokens, 50 Overlap
- System Prompt: BergTech Maschinenbau GmbH, 4 Regeln (Fakten-only, Quellen-Zitat, Fallback, keine Spekulation)
- Retrieval: top-5 matches aus Supabase

**Probleme:**
- v1: kein Chunking → verworfen
- v2: over-engineered (8+9 Nodes) → verworfen
- v3: falsche Node-Types → verworfen
- Name-Chaos: BergTech → NovaWork → BergTech (Saile-Transkript bestätigt BergTech)
- CCR DeepSeek 400-Fehler: Thinking-Mode disabled via Transformer-Config

### Nächste Schritte (Phase 3, ab 13.05)

1. Supabase Project + pgvector + documents Table (Juliana-Task. Rustam kann vorziehen)
2. Anthropic + OpenAI API Keys in n8n Credentials eintragen
3. Workflow in n8n importieren + testen
4. 3 Demo-Fragen durchlaufen (Onboarding Docs, Urlaubsfrist, Pflichttrainings)
5. E2E Test + JSON Export

---

## Sprint-Übersicht

| Sprint | Datum | Status | Output |
|--------|-------|--------|--------|
| Pre   | 10.05 | ✅ Done | Workflow v4.2, Docs gepusht, Name fix |
| 1 | 13.05 | ⏳ | Supabase + Credentials |
| 2 | 14.-15.05 | — | Workflow live testen |
| 3 | 16.-19.05 | — | 3 Demo-Fragen, Tuning |
| 4 | 20.-21.05 | — | E2E Test, Deployment (optional) |
| 5 | 22.-27.05 | — | Doku + EU AI Act |
| 6 | 28.-31.05 | — | Slides, Rehearsal, Submission |

---

## Konventionen

- **Screenshots:** `/workflows/screens/iter-N-titel.png`
- **JSON Exports:** `/workflows/rag-workflows-combined.json`
- **System Prompts:** `/workflows/prompts/system-vN.md`
- **API Keys:** **NIEMALS** in Files committen, nur lokal in `.env`
