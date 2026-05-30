# Team-Update 17.05.2026 — Briefing für Juliana + Anastasiia

**Anlass:** Team-Sync vor Q&A Saile 18.05.
**Speaker:** Rustam
**Dauer:** ~5 Minuten

---

## TL;DR

v4.7 ist auf GitHub, Workflow funktioniert (Chat-Sidebar geht), 5 HR-PDFs sind ready. Saile-konform. Aber: Live-Demo blockiert weil Supabase + EU AI Act fehlen. Wir müssen heute klären wer was bis wann liefert.

---

## Was wurde gemacht seit letztem Stand

### 1. Workflow v4.7 — Chat Trigger Fix
- v4.6 hatte einen falschen Trigger-Node (Standard-Webhook statt LangChain-Chat-Trigger)
- Folge: n8n-Chat-Sidebar links liess sich nicht aktivieren, wir hätten keine Live-Demo zeigen können
- Fix: Trigger getauscht, Respond-Node entfernt (LangChain-Agent liefert Output automatisch zurück), Sticky-Note-Typo "QUERRY" → "QUERY"

### 2. Repo aufgeräumt
- `workflows/_archiv/` angelegt — alte Versionen v4.3, v4.4, v4.6-BROKEN dort abgelegt, im Hauptordner nur noch v4.7
- GitHub-Repo-Description: stand monatelang "NovaWork" (alter falscher Firmenname) → jetzt "BergTech HR"
- README-Typo gefixt (doppeltes "Maschinenbau GmbH")

### 3. HR-Docs als PDF konvertiert
- Saile-Aufgabe sagt wörtlich "uploaded as PDF" — wir hatten nur Markdown
- Pandoc + WeasyPrint → 5 PDFs in `company-docs/rustam/pdf/`
- Source-MDs bleiben, der Workflow liest weiterhin die .md-Dateien für Embedding

### 4. Q&A-Brief 18.05. erstellt
- 13 wahrscheinliche Saile-Fragen + meine Antworten
- 5 eigene Fragen die ich Saile stellen will (Doku-Struktur, EU-AI-Act-Tiefe, Demo-Modus, Word-Template, PDF-Source)
- Risiko-Tabelle Case 1
- Cheat-Sheet mit allen Kennzahlen
- Datei: `docs/qa-brief-18-05.md`

### 5. Implementation-Reflection erweitert
- Section 8 (Chat Trigger Fix) und Learning #9 (LangChain vs Standard Webhook) hinzugefügt
- Sektion-Reihenfolge chronologisch sortiert
- Datei: `docs/implementation-reflection.md`

---

## Was gut lief

- **Chat-Trigger-Fix** war chirurgisch — eine Node-Typ-Änderung, alles andere blieb intakt, keine Regression
- **PDF-Konvertierung** lief sauber, alle 5 Dateien einheitlich
- **Repo-Hygiene** vorbildlich: Archiv-Ordner statt Löschen, alle Iterationen nachvollziehbar
- **Q&A-Brief** komplett, ich bin gut vorbereitet für morgen früh

## Was schlecht lief

- **v4.6 wurde fast 24h mit falschem Trigger ausgeliefert** — keiner von uns hat es vorher getestet weil Manual-Trigger funktioniert hat, aber Chat-Sidebar nicht. Lehre: Demo-Pfad früher live durchspielen.
- **Repo-Description "NovaWork" stand monatelang ungefixt** — Repo-Metadaten kontrolliert keiner. Saile sieht GitHub als erstes wenn er den Link öffnet, falscher Firmenname = sofort schlechter Eindruck.
- **Sticky-Note-Typo "QUERRY"** war seit v4.2 drin, niemandem aufgefallen. Live-Demo wäre peinlich gewesen.

---

## Wo wir stehen vs Saile-Aufgabe

| Pflicht laut Saile | Status |
|--------------------|--------|
| n8n RAG Chatbot | ✅ v4.7 |
| JSON Export | ✅ workflows/rag-workflows-v4.7.json |
| 5 Firmen-Docs als PDF | ✅ company-docs/rustam/pdf/ |
| 3 Demo-Fragen | ✅ 1:1 zu Saile-Vorgabe |
| Funktionierend in Präsi | ⚠️ Supabase fehlt → kein Live-Test möglich |
| 10-Seiten-Doku | ❌ 0% (außer implementation-reflection) |
| EU AI Act Analyse | ❌ 0% |
| Risk-Section | ❌ 0% |
| Architektur-Diagramm | ❌ fehlt |
| Präsi 15 Min | ❌ 0% |
| Individual Grading Reports | ✅ alle 3 vorhanden |

