# Changelog — RAG Chatbot Project

## [Unreleased]

### 17.05.2026
- 🐛 Workflow v4.7: Chat Trigger Fix — v4.6 hatte `n8n-nodes-base.webhook` statt `@n8n/n8n-nodes-langchain.chatTrigger` → kein n8n Chat-Sidebar möglich
- 🔧 v4.7: `When chat message received` Node (langchain, public=true), Respond-to-Webhook entfernt (AI Agent letztes Node)
- 🐛 Sticky Note Typo gefixt: QUERRY → QUERY
- 📁 workflows/_archiv/ angelegt: v4.3, v4.4, v4.6-BROKEN archiviert (workflows/ enthält nur noch v4.7)
- 📄 5 HR-Docs als PDF konvertiert (Dozent-Vorgabe: PDF-Upload) → company-docs/rustam/pdf/
- 🔧 GitHub Repo-Description: NovaWork → BergTech HR (Case 1, Dozent)
- 📝 README Typo: doppeltes "Maschinenbau GmbH"

### 16.05.2026
- 🐛 Workflow v4.4: Read/Write Files from Disk — Operation + fileSelector gefixt (waren leer → ⚠️ in n8n)
- 🐛 Supabase Vector Store (retrieve) — tableName von leerem Resource-Locator auf "documents" gesetzt
- 📝 Team-Status: WhatsApp-Update an Gruppe gesendet, Q&A 18.05. via Transkript bestätigt

