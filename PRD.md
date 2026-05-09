# Product Requirements Document — RAG Chatbot
## LLM & Agentics Kurs (Prof. Saile) | v4

**Status:** Active  
**Version:** 4.0 (09.05.2026)  
**Submission Deadline:** 31.05.2026  
**Presentation:** 01.06.2026 (15 Min + 10 Min Q&A)  
**Team:** Gruppe 1 (Juliana Paar, Anastasiia Sereda, Rustam Kohen)  
**Goal:** **Note 1.0**

---

## Executive Summary

**Case 1 — HR Knowledge Assistant für BergTech Maschinenbau GmbH**

Entwicklung eines RAG-Chatbots, der HR-Mitarbeiter und Angestellte bei repetitiven Fragen entlastet (Onboarding, Urlaubsregeln, Trainings, interne HR-Prozesse). Stack: **n8n (lokal) + Supabase + OpenRouter/OpenAI**.

---

## Case Definition

### Company Situation
**BergTech Maschinenbau GmbH** — mittelständisches Maschinenbauunternehmen, 450 Mitarbeiter. Die HR-Abteilung erhält viele repetitive Fragen zu Onboarding, Urlaub, Trainings und internen Prozessen.

### Main Focus
- Employee Knowledge Access
- Onboarding Efficiency
- HR Compliance

### Target Users
- Neue Mitarbeiter (Onboarding-Fragen)
- Bestehende Mitarbeiter (Urlaub, Trainings, Policies)
- HR-Team (Entlastung von Routine-Anfragen)

---

## Required Document Database (5 PDFs)

| # | Dokument | Inhalt |
|---|----------|--------|
| 1 | Onboarding Guide | First-Day Checklist, benötigte Dokumente, Ansprechpartner |
| 2 | Vacation and Absence Policy | Urlaubsregeln, Antragsfristen, Krankmeldung |
| 3 | Training and Compliance Policy | Pflichttrainings, Compliance, Schulungspläne |
| 4 | HR FAQ Document | Top 20 wiederkehrende Fragen |
| 5 | Employee Offboarding Checklist | Austrittsprozess, Übergabe, Equipment |

### Document Authoring Guidelines (RAG-Optimized)

Die 5 Dokumente werden so strukturiert, dass Chunking + Retrieval optimal funktionieren.

**TO DO:**
- Klare Überschriften und Unterüberschriften (H1/H2/H3 sauber genutzt)
- Inhalte in kurze, thematisch abgeschlossene Abschnitte
- Konsistente Fachbegriffe, alle relevanten Begriffe explizit nennen
- Präzise und eindeutige Formulierungen, nur eine Schriftart
- Listen und nummerierte Schritte bei Prozessen
- Semantischer Zusammenhang innerhalb einzelner Abschnitte
- Sinnvolle Metadaten und Kontextinformationen ergänzen
- Informationsdicht und sachlich schreiben

**NOT TO DO:**
- Keine extrem langen Fließtexte
- Keine unnötigen Wiederholungen oder Marketing-Sprache
- Keine Themenmischung innerhalb eines Abschnitts
- Keine unklaren Abkürzungen ohne Erklärung
- Keine rein visuellen Informationen ohne Textbeschreibung
- Keine Tabellen oder Grafiken ohne Kontext
- Keine widersprüchlichen oder veralteten Informationen
- Keine riesigen Dokumentblöcke ohne Struktur

**Begründung:** RAG-Systeme zerteilen Dokumente in Chunks (z.B. 500-800 Token). Je sauberer ein Chunk ein abgeschlossenes Thema enthält, desto präziser das Retrieval und desto weniger Halluzinationen. Wirkt direkt auf die Demo-Antwortqualität.

---

## Example Questions (Demo)

1. **Was muss ein neuer Mitarbeiter vor seinem ersten Arbeitstag einreichen?**
2. **Wie viele Tage im Voraus muss Urlaub beantragt werden?**
3. **Welche Pflichttrainings müssen neue Mitarbeiter im Onboarding absolvieren?**

---

## Important Risks (HR-spezifisch)

- **Falsche HR-Guidance** → kann rechtliche Konsequenzen haben
- **Halluzinierte Policy-Infos** → Vertrauen verloren, Fehlentscheidungen
- **Verarbeitung sensibler Mitarbeiterdaten** → DSGVO-Risiko

---

## Requirements

### Functional Requirements

