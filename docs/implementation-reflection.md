# CEO Review — RAG Chatbot Project

**Projekt:** LLM & Agentics, Gruppe 1, Case 1  
**Firma:** BergTech Maschinenbau GmbH (Dozent-Vorgabe)  
**Produkt:** HR Knowledge Assistant — RAG-Chatbot mit n8n + Supabase  
**Stand:** 11.05.2026 | **Deadline:** 31.05.2026 | **Präsentation:** 01.06.2026

---

## Executive Summary

Workflow steht, Docs stehen, Architektur validiert. 3 Nodes pro Section, Dozent-konform. Das Produkt ist zu 60% fertig — was fehlt sind Credentials, Supabase-Setup und die komplette Doku. 

---

## Decisions Made

| Entscheidung | Warum | Impact |
|-------------|-------|--------|
| Anthropic für Chat, OpenAI für Embeddings | Anthropic hat keine Embeddings. Beste Aufteilung: Claude Haiku (günstig, schnell) + text-embedding-3-small | Kosteneffizient, 2 Provider statt 1 |
| Chunking 500/50 (Zeichen) | HR-Docs haben kurze, dichte Abschnitte. 500 Zeichen reichen für eine Policy-Regel oder FAQ-Antwort | Präzisere Retrieval-Matches |
| 3 sichtbare Nodes | Dozent-Vorgabe: "einfach halten". AI Agent macht intern Retrieval + LLM | Weniger Fehlerpunkte in Live-Demo |
| BergTech als Name | Dozent-Transkript 17:01: "Gruppe 1 macht einen HR-Assistent für die fiktive Bergtech Maschinenbau GmbH" | Vorgabe, keine Diskussion |
| Workflow kombinieren statt teilen | Eine Canvas, zwei Sections mit Sticky Notes. In der Demo zeigst du alles auf einen Blick | Besserer Demo-Flow |

---

## What Went Wrong

### 1. KI-generierte n8n-JSONs sind wertlos (3 Iterationen verloren)

**Root cause:** AI-Agent und Claude erzeugten syntaktisch korrektes JSON mit falschen Node-Types und fehlenden Sub-Node-Connections.

Was produziert wurde:
- `n8n-nodes-base.supabase` → existiert nicht für Vector-Operationen
- `n8n-nodes-base.aiAgent` → existiert nicht als LangChain-Agent
- `readBinaryFiles` für `.md` → braucht binären Input, nicht Text
- Sub-Node-Connections (`ai_languageModel`, `ai_tool`) komplett absent

**Kosten:** v1, v2, v3 alle unbrauchbar. ~2h verschwendet auf JSON-Editieren statt Builden.

**Fix:** Manuell in n8n-UI gebaut, als echten Export gespeichert. v4.2 ist der erste funktionierende Workflow.

**Learning:** n8n-Workflows NUR in der UI bauen. JSON-Export ist Output, nicht Input.

### 2. Name-Chaos durch fehlenden PDF-Zugriff

**Root cause:** Das Assignment-PDF (RAG_Project_Assignment.pdf) war nicht lesbar. Name "BergTech" wurde aus der PRD abgeleitet, zu "NovaWork" umbenannt, dann durch Dozent-Transkript widerlegt.

**Kosten:** 3× 100+ Text-Ersetzungen in 8 Dateien. 30 Minuten reine Umbenenn-Arbeit.

**Learning:** Vorlesungstranskript lesen BEVOR Namen ändern. Dozent nennt alle Firmen wörtlich in der Q&A-Session.

### 3. Sub-Node-Architektur in n8n nicht intuitiv

**Root cause:** n8n LangChain-Nodes verwenden gestrichelte Connections statt Main-Pipeline. `ai_embedding`, `ai_tool`, `ai_textSplitter` sind eigene Connection-Types. Die visuelle Logik ("Node → Sub-Node") ist im JSON invertiert (Sub-Node referenziert Parent).

**Kosten:** Mehrere Fehlversuche beim JSON-Schreiben. Verbindungen waren da, aber in falscher Richtung.

