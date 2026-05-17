# RAG Chatbot — LLM & Agentics Prüfung

**Kurs:** LLM & Agentics (Dozent: Hr. Saile)  
**Deadline:** 31.05.2026  
**Team:** Gruppe 1 — Anastasiia Sereda, Juliana Paar, Rustam Kohen

---

## 📁 Ordnerstruktur

```
rag-chatbot-gruppe1/
├── PRD.md                          # Requirements & Roadmap (historisch)
├── README.md                       # Dieses File
├── CHANGELOG.md                    # Fortschritt & Phasen-Status
├── BUILD_LOG.md                    # Iterations-Log
├── RAG_Project_Assignment.pdf      # Saile-Originalaufgabe
├── /company-docs
│   ├── README.md                   # Überblick beider Sets + Konflikte
│   ├── rustam/
│   │   ├── 01-onboarding-guide.md
│   │   ├── 02-vacation-policy.md
│   │   ├── 03-training-compliance-policy.md
│   │   ├── 04-hr-faq.md
│   │   ├── 05-offboarding-checklist.md
│   │   └── pdf/                    # 5 PDFs (Saile-Submission)
│   ├── anastasiia/                 # 5 .docx + 5 .md
│   └── juliana/                    # kommt noch
├── /docs
│   ├── implementation-reflection.md  # 8 Sections, 9 Learnings
│   ├── qa-brief-18-05.md             # Q&A Saile-Sprechstunde
│   └── team-update-17-05.md          # Team-Sync-Briefing
├── /workflows
│   ├── rag-workflows-v4.7.json     # Aktuelle Version (Ingestion + Query)
│   └── _archiv/                    # v4.3, v4.4, v4.6-BROKEN
└── /individual-reports
    ├── Contribution_Report_Rustam_Kohen.docx
    ├── Contribution_Report_Juliana_Paar.docx
    └── Contribution_Report_Anastasiia_Sereda.docx
```

**Geplant für später (noch nicht angelegt):**
- `docs/eu-ai-act-analysis.md` — EU AI Act (Anastasiia)
- `docs/architecture.md` — Architektur-Diagramm
- `docs/risks.md` — Risk-Section Case 1
- `docs/documentation.md` — 10-Seiten Doku
- `presentations/` — Slides + Speaker Notes + Demo Script

---

## 🎯 Quick Start

### 1. Case definiert ✅
- [x] Firma/Szenario → BergTech Maschinenbau GmbH (HR Knowledge Assistant)
- [x] Firmenkontext aufgeschrieben
- [x] 3 Testfragen definiert (Onboarding, Urlaub, Pflichttrainings)

### 2. HR-Dokumente ✅ (Set-Auswahl ausstehend)
- [x] rustam/-Set: 5 Docs in Deutsch, RAG-optimiert
- [x] anastasiia/-Set: 5 Docs als .docx + .md
- [ ] juliana/-Set: kommt noch
- [x] PDF-Konvertierung des rustam/-Sets
- [ ] Set-Auswahl oder Merge (beim Team-Sync klären)

### 3. n8n Workflows 🟡
- [ ] Supabase Project + pgvector (Juliana)
- [ ] LLM API Keys in n8n Credentials
- [x] Workflow Ingestion (Manual Trigger → Files → Vector Store)
- [x] Workflow Query (Chat Trigger → AI Agent → Tool: Vector Store)
- [x] JSON Export (workflows/rag-workflows-v4.7.json)
- [ ] E2E Live-Test mit den 3 Testfragen

### 4. Dokumentation ⏳
- [x] Implementation-Reflection (8 Sections, 9 Learnings)
- [x] Q&A-Brief für Saile-Sprechstunde
- [ ] 10-Seiten Doku zusammenführen
- [ ] EU AI Act Analyse (Anastasiia)
- [ ] Architektur-Diagramm
- [ ] Risk-Section (Case-1-spezifisch)
- [ ] PDF generieren

### 5. Präsentation —
- [ ] Foliensatz für 15 Min Sprechzeit
- [ ] Live Demo Rehearsal
- [ ] Speaker Notes
- [ ] Q&A Prep (Brief existiert)

---

## 📋 Checkliste bis 31.05

### Documentation
- [ ] Company Situation (1 S.)
- [ ] Architecture (1 S.)
- [ ] Workflow Details (2 S.)
- [ ] Example Questions (1 S.)
- [ ] Risks (1 S.)
- [ ] EU AI Act (1.5 S.)
- [ ] Reflection (1.5 S.)
- [ ] Appendix (notes, logs, code)

### Presentation
- [ ] Slides ready
- [ ] Timing 15 ± 1 Min
- [ ] Live Demo functional
- [ ] Speaker notes
- [ ] Q&A vorbereitet

### Submission (via Teams)
- [ ] Project Documentation
- [ ] Presentation File
- [ ] n8n Workflow JSONs (im Appendix oder extra)
- [ ] Individual Grading Report (Rustam)

---

## 🚀 Key Milestones

| Phase | Deadline | Status |
|-------|----------|--------|
| Phase 1: Planning | 09.05.2026 | ✅ Done |
| Phase 2: Setup (Supabase + Credentials) | ~20.05.2026 | ⏳ Supabase-Setup läuft (Juliana) |
| Phase 3: Implementation (Workflow + Ingestion) | ~22.05.2026 | 🟡 Großteils done — v4.7 gepusht, Live-Test fehlt |
| Phase 4: Documentation (10 Seiten + EU AI Act + Risks) | ~28.05.2026 | ⏳ In Progress (implementation-reflection ✅, Rest offen) |
| Phase 5: Presentation (Slides + Rehearsal) | 30.05.2026 | — |
| Submission (Teams) | 31.05.2026 | — |
| Live-Präsentation | 01.06.2026 | — |

---

## 📚 Resources

- **Kurs:** LLM & Agentics (Saile)
- **n8n Docs:** https://docs.n8n.io
- **Supabase Vector:** https://supabase.com/docs/guides/ai
- **EU AI Act:** https://artificialintelligenceact.eu/

---

## ⚡ Pro Tips (von Saile)

1. **n8n klein halten** — 3-4 Nodes max, nicht overcomplicate
2. **Live Demo ist kritisch** — 2× durchlaufen, Screenshots als Fallback
3. **Präsentation = Grading Fokus** — Doku ist supporting material
4. **EU AI Act nicht ignorieren** — essentiell für LLM-Kurs
5. **Individual Reports** — jeder schreibt was er gemacht hat

---

## 📧 Kontakt

**Team:** Rustam Kohen + Juliana Paar + Anastasiia Sereda
**Email:** korus23@googlemail.com  
**Updated:** 17.05.2026

---

**Status:** 🟡 Implementation done, Live-Test + Doku offen
**Next:** Team-Sync 17.05. → Set-Auswahl + Doku-Aufteilung; Q&A Saile 18.05. 8:00