| Req | Beschreibung | Priority |
|-----|-------------|----------|
| FR1 | Chatbot beantwortet 3 Demo-Fragen korrekt | MUST |
| FR2 | Live-Demo während Präsentation funktioniert | MUST |
| FR3 | n8n Workflow als JSON exportierbar | MUST |
| FR4 | PDFs → Vektoren → Vector Store Pipeline | MUST |
| FR5 | Ähnlichkeitssuche retrievet relevante Docs | MUST |
| FR6 | LLM generiert auf Basis gefundener Docs | MUST |
| FR7 | Quellen werden im Chat angezeigt | SHOULD |
| FR8 | "Ich weiß nicht"-Fallback bei unbekannten Fragen | SHOULD |

### Non-Functional Requirements

| Req | Beschreibung | Priority |
|-----|-------------|----------|
| NFR1 | n8n: 3-4 Hauptnodes (Saile's Tip) | MUST |
| NFR2 | Latenz < 10s pro Query | SHOULD |
| NFR3 | Reproduzierbar dokumentiert | MUST |
| NFR4 | Hosting: lokal (n8n self-hosted) | MUST |
| NFR5 | **Bonus: Online deploybar** (für 1.0!) | NICE TO HAVE |

### Deliverables

| Deliverable | Format | Submission | Due |
|-------------|--------|-----------|-----|
| Project Documentation | PDF | Teams (1x pro Gruppe) | 31.05 |
| Presentation Slides | PDF/PPTX | Teams (1x pro Gruppe) | 31.05 |
| n8n Workflows | JSON Export | Teams (1x pro Gruppe) | 31.05 |
| Individual Grading Report | PDF/Word | Teams (jeder einzeln) | 31.05 |
| Live Presentation | — | In-Person | 01.06 |

---

## Tech Stack

### Primary
- **n8n (lokal/self-hosted)** — Workflow Orchestration
- **Supabase** — Vector Database (pgvector)
- **OpenRouter / OpenAI** — LLM + Embeddings

### Hosting Strategy
- **Default:** Lokal (n8n self-hosted via Docker)
- **Bonus für 1.0:** Online deployment (z.B. Railway, Render, oder n8n cloud trial)

### Why these choices
- **n8n** — visuelle Workflows, einfacher Export als JSON
- **Supabase** — pgvector kostenlos, einfach zu setupen
- **OpenRouter** — flexible Model-Wahl, günstig

---

## Architecture

```
┌─────────────────────────────────────────────────┐
│  PHASE 1: Document Ingestion                    │
│                                                 │
│  PDFs → n8n Trigger → Supabase Vector Store    │
│  (mit Sub-Nodes: Embedding + Text Splitter)     │
└─────────────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────────────┐
│  PHASE 2: Query/Chat                            │
│                                                 │
│  User Question                                  │
│      ↓                                          │
│  Chat Trigger                                   │
│      ↓                                          │
│  AI Agent (OpenRouter LLM + Vector Tool)        │
│      ↓                                          │
│  Retrieved Chunks + LLM Response                │
└─────────────────────────────────────────────────┘
```

### Node Details

**Workflow 1 — Ingestion (3 Nodes):**
1. Manual/File Trigger
2. Read PDF Files
3. Supabase Vector Store (Insert) ← Sub-Nodes: Embedding + Splitter

**Workflow 2 — Query (3 Nodes):**
1. Chat Trigger (Webhook)
2. AI Agent ← Sub-Nodes: LLM + Vector Tool + Memory
3. Response (im Chat Trigger oder separat)

---

## Documentation Structure (10 Pages)

| # | Section | Pages | Inhalt |
|---|---------|-------|--------|
| 1 | Cover + Inhaltsverzeichnis | 1 | Titel, Team, Datum |
| 2 | Company Situation | 1 | BergTech HR Case, Problem, Zielgruppe |
| 3 | Architecture Overview | 1 | Diagramm, Stack-Begründung |
| 4 | Workflow Details | 2 | Ingestion + Query Workflow Node-by-Node |
| 5 | Example Questions + Demo | 1 | 3 Fragen mit Chatbot-Antworten (Screenshots) |
| 6 | Risk Assessment | 1.5 | **2 Ebenen:** (1) Praxis-Risiken bei Nutzung (Halluzination, DSGVO, Outdated Info) + Mitigationen; (2) EU AI Act Compliance-Risiken (Art. 50, Art. 4 Verstöße) + Maßnahmen |
| 7 | EU AI Act Analysis | 1.5 | **Rollen explizit** (Provider = wir, Deployer = BergTech, Affected Persons = Mitarbeiter, GPAI = OpenAI); Risikoklasse Limited-Risk; Pflichten + Umsetzung |
| 8 | Implementation Reflection | 1 | **Struktur:** Was gut geklappt hat / Was schlecht lief / Konkrete Probleme + Lösungsweg / Learnings |
| **Total** | | **10** | |

**Appendix (unbegrenzt):** n8n Screenshots, JSON Export, Logs, Extended Configs

---

## Presentation Structure (15 Min)

| Min | Content |
|-----|---------|
| 0-2 | Problem + Use Case (BergTech HR) |
| 2-3 | RAG-Konzept + Why RAG (1 Min reicht) |
| 3-6 | Architektur + n8n Workflows (Screens) |
| 6-10 | **Live Chatbot Demo** (3 Fragen) |
| 10-13 | Risks, Safeguards, EU AI Act (inkl. Rollen) |
| 13-15 | Reflection: Was gut/schlecht lief, Probleme + Lösungen, Learnings |

**Q&A:** 10 Min (vorbereitete Antworten zu wahrscheinlichsten Fragen)

**Backup Slides (ausgeblendet, nach Slide 1):**
- Node-by-Node Erklärung Ingestion Workflow (Detail)
- Node-by-Node Erklärung Query Workflow (Detail)
- EU AI Act Artikel-Texte (Art. 50, Art. 4) im Wortlaut
- Embedding-Konzept visuell erklärt
- Supabase pgvector Setup-Details
- Edge Cases: Was passiert bei unbekannter Frage (Fallback)
- Kostenübersicht OpenRouter (Token-Kosten)

---

## EU AI Act Analysis (für Doku)

### Rollenklassifikation
- **Provider:** Du (entwickelst Chatbot)
- **Deployer:** BergTech (setzt ihn ein)
- **Affected Persons:** Mitarbeiter
- **GPAI Provider:** OpenAI/Anthropic (wir nutzen API)

### Risikoklasse
**Limited-Risk** (Chatbots mit menschlicher Interaktion)

### Pflichten
- **Art. 50 Transparenz:** User-Hinweis "Du chattest mit KI"
- **Art. 4 AI Literacy:** Mitarbeiter-Schulung über Funktionsweise + Grenzen
- **Quellenangabe:** Antworten zeigen verwendete Dokumente

### Risks + Safeguards Tabelle

| Risk | Mitigation |
|------|------------|
| Halluzinationen | Quellen-Display, "Ich weiß nicht"-Fallback |
| Bias | Test-Suite mit diversen Fragen |
| DSGVO/Datenschutz | Lokale Verarbeitung, keine PII in Vectors |
| Outdated Info | Regelmäßige Re-Indexierung |
| Prompt Injection | Input Sanitization |

---

## Aufgabenverteilung

| Person | Rolle | Verantwortung |
|--------|-------|---------------|
| **Anastasiia Sereda** | EU AI Act Lead (vorerst) | EU AI Act Analyse: Rollen-Klassifikation (Provider/Deployer/Affected Persons/GPAI), Risikoklasse Limited-Risk, Pflichten Art. 50 + Art. 4, Compliance-Risiken + Mitigationen |
| **Juliana Paar** | Supabase Lead (Vorschlag) | Supabase Setup (pgvector), Schema, Embedding Storage, Retrieval-Konfiguration, Anbindung an n8n |
| **Rustam Kohen** | n8n Lead | n8n Workflows (Ingestion + Query), OpenRouter Integration, Live-Demo, JSON Export, optional Online-Deployment |

### HR-Dokumente — Best-of-Approach

Alle drei Teammitglieder erstellen **eigenständig je 5 HR-Dokumente** nach den RAG-Authoring-Guidelines. Im Team-Vergleich wird pro Dokument-Typ das beste Ergebnis ausgewählt.

**Vorteil:** Bessere Endqualität, mehr Variationen für Vergleich, jeder lernt RAG-Optimierung praktisch.

**Workflow:**
1. Jeder erstellt die 5 Dokumente (Onboarding, Vacation, Training, FAQ, Offboarding) in eigenem Ordner
   - `company-docs/rustam/`
   - `company-docs/juliana/`
   - `company-docs/anastasiia/`
2. Team-Review: pro Dokument-Typ das beste auswählen
3. Auswahl wird in `company-docs/final/` gemerged → finale 5 PDFs für Ingestion

**Offen für spätere Verteilung:** 10-Seiten-Doku (Sections schreiben), Präsentation + Backup-Slides, finale MD→PDF-Konvertierung, Individual Grading Reports (jeder selbst).

### Cross-Functional

- **Live-Demo Rehearsal:** alle 3 zusammen (mind. 3× vor 01.06)
- **Q&A-Vorbereitung:** alle 3 (jeder kennt Top 10 Fragen)
- **Individual Grading Report:** jeder schreibt seinen eigenen
- **Review-Loops:** Doku → Cross-Read durch alle, Slides → Cross-Read durch alle

### Iteration Tracking

Rustam dokumentiert jede n8n-Build-Iteration in `BUILD_LOG.md`:
- Was gebaut, welche Konfiguration, welche Probleme + Lösung
- Screenshots in `/workflows/screens/`
- Take-Aways für Doku (Juliana) und Slides (Anastasiia)

→ Juliana und Anastasiia ziehen aus dem BUILD_LOG die nötigen Inhalte für ihre Deliverables.

---

## Roadmap

### ✅ Phase 1: Planning (heute, 09.05)
- [x] PRD erstellt
- [x] Ordnerstruktur
- [x] Case definiert (Case 1 — BergTech HR)
- [x] Testfragen identifiziert
- [ ] PDF-Konzepte (5 Stück)

### Phase 2: Document Creation (10.-12.05)
- [ ] Onboarding Guide schreiben
- [ ] Vacation Policy
- [ ] Training Policy
- [ ] HR FAQ
- [ ] Offboarding Checklist
- [ ] PDFs in `/company-docs/`

### Phase 3: Setup (13.-15.05)
- [ ] Supabase Project (pgvector)
- [ ] OpenRouter API Key
- [ ] n8n lokal via Docker
- [ ] Erste Workflow-Skeletons

### Phase 4: Implementation (16.-22.05)
- [ ] Workflow 1: Ingestion
- [ ] PDFs erfolgreich indexiert
- [ ] Workflow 2: Query/Chat
- [ ] E2E Test mit 3 Fragen
- [ ] JSON Exports
- [ ] **Bonus:** Online Deployment

### Phase 5: Documentation (23.-27.05)
- [ ] 10-Seiten Doku
- [ ] EU AI Act Section
- [ ] Screenshots + Diagramme
- [ ] Reflection Section
- [ ] PDF Generation

### Phase 6: Presentation Prep (28.-31.05)
- [ ] Slides (15 Min)
- [ ] Speaker Notes
- [ ] Live Demo Rehearsal (3-5×!)
- [ ] Q&A Vorbereitung
- [ ] Contribution Reports
- [ ] **Submission 31.05**

### Phase 7: Live Day (01.06)
- [ ] Setup Check (1h vorher)
- [ ] Live Demo durchführen
- [ ] Q&A meistern
- [ ] 🎓 1.0!

---

## Success Criteria für 1.0

✅ **Hard Requirements:**
- [ ] Chatbot beantwortet alle 3 Testfragen korrekt
- [ ] Live Demo läuft fehlerfrei
- [ ] n8n Workflows als JSON exportiert
- [ ] 10-Seiten Doku ohne Lücken
- [ ] EU AI Act Analyse vollständig
- [ ] Präsentation 15 Min ± 1 Min
- [ ] Q&A souverän

✅ **For 1.0 (Bonus):**
- [ ] **Online Deployment** (extra credit)
- [ ] Source Attribution im Chatbot UI
- [ ] Tiefgreifende EU AI Act Analyse (über Mindestmaß)
- [ ] Polished Slides (visuell stark)
- [ ] Alle Q&A Fragen bombenfest
- [ ] Demonstration von Edge-Cases (z.B. unbekannte Frage → Fallback)
- [ ] Reflection mit ehrlichen Learnings

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|-----------|
| Live Demo bricht ab | HIGH | 5× rehearsen, Fallback Screenshots/Video |
| n8n local instabil | MEDIUM | Docker Setup robust, Backup Workflow |
| LLM halluziniert | MEDIUM | System Prompt streng, Few-Shots |
| PDF Extract fehlerhaft | MEDIUM | Test mit verschiedenen PDFs |
| Timing zu lang | MEDIUM | Dry-Run mit Stoppuhr |
| EU AI Act ungültig | HIGH | Mit Saile gegenchecken |
| Q&A schwierige Fragen | MEDIUM | Top 10 Fragen vorbereiten |

---

## Notes

- **Saile's Tips:**
  - n8n klein halten (3-4 Nodes)
  - Live Demo ist kritisch
  - EU AI Act ist Pflicht
  - Präsentation > Doku im Grading
  - Lokal reicht, online ist Bonus
- **Goal:** **1.0** — Online Deployment als Differenziator
- **Submission:** Doku + Präsentation = 1x pro Gruppe; Individual Grading Report = jeder einzeln
- **Confidential:** Contribution Report nicht mit Team besprechen

---

**Last Updated:** 09.05.2026  
**Next Review:** Nach Phase 2 (PDFs fertig)  
**Status:** 🟡 Phase 1 → Phase 2 transition