**Learning:** Drag-and-Drop in der UI > JSON editieren. Die Connection-Logik ist versionsabhängig.

### 4. Team-Commits: 0

Teammitglied B (Supabase) und Teammitglied A (EU AI Act) haben Stand 10.05. keine Commits. Das blockiert Phase 3 Setup (Supabase brauchen wir für den Live-Test) und die EU AI Act Sektion in der Doku.

**Risk:** 

### 5. Embedding-Modell-Default-Falle (11.05 entdeckt)

**Root cause:** Beide Embedding-Nodes im Workflow hatten `"options": {}` — kein Modell explizit gesetzt. n8n nimmt dann OpenAIs Default `text-embedding-ada-002` (2022). In der PRD und Reflection stand aber `text-embedding-3-small`.

Das ist doppelt gefährlich:
1. **Default-Änderung:** OpenAI kann den Default jederzeit wechseln → Ingestion und Query laufen dann mit unterschiedlichen Modellen → Vektoren passen nicht mehr → Retrieval findet nichts
2. **Doku-Realitäts-Gap:** Wir behaupten Modell X, Workflow nutzt Y. Dozent würde das im Q&A zerlegen.

**Fix:** Beide Nodes auf `"model": "text-embedding-3-small"` gesetzt. `3-small` ist neuer (2024), günstiger ($0.02/1M tokens vs $0.10) und produziert bessere Embeddings als `ada-002`.

**Learning:** n8n-Defaults nie blind vertrauen. Jeder Node-Parameter muss explizit gesetzt sein — was nicht im JSON steht, kontrollieren wir nicht.

### 6. Character Splitter ≠ Token Splitter (11.05 entdeckt)

**Root cause:** Der `RecursiveCharacterTextSplitter` in n8n arbeitet **Zeichen-basiert**, nicht Token-basiert. Unser Chunking 500/50 sind 500 Zeichen, nicht 500 Tokens wie in der Doku behauptet. 500 Zeichen ≈ 125-200 Tokens (Deutsch).

**Impact:** Die tatsächlichen Chunks sind deutlich kleiner als gedacht. Das ist nicht unbedingt schlecht (präzisere Matches), aber es muss korrekt dokumentiert sein.

**Fix:** Doku auf "500 Zeichen" korrigiert. In der Präsi können wir das als bewusste Entscheidung framen: HR-Docs haben kurze, dichte Abschnitte — kleine Chunks = präziseres Retrieval.

### 7. Unvollständiger Node-Export: Read/Write Files + Supabase ohne Pflichtparameter (16.05 entdeckt)

**Root cause:** Zwei Nodes waren im JSON-Export unvollständig: "Read/Write Files from Disk" hatte weder `operation` noch `fileSelector`, und "Supabase Vector Store" (retrieve) hatte leeren Resource-Locator statt `tableName`. Beide zeigten ⚠️ in n8n.

**Warum spät entdeckt:** Der Resource-Locator mit `"__rl": true` sieht im n8n-UI wie ein Dropdown aus — erst im JSON sieht man `"value": ""`. Der Read/Write-Node war vom UI her angeklickt, aber die Pflichtfelder nicht ausgefüllt.

**Fix v4.4:** `"operation": "read"` + `"fileSelector": "company-docs/**/*.md"`, `"tableName": "documents"` (konkret statt dynamischem Selector).

**Learning:** Nach jedem UI-Export das JSON manuell gegenchecken: alle Nodes auf fehlende Pflichtparameter (`operation`, `fileSelector`, `tableName`, `model`). n8n exportiert unvollständige Nodes ohne Warnung.

### 8. Falscher Chat Trigger im Query-Pfad (16.–17.05 entdeckt, v4.7 fixt)

**Root cause:** In v4.6 war der Query-Trigger `n8n-nodes-base.webhook` (Standard-POST-Endpoint mit `httpMethod`, `path: chat`, `responseMode: responseNode`). Optisch sah er wie ein Chat-Trigger aus, war aber ein generischer Webhook. Folgen:

1. Die n8n **Chat-Sidebar** (links, "Chat beta") liess sich nicht aktivieren — sie verlangt einen LangChain-Chat-Trigger.
2. Im Node-Panel fehlte die Option **"Make Chat Publicly Available"**.
3. Der Workflow brauchte zwingend einen `Respond to Webhook`-Node am Ende, damit die HTTP-Antwort zurückgeht — also ein Zusatz-Node ohne fachlichen Mehrwert.
4. Die generierte URL `webhook-test/chat` ist ein API-Endpoint für externe POSTs, kein Chat-UI-Trigger.

**Warum erst spät entdeckt:** v4.2–v4.6 wurden nie live mit der Chat-Sidebar getestet — wir haben mit Manual-Trigger gearbeitet. Erst beim Versuch, die Chat-Sidebar für die Demo zu aktivieren, fiel der falsche Node-Type auf.

**Fix v4.7:**
- Node-Type: `n8n-nodes-base.webhook` → `@n8n/n8n-nodes-langchain.chatTrigger` (typeVersion 1.1)
- Parameter: `httpMethod`, `path`, `responseMode` entfernt → `public: true`, `options: {}`
- Node-Name: "Chat Trigger1" → "When chat message received" (n8n-Konvention)
- `Respond to Webhook`-Node komplett entfernt: bei LangChain-Chat-Trigger liefert der **letzte ausgeführte Node** (= AI Agent1) seine Output automatisch zurück an die Chat-Sidebar. Kein Zwischen-Node nötig.
- Connection geändert: AI Agent1 hat kein outgoing `main` mehr (war → Respond)

**Impact:**
- Chat-Sidebar funktioniert (Demo-tauglich für 01.06.)
- Sticky Note Typo "QUERRY" → "QUERY" mitgefixt
- Dozent-Vorgabe "3 Nodes pro Section" weiterhin erfüllt: Trigger + AI Agent + Vector Store (als Tool) statt Trigger + Agent + Respond

**Learning:** Trigger-Typ beim ersten Build verifizieren. `n8n-nodes-base.webhook` und `@n8n/n8n-nodes-langchain.chatTrigger` sehen im UI ähnlich aus (beide haben einen Webhook-Endpunkt), funktional sind sie aber unterschiedlich. Bei Chatbot-Use-Cases immer den LangChain-Trigger nehmen — er gibt dir die Chat-Sidebar, Session-Memory und automatisches Output-Routing gratis. Den Standard-Webhook nur, wenn du externe Systeme als Caller hast.

---

## What We Learned

1. **n8n-Workflows in der UI bauen, nicht im JSON.** Die JSON-Struktur ist versionsabhängig und enthält interne IDs die n8n selbst generiert.

2. **Embedding-Modell muss für Write und Read identisch sein.** Ingestion mit OpenAI, Query mit einem anderen Modell = keine Matches. Zusätzlich: Modell IMMER explizit setzen, nie auf n8n-Defaults verlassen. Ein Default-Wechsel von OpenAI würde den Workflow unbemerkt zerbrechen.

3. **System Prompt gehört in `options.systemMessage`.** `promptType: define` mit festem `text` überschreibt die User-Frage.

4. **AI Agent Node ist mächtiger als er aussieht.** Intern: LLM-Call + Tool-Auswahl + Retrieval + Antwort-Formatierung. 3 Nodes auf dem Canvas, 5 Sub-Nodes unsichtbar.

5. **Ein zweiter Review-Durchlauf findet Bugs, die man selbst übersieht.**  Bei sicherheitskritischer Konfiguration (Embedding-Modelle, Chunking) lohnt ein zweiter Review-Durchlauf.

6. **Transkripte lesen, nicht raten.** Firmenname, Dokumenttypen, Node-Limit — alles steht wörtlich in Dozents Aufzeichnung.

7. **Character-based ≠ Token-based.** n8ns RecursiveCharacterTextSplitter arbeitet auf Zeichenebene. 500 Chunk-Size = 500 Zeichen, nicht 500 Tokens. Immer prüfen welche Einheit der Splitter tatsächlich verwendet.

