# Build Log — n8n RAG Chatbot

**Owner:** Rustam (Tech)
**Konsumenten:** Juliana (Doku), Anastasiia (Slides)
**Update-Frequenz:** Nach jedem signifikanten Schritt

---

## Iterationen

### [2026-05-11] Iteration 2 — Workflow v4.3 Hardening

**Phase:** Setup (Pre-Sprint, Post-Review)
**Status:** done

**Was gebaut:**
- Workflow v4.3: Alle Defaults eliminiert, Konfiguration explizit gehärtet
- Modell-Update: Claude `3-haiku` → `3-5-haiku` (schneller, günstiger, bessere Antworten)
- Embedding-Modell explizit: `text-embedding-3-small` in beiden Nodes (vorher lief Default `ada-002` stillschweigend)
- executionOrder: v1 → v2

**Gefundene Bugs (Opus + DeepSeek Review, 11.05):**
1. Embedding-Default-Falle: `"options": {}` → n8n nutzt `ada-002`. Doku sagte `3-small`. Inkonsistenz.
2. Char-vs-Token: Splitter arbeitet Zeichen-basiert, Doku behauptete "500 Tokens"
3. Veraltetes Modell: `claude-3-haiku` (2024) → `claude-3-5-haiku` (2025)
4. executionOrder v1 → v2 (Performance)

**Doku-Take-Aways (für Juliana):**
- Embedding-Modell-Mismatch dokumentieren (Lesson Learned: Defaults nie vertrauen)
- Chunking: Character Splitter ≠ Token Splitter erklären
- Q&A-Sektion in Reflection hat 9 vorbereitete Saile-Fragen

**Slide-Take-Aways (für Anastasiia):**
- "Warum 5 Iterationen?" → v1-v3 KI-generiert, v4 manuell, v4.3 gehärtet
- Embedding-Konsistenz als Slide (Write und Read müssen identisches Modell sein)
- Default-Falle als "Was wir gelernt haben"-Slide

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
- Chunking: 500 Zeichen, 50 Overlap (RecursiveCharacterTextSplitter = Char-basiert, nicht Token-basiert)
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
| Pre   | 11.05 | ✅ Done | Workflow v4.3 Hardening, Q&A-Vorbereitung |
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