### 11.05.2026
- 🔧 Workflow v4.3: Modell-Update + Embedding-Fix + Default-Hardening
- 🔧 Claude Haiku: `claude-3-haiku-20240307` → `claude-3-5-haiku-20241022` (schneller, günstiger)
- 🐛 Embedding-Modell explizit gesetzt: `text-embedding-3-small` in beiden Nodes (vorher Default `ada-002`)
- 🐛 Docs-Fix: "500 Tokens" → "500 Zeichen" (Splitter arbeitet Char-basiert)
- ⚡ executionOrder: v1 → v2
- 📝 Implementation Reflection erweitert: 2 neue What-Went-Wrong (#5 Embedding-Default, #6 Char-vs-Token)
- 📝 Q&A-Vorbereitung: 9 Dozent-Fragen mit Redeskript (15-Min-Präsi + 10-Min-Q&A)
- 📝 2 neue Lessons Learned (#2 erweitert, #7 neu)

### 10.05.2026 (Nacht)
- ✅ Workflow v4.2 live auf GitHub: workflows/rag-workflows-combined.json
- 🔧 Echter n8n-Export: Ingestion + Query auf einer Canvas mit Sticky Notes
- 🗂 Alte Workflow-Versionen (v1–v3 Einzeldateien) gelöscht
- 📝 Workflow-Name: "RAG Chatbot — Ingestion + Query (v4.2 — Gruppe 1, Case 1)"
- ✅ Dozent-konform: 3 Hauptnodes pro Section (Manual Trigger + Read Files + Supabase / Chat Trigger + AI Agent + Respond)
- ⏳ Offen: Supabase Credentials + OpenAI Key + Dateipfad → ab 13.05

### 10.05.2026
- 🔧 LLM-Provider in Docs neutralisiert (Anthropic Chat + OpenAI Embeddings)
- 🧹 Alte PRD-PDFs (v1-v4) gelöscht, nur PRD.md + Dozent-Assignment
- 📝 README: Ordnerstruktur korrigiert, Team-Kontakt vervollständigt
- 🗂 UNI-Ordner aufgeräumt: projekt-2-rag-chatbot
- 🔄 Firmenname bestätigt: BergTech Maschinenbau GmbH (Dozent-Transkript)
- ✅ Workflow v4.2: Ingestion + Query kombiniert, n8n-Export ready
  - 3 Nodes/Section, Dozent-konform
  - Stack: Supabase + Anthropic (Chat) + OpenAI (Embeddings)
  - Chunking: 500/50, Retrieval: top-5
  - System Prompt: Fakten-only, Source-Citation, Fallback
- ✅ Phase 1+Workflow abgeschlossen
- ⏳ Phase 3 Setup ab 13.05: Supabase + Credentials + Live-Test
- ✅ Workflow v4 erstellt: ingestion-v4.3.json + query-v4.1.json (3 Hauptnodes + 3 Sub-Nodes, Dozent-konform)
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
- ⏳ Teammitglied B + Teammitglied A: je 5 Docs ausstehend

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
**Ziel-Ende:** ~20.05.2026 | **Status:** 🟡 LLM-Keys ✅, Supabase ausstehend
- [ ] Supabase Project + pgvector (Teammitglied B)
- [ ] Supabase Credentials in n8n
- [x] Anthropic API Key in n8n Credentials
- [x] OpenAI API Key in n8n Credentials
- [x] n8n lokal (Docker, localhost:5678)
- [x] HR-Docs als PDF (company-docs/rustam/pdf/)

### Phase 3: Implementation
**Ziel-Ende:** ~22.05.2026 | **Status:** 🟡 Workflow done, Live-Test fehlt
- [x] Workflow Ingestion (Manual Trigger → Read/Write Files → Supabase)
- [x] Workflow Query (Chat Trigger → AI Agent → Tool: Vector Store)
- [x] JSON Export (rag-workflows-v4.7.json)
- [ ] E2E Testing (3 Testfragen mit echten Embeddings, wartet auf Phase 2)

### Phase 4: Documentation
**Ziel-Ende:** ~28.05.2026 | **Status:** ⏳ Implementation-Reflection done, Rest offen
- [x] Implementation-Reflection (8 Sections, 9 Learnings)
- [x] Q&A-Brief (qa-brief-18-05.md)
- [ ] 10-Seiten Doku
- [ ] EU AI Act Analyse (Teammitglied A)
- [ ] Architektur-Diagramm
- [ ] Risk-Section (Case-1-spezifisch)
- [ ] Screenshots vom Workflow
- [ ] PDF Generation der Doku

### Phase 5: Presentation
**Ziel-Ende:** 30.05.2026 | **Status:** —
- [ ] Foliensatz (15 Min Sprechzeit)
- [ ] Live Demo Rehearsal
- [ ] Speaker Notes
- [ ] Q&A Prep (Brief existiert)

### Submission + Live-Präsi
- **Submission Teams:** 31.05.2026 | **Status:** —
- **Live-Präsentation:** 01.06.2026, 15 Min + 10 Min Q&A | **Status:** —

---

## Issue Tracking

### Open
- **#3:** Supabase + LLM API Setup (Teammitglied B)
- **#4:** EU AI Act Analyse (Teammitglied A)
- **#5:** Teammitglied Bs 5 HR-Docs (kommt noch)
- **#6:** 10-Seiten Doku zusammenführen (Gruppe)
- **#7:** Architektur-Diagramm (Rustam)
- **#8:** Risk-Section Case 1 (Gruppe)
- **#9:** Foliensatz 15 Min (Gruppe)
- **#10:** Live Demo Rehearsal (nach Supabase live)
- **#11:** Set-Auswahl rustam/ vs hr-set-a/ vs de/ (Sync-Entscheidung)

### In Progress
- Workflow Live-Test (wartet auf Supabase)
- Doku-Drafts pro Person

### Closed
- **#1:** Case definiert (BergTech HR, 09.05)
- **#2:** rustam/-Set 5 HR-Docs geschrieben + gepusht (09.05)
- **#2b:** hr-set-a/-Set 5 HR-Docs ins Repo (17.05, hochgeladen 09.05)
- **#12:** Workflow v4.7 Chat-Trigger-Fix (17.05)
- **#13:** HR-Docs als PDF konvertiert (17.05)
- **#14:** Repo-Description NovaWork → BergTech (17.05)

---

## Notes

- Dozent Tip: Keep n8n simple (3-4 nodes)
- Grading: Präsentation > Dokumentation
- EU AI Act: Must-Have für Kurs
- Individual Reports: Jeder einzeln

---

**Last Updated:** 17.05.2026  
**Next Sync:** Team-Treffen 17.05. (Set-Auswahl, Doku-Aufteilung, Präsi-Verteilung)