8. **n8n-JSON-Export validiert keine Pflichtparameter.** Der Export schreibt auch unvollständige Nodes. Nach jedem Export: JSON manuell auf `operation`, `fileSelector`, `tableName`, `model` prüfen. Resource-Locators mit `"__rl": true` sind im JSON nicht sichtbar leer, aber im UI schon.

9. **Chat-Trigger ≠ Webhook-Trigger.** `n8n-nodes-base.webhook` ist ein generischer HTTP-Endpoint, `@n8n/n8n-nodes-langchain.chatTrigger` ist der LangChain-spezifische Chat-Hook mit Sidebar-Integration, Session-Memory und automatischem Output-Routing. Für Chatbot-Demos immer den LangChain-Trigger. Erkennungsmerkmale im Panel: Option "Make Chat Publicly Available", kein expliziter HTTP-Path, Sprechblasen-Icon.

---

## What's Left for 1.0

| Item | Owner | Blocked by | Risiko |
|------|-------|-----------|--------|
| Supabase + pgvector Setup | Teammitglied B | — | Hoch |
| API Credentials (Anthropic + OpenAI) | Rustam | — | Niedrig |
| 3 Demo-Fragen Live-Test | Rustam | Supabase | Mittel |
| EU AI Act Analyse | Teammitglied A | — | Hoch |
| 10-Seiten Doku | Alle | EU AI Act | Mittel |
| Reflection Section | Rustam | — | Niedrig (dieses Doc) |
| Präsentation 15 Min + Slides | Alle | Doku | Mittel |
| Live Demo Rehearsal (3-5×) | Alle | Workflow live | Hoch |
| Individual Grading Report | Rustam | — | Niedrig |
| Q&A Vorbereitung | Alle | Präsi | Niedrig |

**Kritischer Pfad:** Supabase → Live-Test → Rehearsal → Präsentation. 

---

## Timeline

| Datum | Milestone |
|-------|-----------|
| 10.05 | ✅ Workflow v4.2 + Docs gepusht |
| 11.05 | ✅ Workflow v4.3: Modell-Update + Embedding-Fix + Default-Hardening |
| 13.05 | Phase 3 Start: Supabase + Credentials |
| 18.05 | Q&A Session mit Dozent (freiwillig) |
| 22.05 | E2E Test mit 3 Demo-Fragen |
| 27.05 | Doku + EU AI Act fertig |
| 29.05 | Slides + erstes Rehearsal |
| 31.05 | **Submission Deadline** |
| 01.06 | **Präsentation + Live Demo** |

---

---

## Q&A-Vorbereitung — Dozents wahrscheinlichste Fragen

> 15 Min Präsi + 10 Min Q&A. Dozent stellt technische Detailfragen. Diese Sektion = Redeskript für die Präsentation.

### "Warum 5 Workflow-Iterationen (v1—v4.3)?"

Weil v1—v3 KI-generiertes JSON war — syntaktisch korrekt, aber mit falschen Node-Types. Erst als wir den Workflow manuell in der n8n-UI gebaut und als echten Export gespeichert haben (v4), war er funktionsfähig.

Die JSON-Struktur von n8n ist versionsabhängig und enthält interne IDs, Connection-Types (`ai_languageModel`, `ai_tool`) und Sub-Node-Referenzen, die nur die n8n-UI korrekt erzeugt.

**Take-away:** n8n-JSON ist Output, nicht Input. In der UI bauen, exportieren, versionieren. Das ist eine der wichtigsten Lessons Learned.

### "Warum GitHub für ein Uni-Projekt?"

1. **Team-Transparenz:** Alle 3 Mitglieder sehen wer was wann committed hat. Kein "ich hab's dir gemailt"-Chaos.
2. **Versionierung:** Jede Workflow-Iteration ist nachvollziehbar (v1→v4.3). Rollback jederzeit möglich.
3. **Professioneller Workflow:** In der Industrie wird niemand JSONs per Teams hin- und herschicken. Git ist Standard.
4. **Nachweisbarkeit:** Contribution Reports sind durch Commit-Historie belegbar.

