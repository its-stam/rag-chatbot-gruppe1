# RAG Chatbot — LLM & Agentics Prüfung

**Kurs:** LLM & Agentics (Dozent)  
**Deadline:** 31.05.2026  
**Team:** Gruppe 1 — Teammitglied A, Teammitglied B, Rustam Kohen

---

## 📁 Ordnerstruktur

```
rag-chatbot-gruppe1/
├── PRD.md                          # Requirements & Roadmap (historisch)
├── README.md                       # Dieses File
├── CHANGELOG.md                    # Fortschritt & Phasen-Status
├── BUILD_LOG.md                    # Iterations-Log
├── RAG_Project_Assignment.pdf      # Dozent-Originalaufgabe
├── /company-docs
│   ├── README.md                   # Überblick beider Sets + Konflikte
│   ├── hr-set-a/                 # 5 .md — AKTIVES Set (ingested)
│   │   ├── 1_Onboarding_Guide_BergTech.md
│   │   ├── 2_Vacation_Policy_BergTech.md
│   │   ├── 3_Compliance_Policy_BergTech.md
│   │   ├── 4_HR_FAQ_BergTech.md
│   │   └── 5_Offboarding_Checklist_BergTech.md
│   └── rustam/                     # Quell-Archiv — NICHT ingested (Set-Entscheidung 30.05.)
│       ├── 01-onboarding-guide.md … 05-offboarding-checklist.md
│       └── pdf/                    # 5 PDFs
├── /docs
│   ├── implementation-reflection.md       # 8 Sections, 9 Learnings
│   ├── qa-brief-18-05.md                  # Q&A Dozent-Sprechstunde
│   ├── team-update-17-05.md               # Team-Sync-Briefing
│   ├── docs-review-hr-set-a.md          # Quality-Review Nastjas Docs
│   ├── gruppendoku-feedback-hr-set-a.md # Abgleich Doku vs. Live-Implementierung
│   ├── reingest-koordination.md           # Re-Ingest Ablauf Rustam + Nastja
│   └── vorschlag-arbeitszeit-faq.md       # FAQ-Ergänzungsvorschlag (Recall-Fix)
├── /workflows
│   ├── v4.7/
│   │   ├── rag-workflows-v4.7.1.json   # gpt-5-mini, Live-Stand 30.05.
│   │   └── rag-workflows-v4.7.2.json   # AKTUELL — nur hr-set-a/-Set, retrieve topK 8
│   └── _archiv/                        # v4.3, v4.4, v4.6-BROKEN, v4.7-claude-PRE-SWITCH
└── /individual-reports
    ├── Contribution_Report_Rustam_Kohen.docx
    ├── Contribution_Report_Teammitglied B_Paar.docx
    └── Contribution_Report_Teammitglied A_Teammitglied A.docx
```

**Geplant für später (noch nicht angelegt):**
- `docs/eu-ai-act-analysis.md` — EU AI Act (Teammitglied A)
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

### 2. HR-Dokumente ✅
- [x] hr-set-a/-Set: 5 Docs (.md) — **AKTIVES Set, ingested**
- [x] rustam/-Set: 5 Docs + PDFs — als Quell-Archiv behalten, NICHT ingested
- [x] Set-Entscheidung getroffen (30.05.): nur hr-set-a/-Set in der Vektor-DB

### 3. n8n Workflows ✅
- [x] Supabase Project + pgvector (Teammitglied B)
- [x] Supabase Credentials in n8n
- [x] OpenAI API Key in n8n Credentials (Chat + Embeddings)
- [x] Workflow Ingestion (Manual Trigger → Files → Vector Store)
- [x] Workflow Query (Chat Trigger → AI Agent → Tool: Vector Store)
- [x] JSON Export (workflows/v4.7/rag-workflows-v4.7.2.json)
- [x] E2E Live-Test mit den 3 Testfragen (30.05.)

### 4. Dokumentation ⏳
- [x] Implementation-Reflection (8 Sections, 9 Learnings)
- [x] Q&A-Brief für Dozent-Sprechstunde
- [ ] 10-Seiten Doku zusammenführen
- [ ] EU AI Act Analyse (Teammitglied A)
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
| Phase 2: Setup (Supabase + Credentials) | ~20.05.2026 | ✅ Done — Supabase live, OpenAI Keys ✅ |
| Phase 3: Implementation (Workflow + Ingestion) | ~22.05.2026 | ✅ Done — v4.7.2 (gpt-5-mini, nur hr-set-a/-Set), E2E-Test 30.05. |
| Phase 4: Documentation (10 Seiten + EU AI Act + Risks) | ~28.05.2026 | 🟡 In Progress (Reflection ✅, Gruppendoku-Draft ✅, EU AI Act + Architektur + Risks offen) |
| Phase 5: Presentation (Slides + Rehearsal) | 30.05.2026 | ⏳ |
| Submission (Teams) | 31.05.2026 | ⏳ |
| Live-Präsentation | 01.06.2026 | ⏳ |

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
**Updated:** 30.05.2026

---

**Status:** ✅ Implementation + Live-Test done (gpt-5-mini, 30.05.) — Doku + Slides offen
**Next:** Gruppendoku finalisieren, Architektur + Risks ergänzen, Slides bauen; Submission 31.05.
