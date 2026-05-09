# RAG Chatbot — LLM & Agentics Prüfung

**Kurs:** LLM & Agentics (Dozent)  
**Deadline:** 31.05.2026  
**Team:** Gruppe 1 — Teammitglied A, Teammitglied B, Rustam Kohen

---

## 📁 Ordnerstruktur

```
LLM-Agentics-RAG-Projekt/
├── PRD.md                          # Requirements & Roadmap
├── README.md                       # Dieses File
├── /docs
│   ├── documentation.md            # 10-Seiten Dokumentation (Draft)
│   ├── eu-ai-act-analysis.md       # EU AI Act Analyse
│   └── implementation-reflection.md # Learnings & Reflection
├── /workflows
│   ├── workflow-1-ingestion.json   # n8n Workflow 1 (Export)
│   ├── workflow-2-query.json       # n8n Workflow 2 (Export)
│   └── workflow-notes.md           # Node-by-Node Erklärung
├── /presentations
│   ├── slides.pdf / .pptx          # Präsentation (15 Min)
│   ├── speaker-notes.md            # Redeskript
│   └── demo-script.md              # Live Demo Script
├── /company-docs
│   ├── rustam/
│   │   ├── 01-onboarding-guide.md
│   │   ├── 02-vacation-policy.md
│   │   ├── 03-training-compliance-policy.md
│   │   ├── 04-hr-faq.md
│   │   └── 05-offboarding-checklist.md
│   ├── de/                     # 5 Docs (ausstehend)
│   └── hr-set-a/                  # 5 Docs (ausstehend)
├── /individual-reports
│   ├── team-doku-individual-report.md
│   ├── hr-set-a-individual-report.md
│   └── rustam-individual-report.md
└── CHANGELOG.md                    # Fortschritt & Änderungen
```

---

## 🎯 Quick Start

### 1. Case definieren (today)
- [x] Firma/Szenario wählen → NovaWork Maschinenbau GmbH (HR)
- [x] Firmenkontext aufschreiben
- [x] 3 Testfragen definieren

### 2. PDFs vorbereiten (next)
- [x] 5 Firmendokumente schreiben (company-docs/rustam/, Deutsch, RAG-optimiert)
- [x] In `/company-docs/rustam/` gespeichert
- [ ] Format: PDF (vor Submission generieren)

### 3. n8n Workflows (Phase 2)
- [ ] Supabase Project setup
- [ ] LLM API Key
- [ ] Workflow 1: PDFs → Vektoren → DB
- [ ] Workflow 2: Query → Retrieval → LLM Response
- [ ] Als JSON exportieren

### 4. Dokumentation (Phase 4)
- [ ] 10-Seiten Doc schreiben
- [ ] EU AI Act Analyse einbauen
- [ ] Screenshots + Diagramme
- [ ] PDF generieren

### 5. Präsentation (Phase 5)
- [ ] Slides vorbereiten (15 Min)
- [ ] Live Demo trainieren
- [ ] Speaker Notes
- [ ] Q&A Fragen antizipieren

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
| Phase 1: Planning | today | ⏳ |
| Phase 2: Setup | +3 days | — |
| Phase 3: Implementation | +6 days | — |
| Phase 4: Documentation | +10 days | — |
| Phase 5: Presentation | +12 days | — |
| Submission | 31.05.2026 | — |

---

## 📚 Resources

- **Kurs:** LLM & Agentics (Dozent)
- **n8n Docs:** https://docs.n8n.io
- **Supabase Vector:** https://supabase.com/docs/guides/ai
- **EU AI Act:** https://artificialintelligenceact.eu/

---

## ⚡ Pro Tips (von Dozent)

1. **n8n klein halten** — 3-4 Nodes max, nicht overcomplicate
2. **Live Demo ist kritisch** — 2× durchlaufen, Screenshots als Fallback
3. **Präsentation = Grading Fokus** — Doku ist supporting material
4. **EU AI Act nicht ignorieren** — essentiell für LLM-Kurs
5. **Individual Reports** — jeder schreibt was er gemacht hat

---

## 📧 Kontakt

**Team:** Rustam Kohen + Teammitglied B + Teammitglied A
**Email:** korus23@googlemail.com  
**Updated:** 09.05.2026

---

**Status:** 🟡 In Planung  
**Next:** Case + PDFs definieren