---

## Was wir heute besprechen sollten

### Offene Arbeitspakete (aus der ursprünglichen Verteilung)

**Supabase + pgvector** (urspr. Juliana)
- Was wir bräuchten: Projekt anlegen + pgvector-Extension, Tabelle "documents" (id, content, metadata, embedding vector 1536), Credentials in n8n
- Ideal-Zeitpunkt fertig: ~22.05. damit E2E-Test 22.–25.05. möglich ist
- Falls knapp wird: Hilfe willkommen, oder wir entscheiden gemeinsam über Plan B (Pre-recorded Demo)
- Frage an Juliana: wie sieht's bei dir aus, was brauchst du?

**EU AI Act Analyse** (urspr. Anastasiia)
- Was reinkommen sollte: Rollen-Mapping (Provider = wir, Deployer = BergTech, GPAI = Anthropic + OpenAI, Affected Persons = Mitarbeiter), Risikoklasse Limited-Risk, Art. 50 Transparenzpflicht, Art. 4 AI-Literacy, konkrete Maßnahmen (Transparenzhinweis, Fallback, Quellenangabe, keine PII)
- Quellen: EU AI Act Volltext + Saile-Vorlesungsfolien
- Sailes Lieblingsthema, deshalb relativ viel Gewicht
- Ideal-Zeitpunkt fertig: ~28.05. für Doku-Integration vor 31.05.-Submission
- Frage an Anastasiia: passt das, oder brauchst du Unterstützung bei Quellen?

**Was ich (Rustam) gerne übernehme, falls's ok ist**
- Architektur-Diagramm als Mermaid in `docs/architecture.md`
- Risk-Section als `docs/risks.md` (Case-1-spezifisch)
- Demo-Skript für Live-Präsi
- Falls Zeit: Agentic-Loop-Future-Work-Slide (siehe unten)

### Gemeinsam offen
- 10-Seiten-Doku zusammenführen (nach 28.05.)
- 15-Min-Präsi Foliensatz — Verteilung können wir heute klären
- Live-Demo-Rehearsal (22.–30.05.)

---

## Diskussionspunkt: Agentic Loop als Bonus?

Ich habe heute ein Konzept gesehen: "Agentic Loop" — Plan, Execute, Reflect. Wir haben aktuell einen linearen RAG (User-Frage rein, eine Suche, eine Antwort). Ein Agentic Loop würde die Antwort gegenchecken und bei Lücken nachfragen.

**Vorschlag:** Wir bauen das NICHT als zweiten Workflow, aber zeigen es als "Future Work" auf einer Slide. Begründung in Q&A-Brief Frage #13.

**Argument:**
- Saile sagt "einfach halten"
- HR-FAQ ist single-hop, Agentic bringt 0 Mehrwert
- Aber: Saile sieht dass wir das Konzept kennen
- 0 zusätzlicher Workflow-Aufwand

Einverstanden?

---

## Deadlines (Erinnerung)

- **18.05. 8:00–9:30** — Q&A Saile (Rustam allein, freiwillig)
- **22.05.** — geplant E2E-Test mit allen 3 Demo-Fragen
- **28.05.** — EU AI Act fertig (Anastasiia), interne Doku-Integration
- **31.05.** — Submission via Teams: Doku + Präsi + Individual Reports
- **01.06.** — Präsentation 15 Min + 10 Min Q&A

---

## Was ich gerne im Treffen klären würde

1. Wie sieht's bei Supabase aus — kommen wir bis ~Mittwoch (20.05.) voran, oder hilft's wenn wir zusammen ran?
2. EU AI Act — ist ~25.05. machbar, oder lieber später? Quellen-Hilfe von meiner Seite?
3. Präsi-Sprechzeit: Saile gibt 15 Min vor (Slide-Anzahl nicht fix). Aufteilung also nach Minuten — z.B. ~5 Min pro Person, oder anders nach Themen-Beitrag. Was passt euch?
4. Agentic-Loop als Future-Work-Slide — ja oder nein?
5. Metadaten in finalen Submission-Files (Anastasiias guter Hinweis vom 17.05.) — kurzer Check vor 31.05. dass keine Datei "Creator: ChatGPT/python-docx/pandoc" o.ä. anzeigt. Pfad in Word: Datei → Informationen → Dokument prüfen → personenbezogene Daten entfernen. Habe heute schon die PDFs (rustam/pdf/) und Workflow-JSONs gesäubert (Commit 00f0a68). Bei den Word-Docs muss jede:r selbst durch.
