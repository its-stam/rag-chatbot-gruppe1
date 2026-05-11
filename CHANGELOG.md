# Changelog — RAG Chatbot Project

## [Unreleased]

### 11.05.2026
- 🔧 Workflow v4.3: Modell-Update + Embedding-Fix + Default-Hardening
- 🔧 Claude Haiku: `claude-3-haiku-20240307` → `claude-3-5-haiku-20241022` (schneller, günstiger)
- 🐛 Embedding-Modell explizit gesetzt: `text-embedding-3-small` in beiden Nodes (vorher Default `ada-002`)
- 🐛 Docs-Fix: "500 Tokens" → "500 Zeichen" (Splitter arbeitet Char-basiert)
- ⚡ executionOrder: v1 → v2
- 📝 Implementation Reflection erweitert: 2 neue What-Went-Wrong (#5 Embedding-Default, #6 Char-vs-Token)
- 📝 Q&A-Vorbereitung: 9 Saile-Fragen mit Redeskript (15-Min-Präsi + 10-Min-Q&A)
- 📝 2 neue Lessons Learned (#2 erweitert, #7 neu)

### 10.05.2026 (Nacht)
- ✅ Workflow v4.2 live auf GitHub: workflows/rag-workflows-combined.json
- 🔧 Echter n8n-Export: Ingestion + Query auf einer Canvas mit Sticky Notes
- 🗂 Alte Workflow-Versionen (v1–v3 Einzeldateien) gelöscht
- 📝 Workflow-Name: "RAG Chatbot — Ingestion + Query (v4.2 — Gruppe 1, Case 1)"
- ✅ Saile-konform: 3 Hauptnodes pro Section (Manual Trigger + Read Files + Supabase / Chat Trigger + AI Agent + Respond)
- ⏳ Offen: Supabase Credentials + OpenAI Key + Dateipfad → ab 13.05

### 10.05.2026
- 🔧 LLM-Provider in Docs neutralisiert (Anthropic Chat + OpenAI Embeddings)
- 🧹 Alte PRD-PDFs (v1-v4) gelöscht, nur PRD.md + Saile-Assignment
- 📝 README: Ordnerstruktur korrigiert, Team-Kontakt vervollständigt
- 🗂 UNI-Ordner aufgeräumt: projekt-2-rag-chatbot
- 🔄 Firmenname bestätigt: BergTech Maschinenbau GmbH (Saile-Transkript)
- ✅ Workflow v4.2: Ingestion + Query kombiniert, n8n-Export ready
  - 3 Nodes/Section, Saile-konform
  - Stack: Supabase + Anthropic (Chat) + OpenAI (Embeddings)
  - Chunking: 500/50, Retrieval: top-5
  - System Prompt: Fakten-only, Source-Citation, Fallback
- ✅ Phase 1+Workflow abgeschlossen
- ⏳ Phase 3 Setup ab 13.05: Supabase + Credentials + Live-Test
- ✅ Workflow v4 erstellt: ingestion-v4.3.json + query-v4.1.json (3 Hauptnodes + 3 Sub-Nodes, Saile-konform)
- 🐛 n8n Fehler gefixt: Text Splitter Sub-Node-Connection, Embeddings Modes, System-Prompt-Location
- ✅ Workflows lokal getestet, n8n-importierbar

### 09.05.2026
- ✅ PRD v4 erstellt (Requirements, Roadmap, Success Criteria)
- ✅ README & Ordnerstruktur angelegt
- ✅ Case definiert: BergTech Maschinenbau GmbH — HR Knowledge Assistant
- ✅ 3 Demo-Fragen definiert (Onboarding, Urlaub, Pflichttrainings)
- ✅ 5 HR-Dokumente geschrieben (Deutsch, RAG-optimiert, `company-docs/rustam/`)
- ✅ RAG-Kollision gefixt: FAQ Formular-Präfix-Aussage korrigiert
- ✅ Englische root-Docs gelöscht (Verwirrung eliminiert)
- ✅ Alles gepusht auf GitHub (its-stam/rag-chatbot-gruppe1)
- ⏳ Juliana + Anastasiia: je 5 Docs ausstehend

---

## Phases

### Phase 1: Planning
**Start:** 09.05.2026 | **End:** 09.05.2026 | **Status:** ✅ DONE
- [x] PRD schreiben
- [x] Ordnerstruktur
- [x] Case definieren (BergTech HR)
- [x] 5 HR-Docs geschrieben + gepusht (company-docs/rustam/)
- [x] 3 Testfragen definiert

### Phase 2: Setup
**Start:** next | **End:** +3 days  
- [ ] Supabase Project
- [ ] LLM API Key
- [ ] n8n Cloud/Self-Hosted
- [ ] PDFs in `/company-docs/`

### Phase 3: Implementation
**Start:** +4 days | **End:** +8 days  
- [ ] Workflow 1: Ingestion (PDF → Vector)
- [ ] Workflow 2: Query (Retrieval → LLM)
- [ ] E2E Testing (3 Testfragen)
- [ ] JSON Exports

### Phase 4: Documentation
**Start:** +9 days | **End:** +11 days  
- [ ] 10-Seiten Doku
- [ ] EU AI Act Analyse
- [ ] Screenshots + Diagramme
- [ ] PDF Generation

### Phase 5: Presentation
**Start:** +13 days | **End:** 31.05.2026  
- [ ] Slides 15 Min
- [ ] Live Demo Rehearsal
- [ ] Speaker Notes
- [ ] Q&A Prep

---

## Issue Tracking

### Open
- **#3:** Supabase + LLM API Setup pending

### In Progress
- None yet

### Closed
- **#1:** Case definiert (BergTech HR, 09.05)
- **#2:** 5 HR-Docs geschrieben + gepusht (09.05)

---

## Notes

- Saile Tip: Keep n8n simple (3-4 nodes)
- Grading: Präsentation > Dokumentation
- EU AI Act: Must-Have für Kurs
- Individual Reports: Jeder einzeln

---

**Last Updated:** 11.05.2026  
**Next Sync:** 13.05 (Phase 3 Setup-Start)
