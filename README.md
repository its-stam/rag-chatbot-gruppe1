# RAG Chatbot — LLM & Agentics Prüfung

**Kurs:** LLM & Agentics (Dozent: Hr. Saile)  
**Deadline:** 31.05.2026  
**Team:** Gruppe 1 — Anastasiia Sereda, Juliana Paar, Rustam Kohen

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
│   ├── juliana/                     # 5 Docs (ausstehend)
│   └── anastasiia/                  # 5 Docs (ausstehend)
├── /individual-reports
│   ├── juliana-individual-report.md
│   ├── anastasiia-individual-report.md
│   └── rustam-individual-report.md
└── CHANGELOG.md                    # Fortschritt & Änderungen
```

---

## 🎯 Quick Start

### 1. Case definieren (today)
- [x] Firma/Szenario wählen → BergTech Maschinenbau GmbH (HR)
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
**Updated:** 09.05.2026

---

**Status:** 🟡 In Planung  
**Next:** Case + PDFs definieren