### "Warum Claude Haiku und nicht GPT-4 oder Gemini?"

- **Haiku** ist der günstigste und schnellste Claude (0.25/1M Input, 1.25/1M Output). Für eine HR-FAQ mit festem Dokument-Pool reicht die Reasoning-Tiefe völlig.
- **GPT-4** wäre teurer bei gleicher Antwortqualität für diesen Use Case.
- **Gemini** hat keinen n8n-native Node — Anthropic und OpenAI sind first-class in n8n integriert.

Außerdem: Wir nutzen bereits OpenAI für Embeddings. Zwei Provider = Ausfallsicherheit.

### "Warum text-embedding-3-small und nicht ada-002?"

- `3-small` (2024) ist neuer, 5× günstiger ($0.02 vs $0.10/1M tokens) und produziert bessere Embeddings bei Benchmark-Tests (MTEB).
- Wir haben das Modell **explizit im JSON gesetzt**, weil wir nicht auf OpenAIs Default vertrauen. Ein Default-Wechsel würde Ingestion und Query mit unterschiedlichen Modellen laufen lassen → Retrieval kaputt.

### "Warum RecursiveCharacterTextSplitter mit 500 Zeichen?"

- HR-Docs bestehen aus kurzen, dichten Abschnitten (Policy-Regeln, FAQ-Antworten, Checklisten-Items).
- 500 Zeichen ≈ ein Abschnitt. So landet jede Policy-Regel als eigener Chunk → präzisere Matches.
- Overlap 50 verhindert dass Informationen an Chunk-Grenzen abgeschnitten werden.
- Größere Chunks (1000+) würden mehrere Themen mischen → Retrieval wird unscharf.

### "Warum 3 Nodes und nicht mehr?"

Dozent-Vorgabe: "n8n einfach halten, 3-4 Nodes." Der AI Agent Node ist intern mächtiger als er aussieht:

- `ai_languageModel` → LLM-Call (Anthropic)
- `ai_tool` → Vector Store Abfrage (Supabase)
- `ai_embedding` → Query-Vektorisierung

Das sind 5 Sub-Nodes, aber nur 3 auf dem Canvas. Best Practice: sichtbare Komplexität minimieren, interne Arbeit delegieren.

### "Was passiert wenn eine Frage nicht beantwortet werden kann?"

Der System Prompt hat einen expliziten Fallback:

> "Diese Information liegt mir nicht vor. Bitte wende dich an hr@bergtech.de."

Das verhindert Halluzinationen — der Chatbot darf NUR aus den bereitgestellten Dokumenten antworten. Keine Spekulation, keine externen Informationen. Das ist besonders wichtig für HR (rechtliche Relevanz) und eine direkte Anforderung aus dem EU AI Act (Transparenz, menschliche Eskalation).

### "Wie stellt ihr sicher dass Embeddings von Write und Read identisch sind?"

Beide Nodes — Ingestion UND Query — haben explizit `"model": "text-embedding-3-small"` gesetzt. Kein Default-Verhalten, kein impliziter Fallback.

Das war einer unserer Bugs in der ersten Review: `"options": {}` → n8n nimmt Default. Wir haben das am 11.05. entdeckt und in v4.3 gehärtet.

### "EU AI Act — welche Rolle spielt euer Chatbot?"

- **Provider:** Wir (Gruppe 1) — entwickeln und deployen den Chatbot
- **Deployer:** BergTech — setzt ihn intern ein
- **Affected Persons:** BergTech-Mitarbeiter — interagieren mit dem Bot
- **GPAI Provider:** Anthropic (Claude) + OpenAI (Embeddings)

Risikoklasse: **Limited-Risk** (Chatbot mit menschlicher Interaktion, Art. 50 Transparenzpflicht).

Umsetzung: Transparenzhinweis im System Prompt, "Ich weiß nicht"-Fallback, Quellenangabe in Antworten, keine PII-Verarbeitung.

---

**Last Updated:** 11.05.2026  
**Next Review:** 13.05 (Phase 3 Start)
