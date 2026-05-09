# CEO Review — RAG Chatbot Project

**Projekt:** LLM & Agentics, Gruppe 1, Case 1  
**Firma:** BergTech Maschinenbau GmbH (Dozent-Vorgabe)  
**Produkt:** HR Knowledge Assistant — RAG-Chatbot mit n8n + Supabase  
**Stand:** 10.05.2026 | **Deadline:** 31.05.2026 | **Präsentation:** 01.06.2026

---

## Executive Summary

Workflow steht, Docs stehen, Architektur validiert. 3 Nodes pro Section, Dozent-konform. Das Produkt ist zu 60% fertig — was fehlt sind Credentials, Supabase-Setup und die komplette Doku. 

---

## Decisions Made

| Entscheidung | Warum | Impact |
|-------------|-------|--------|
| Anthropic für Chat, OpenAI für Embeddings | Anthropic hat keine Embeddings. Beste Aufteilung: Claude Haiku (günstig, schnell) + text-embedding-3-small | Kosteneffizient, 2 Provider statt 1 |
| Chunking 500/50 | HR-Docs haben kurze, dichte Abschnitte. 500 Tokens reicht für eine Policy-Regel oder FAQ-Antwort | Präzisere Retrieval-Matches |
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

---

## What We Learned

1. **n8n-Workflows in der UI bauen, nicht im JSON.** Die JSON-Struktur ist versionsabhängig und enthält interne IDs die n8n selbst generiert.

2. **Embedding-Modell muss für Write und Read identisch sein.** Ingestion mit OpenAI, Query mit einem anderen Modell = keine Matches.

3. **System Prompt gehört in `options.systemMessage`.** `promptType: define` mit festem `text` überschreibt die User-Frage.

4. **AI Agent Node ist mächtiger als er aussieht.** Intern: LLM-Call + Tool-Auswahl + Retrieval + Antwort-Formatierung. 3 Nodes auf dem Canvas, 5 Sub-Nodes unsichtbar.

5. **Ein zweiter Review-Durchlauf findet Bugs, die man selbst übersieht.** 

6. **Transkripte lesen, nicht raten.** Firmenname, Dokumenttypen, Node-Limit — alles steht wörtlich in Dozents Aufzeichnung.

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
| 13.05 | Phase 3 Start: Supabase + Credentials |
| 18.05 | Q&A Session mit Dozent (freiwillig) |
| 22.05 | E2E Test mit 3 Demo-Fragen |
| 27.05 | Doku + EU AI Act fertig |
| 29.05 | Slides + erstes Rehearsal |
| 31.05 | **Submission Deadline** |
| 01.06 | **Präsentation + Live Demo** |

---

**Last Updated:** 10.05.2026  
**Next Review:** 13.05 (Phase 3 Start)
