# CEO Review — RAG Chatbot Project

**Projekt:** LLM & Agentics, Gruppe 1, Case 1  
**Firma:** BergTech Maschinenbau GmbH (Saile-Vorgabe)  
**Produkt:** HR Knowledge Assistant — RAG-Chatbot mit n8n + Supabase  
**Stand:** 30.05.2026 | **Deadline:** 31.05.2026 | **Präsentation:** 01.06.2026

---

## Executive Summary

Workflow v4.7.2 steht, E2E-Test bestanden (Video 30.05.), Docs komplett. Das Produkt ist zu ~90% fertig — was fehlt sind Slides und Gruppendoku-Finalisierung. Team-Lieferung: Anastasiia (EU AI Act + Gruppendoku), Juliana (Supabase-Infra).

---

## Decisions Made

| Entscheidung | Warum | Impact |
|-------------|-------|--------|
| Anthropic für Chat, OpenAI für Embeddings | Anthropic hat keine Embeddings. Beste Aufteilung: Claude Haiku (günstig, schnell) + text-embedding-3-small | Kosteneffizient, 2 Provider statt 1 |
| Chunking 500/50 (Zeichen) | HR-Docs haben kurze, dichte Abschnitte. 500 Zeichen reichen für eine Policy-Regel oder FAQ-Antwort | Präzisere Retrieval-Matches |
| 3 sichtbare Nodes | Saile-Vorgabe: "einfach halten". AI Agent macht intern Retrieval + LLM | Weniger Fehlerpunkte in Live-Demo |
| BergTech als Name | Saile-Transkript 17:01: "Gruppe 1 macht einen HR-Assistent für die fiktive Bergtech Maschinenbau GmbH" | Vorgabe, keine Diskussion |
| Workflow kombinieren statt teilen | Eine Canvas, zwei Sections mit Sticky Notes. In der Demo zeigst du alles auf einen Blick | Besserer Demo-Flow |
| **Wechsel auf All-OpenAI (30.05)** | OpenAI Functions Agent erzwingt OpenAI-Chat-Modell. Anthropic-Modell-ID war zudem retired (404). Ein Provider = weniger Integrations-Blocker | gpt-5-mini (Chat) + text-embedding-3-small (Embeddings). Ersetzt die ursprüngliche Anthropic-für-Chat-Entscheidung |

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

**Root cause:** Das Assignment-PDF (RAG_Project_Assignment.pdf) war nicht lesbar. Name "BergTech" wurde aus der PRD abgeleitet, zu "NovaWork" umbenannt, dann durch Saile-Transkript widerlegt.

**Kosten:** 3× 100+ Text-Ersetzungen in 8 Dateien. 30 Minuten reine Umbenenn-Arbeit.

**Learning:** Vorlesungstranskript lesen BEVOR Namen ändern. Saile nennt alle Firmen wörtlich in der Q&A-Session.

### 3. Sub-Node-Architektur in n8n nicht intuitiv

**Root cause:** n8n LangChain-Nodes verwenden gestrichelte Connections statt Main-Pipeline. `ai_embedding`, `ai_tool`, `ai_textSplitter` sind eigene Connection-Types. Die visuelle Logik ("Node → Sub-Node") ist im JSON invertiert (Sub-Node referenziert Parent).

**Kosten:** Mehrere Fehlversuche beim JSON-Schreiben. Verbindungen waren da, aber in falscher Richtung.

**Learning:** Drag-and-Drop in der UI > JSON editieren. Die Connection-Logik ist versionsabhängig.

### 4. Team-Lieferung kam spät, aber kam (Supabase fehlt noch)

Anfangs 0 Commits von beiden Teammates. Später: Anastasiia lieferte EU AI Act und Gruppendoku (.docx), Juliana die Supabase-Infrastruktur. Juliana setzte sich erst am 30.05. nach 2 Wochen Stille wieder in Kontakt. Fairness-Regel: 33 % für alle, keine schlechte Bewertung.

**Risk:** Wenn das so bleibt, muss Rustam Supabase + EU AI Act allein machen. Das ist machbar, aber eng für die Deadline.

### 5. Embedding-Modell-Default-Falle (11.05 entdeckt)

**Root cause:** Beide Embedding-Nodes im Workflow hatten `"options": {}` — kein Modell explizit gesetzt. n8n nimmt dann OpenAIs Default `text-embedding-ada-002` (2022). In der PRD und Reflection stand aber `text-embedding-3-small`.

Das ist doppelt gefährlich:
1. **Default-Änderung:** OpenAI kann den Default jederzeit wechseln → Ingestion und Query laufen dann mit unterschiedlichen Modellen → Vektoren passen nicht mehr → Retrieval findet nichts
2. **Doku-Realitäts-Gap:** Wir behaupten Modell X, Workflow nutzt Y. Saile würde das im Q&A zerlegen.

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
- Saile-Vorgabe "3 Nodes pro Section" weiterhin erfüllt: Trigger + AI Agent + Vector Store (als Tool) statt Trigger + Agent + Respond

**Learning:** Trigger-Typ beim ersten Build verifizieren. `n8n-nodes-base.webhook` und `@n8n/n8n-nodes-langchain.chatTrigger` sehen im UI ähnlich aus (beide haben einen Webhook-Endpunkt), funktional sind sie aber unterschiedlich. Bei Chatbot-Use-Cases immer den LangChain-Trigger nehmen, er gibt dir die Chat-Sidebar, Session-Memory und automatisches Output-Routing gratis. Den Standard-Webhook nur, wenn du externe Systeme als Caller hast.

---

## Was gut lief — Live-Integration (29.-30.05)

> Acht Blocker hintereinander, am Ende läuft die Pipeline. Was den Tag trotzdem produktiv gemacht hat:

- **Systematisches Eingrenzen statt Raten.** Jeder Fehler wurde isoliert und an der Wurzel gefixt, in Reihenfolge: Dateizugriff (EPERM) → OpenAI-Quota → Agent-Typ → Modell-ID → fehlende RPC → SQL-Ambiguität → Data Loader → System-Prompt. Kein symptomatisches Rumprobieren.
- **Root Cause vor Symptom.** Die vermeintliche Halluzination des Agents war nicht das Problem, sondern Folge des Data-Loader-Bugs (Dateinamen statt Inhalt embeddet). Erst die Stichprobe des Vektor-Inhalts deckte die echte Ursache auf, statt am Prompt herumzudoktern.
- **Pragmatische Architektur-Entscheidung unter Druck.** Statt im Anthropic-Modell-Problem festzuhängen, klarer Schnitt auf All-OpenAI. Ein Provider, sofort lauffähig.
- **Robuste statt schnelle Lösung bei match_documents.** `language sql` plus durchgehende Alias-Qualifizierung beseitigt die Ambiguität strukturell, kein fragiler Workaround.
- **Demo-Risiko bewusst gemanagt.** n8n-Update installiert, Aktivierung per Neustart aber auf nach der Prüfung verschoben. Funktionierenden Agent nicht gegen den Tools Agent getauscht. Stabilität vor Eleganz am Tag vor der Demo.
- **Arbeitsteilung genutzt.** Supabase-Zugang (Anastasiia) und n8n-Zugang (Rustam) sauber getrennt abgearbeitet.

---

## What Went Wrong — Live-Integration (Sprint 29.-30.05)

> Erster echter End-to-End-Lauf mit Live-Supabase, echten API-Keys und der Chat-Sidebar. Die meisten dieser Bugs waren im reinen UI-Build unsichtbar und tauchten erst bei der ersten realen Ausführung auf.

### 9. Symlink ins geschützte Desktop-Verzeichnis bricht n8n-Dateizugriff (29.05)

**Root cause:** `~/.n8n-files/company-docs/rustam` war ein Symlink auf `~/Desktop/UNI/...`. n8n läuft lokal (npm) ohne Full Disk Access auf `~/Desktop`. Der Read/Write-Files-Node folgte dem Symlink und warf `Operation not permitted`. `ls` zeigte normale Permissions, daher irreführend.

**Kosten:** Mehrere Fehlversuche, bis der Symlink als Ursache erkannt war.

**Fix:** Symlink entfernt, die 5 `.md` als echte Kopie direkt unter `~/.n8n-files/company-docs/anastasiia/` abgelegt (ausserhalb der macOS-geschützten Ordner).

**Learning:** n8n-Datenpfade nie als Symlink in `~/Desktop`, `~/Documents`, `~/Downloads` legen. macOS verweigert dem n8n-Prozess dort den Zugriff, unabhängig von den Unix-Permissions. Echte Files in einen ungeschützten Pfad.

### 10. OpenAI-Account ohne Guthaben → 429 (29.05)

**Root cause:** Embeddings-Node warf `429 You exceeded your current quota`. Kein Rate-Limit, sondern leeres Guthaben. 5 Docs zu embedden kostet Cent-Bruchteile, der Account war schlicht auf 0.

**Fix:** OpenAI-Guthaben aufgeladen.

**Learning:** Bei 429 zuerst Billing/Quota prüfen, nicht Rate-Limit annehmen. Embeddings UND Chat hängen am selben OpenAI-Key, ein leerer Account legt beide Pfade gleichzeitig lahm.

### 11. Alte n8n-Version hat keinen Tools Agent (29.05)

**Root cause:** n8n 2.17.7. Der AI Agent stand auf `Conversational Agent` (deprecated), der keine Tools unterstützt: `The selected tools are not supported by Conversational Agent, please use Tools Agent instead`. Der Tools Agent existiert in dieser Version nicht im Dropdown.

**Fix:** Auf `OpenAI Functions Agent` gewechselt. Der nutzt OpenAI-Function-Calling und unterstützt das Vector-Store-Tool, erzwingt aber ein OpenAI-Chat-Modell.

**Learning:** Vector Store als Tool braucht einen tool-fähigen Agent. In n8n 2.17.7 war das am bestehenden (deprecated) Node der OpenAI Functions Agent (zwingend OpenAI-Chat-Modell), nicht der Conversational Agent. n8n 2.22.5 wurde am 30.05. installiert, aber bewusst NICHT per Neustart aktiviert (laufender Prozess bleibt 2.17.7), um die getestete Demo-Konfiguration vor der Präsentation nicht zu verändern. Wichtige Erkenntnis: Ein neu gezogener AI Agent Node ist bereits die moderne Tools-Agent-Version (kein Agent-Dropdown mehr, Slots Chat Model / Memory / Tool, Output Parser nur bei "Require Specific Output Format"). Bestehende Nodes behalten ihre alte typeVersion. Migration des aktiven AI Agent erst nach der Prüfung.

### 12. Retired Anthropic-Modell → 404 (29.05)

**Root cause:** Chat-Modell-Node rief `claude-3-sonnet-20240229` (von Anthropic abgeschaltet): `The resource you are requesting could not be found`. Das UI-Label zeigte "Claude 3.5 Sonnet", die tatsächlich aufgelöste Modell-ID war aber die alte, abgekündigte.

**Fix:** Im Zuge des Agent-Wechsels komplett auf OpenAI `gpt-5-mini` umgestellt (ein Provider für Chat plus Embeddings).

**Learning:** Modell-IDs veralten. Defaultete/hardcodierte Modell-Versionen gegen die aktuelle Provider-Liste prüfen. Folge: Die ursprüngliche Decision "Anthropic für Chat" war mit dem OpenAI Functions Agent nicht mehr haltbar (siehe aktualisierte Decisions-Tabelle).

### 13. match_documents-Funktion fehlte in Supabase (29.05)

**Root cause:** Der Vector Store (Retrieve) rief die RPC `public.match_documents`: `PGRST202 Could not find the function`. Die pgvector-Tabelle existierte, die Similarity-Search-Funktion war aber nie angelegt.

**Fix:** `match_documents(query_embedding vector(1536), match_count int, filter jsonb)` im Supabase SQL Editor angelegt, danach `notify pgrst, 'reload schema'`.

**Learning:** Der Supabase Vector Store braucht zwingend die `match_documents`-RPC mit exakt passender Signatur (Parameter-Namen und Embedding-Dimension). Die Tabelle allein reicht nicht. Gehört ins Setup-SQL, nicht manuell nachgezogen.

### 14. metadata ambiguous in match_documents (29.-30.05)

**Root cause:** `42702 column reference "metadata" is ambiguous`. In `language plpgsql` kollidiert der Output-Name `metadata` aus RETURNS TABLE mit der Tabellenspalte `metadata` im WHERE. Erschwerend liefen mehrere Funktions-Overloads parallel, sodass PostgREST teils die kaputte Variante zog.

**Fix:** Funktion auf `language sql` umgeschrieben (kein PL/pgSQL-Variablen-Scope, also keine Ambiguität möglich) plus durchgehender Tabellen-Alias `d.`. Vorher alle Overloads gedroppt, dann genau eine saubere Funktion neu angelegt.

**Learning:** `match_documents` als `language sql` schreiben und alle Spalten mit Tabellen-Alias qualifizieren. Bei hartnäckigen PGRST/Schema-Fehlern erst alle Overloads droppen, dann eine einzige Funktion neu anlegen.

### 15. Data Loader embeddete Dateinamen statt Inhalt, 50 Müll-Vektoren (30.05)

**Root cause:** Der Default Data Loader stand auf `Type of Data: JSON`. Der Read/Write-Files-Node liefert den Dateiinhalt als BINARY, im JSON-Teil steht nur Metadata (`fileName` etc.). Der Loader vektorisierte also den Dateinamen `2_Vacation_Policy_BergTech.md` statt des Policy-Texts. Retrieval lieferte 4 "Treffer", deren `pageContent` jeweils nur der Dateiname war. Der Agent fiel daraufhin auf allgemeines LLM-Wissen zurück, obwohl die Tabelle 50 Rows hatte.

**Kosten:** Lange Fehlersuche, weil `count(*) = 50` korrekt aussah. Der eigentliche Defekt steckte im Inhalt, nicht in der Zeilenzahl.

**Fix:** Data Loader auf `Type=Binary`, `Data Format=Text` (nicht Auto-Detect, weil der Read-Node `.md` als `application/json` labelte und Auto-Detect es als JSON geparst hätte). 50 Müll-Rows mit `delete from documents` geleert, Ingestion neu gefahren.

**Learning:** Bei Datei-Ingestion immer prüfen WAS tatsächlich im Vektor landet (Stichprobe der `content`-Spalte in Supabase). Read Files liefert Binary, der Data Loader muss Binary plus Text lesen, sonst embeddet er Metadata. Voller Tabellen-Count ist kein Beweis für korrekte Daten.

### 16. Agent ruft das Retrieval-Tool nicht, halluziniert stattdessen (30.05)

**Root cause:** Bei leerem/kaputtem Retrieval fragte der Agent zurück ("soll ich nachschauen?", "meinst du X oder Y?") und antwortete mit allgemeinem GPT-Wissen und generischen Listen statt mit Dokument-Fakten. Der weich formulierte System-Prompt ("Antworte aus den Dokumenten") erzwang den Tool-Aufruf nicht.

**Fix:** System-Prompt gehärtet: Tool-Aufruf bei JEDER inhaltlichen Frage zwingend, keine Rückfragen vor der Suche, ausschliesslich Dokument-Inhalt, expliziter Fallback nur bei leerem Ergebnis. Temperature auf 0.

**Learning:** Tool-Nutzung muss im System-Prompt erzwungen werden ("rufe ZUERST das Tool, niemals Rückfragen vor der Suche, kein allgemeines Wissen"). Ein höflicher Prompt lässt dem Modell die Wahl, und es wählt Bequemlichkeit. Die Halluzination war hier Symptom des leeren Retrievals (#15), nicht die eigentliche Ursache.

---

## What We Learned

1. **n8n-Workflows in der UI bauen, nicht im JSON.** Die JSON-Struktur ist versionsabhängig und enthält interne IDs die n8n selbst generiert.

2. **Embedding-Modell muss für Write und Read identisch sein.** Ingestion mit OpenAI, Query mit einem anderen Modell = keine Matches. Zusätzlich: Modell IMMER explizit setzen, nie auf n8n-Defaults verlassen. Ein Default-Wechsel von OpenAI würde den Workflow unbemerkt zerbrechen.

3. **System Prompt gehört in `options.systemMessage`.** `promptType: define` mit festem `text` überschreibt die User-Frage.

4. **AI Agent Node ist mächtiger als er aussieht.** Intern: LLM-Call + Tool-Auswahl + Retrieval + Antwort-Formatierung. 3 Nodes auf dem Canvas, 5 Sub-Nodes unsichtbar.

5. **Opus-Zweitmeinung findet Bugs die man selbst übersieht.** 4 von 6 kritischen Bugs in v4 wurden von Claude entdeckt, nicht von DeepSeek. Bei sicherheitskritischer Konfiguration (Embedding-Modelle, Chunking) lohnt ein zweiter Review-Durchlauf.

6. **Transkripte lesen, nicht raten.** Firmenname, Dokumenttypen, Node-Limit — alles steht wörtlich in Sailes Aufzeichnung.

7. **Character-based ≠ Token-based.** n8ns RecursiveCharacterTextSplitter arbeitet auf Zeichenebene. 500 Chunk-Size = 500 Zeichen, nicht 500 Tokens. Immer prüfen welche Einheit der Splitter tatsächlich verwendet.

8. **n8n-JSON-Export validiert keine Pflichtparameter.** Der Export schreibt auch unvollständige Nodes. Nach jedem Export: JSON manuell auf `operation`, `fileSelector`, `tableName`, `model` prüfen. Resource-Locators mit `"__rl": true` sind im JSON nicht sichtbar leer, aber im UI schon.

9. **Chat-Trigger ≠ Webhook-Trigger.** `n8n-nodes-base.webhook` ist ein generischer HTTP-Endpoint, `@n8n/n8n-nodes-langchain.chatTrigger` ist der LangChain-spezifische Chat-Hook mit Sidebar-Integration, Session-Memory und automatischem Output-Routing. Für Chatbot-Demos immer den LangChain-Trigger. Erkennungsmerkmale im Panel: Option "Make Chat Publicly Available", kein expliziter HTTP-Path, Sprechblasen-Icon.

10. **Live-Integration deckt auf, was der UI-Build versteckt.** Bugs #9 bis #16 waren alle erst beim ersten echten End-to-End-Lauf sichtbar (Live-DB, echte Keys, Chat-Sidebar). Konsequenz: früher real testen, nicht nur Nodes verdrahten. Ein grün konfigurierter Node ist kein Beweis für eine funktionierende Pipeline.

11. **"Daten sind da" ist nicht "Daten sind korrekt".** 50 Rows in der Tabelle, alle mit Dateinamen statt Inhalt embeddet. Nach jeder Ingestion stichprobenartig die `content`-Spalte lesen. Zeilenzahl allein beweist nichts.

12. **Single-Provider reduziert die Fehlerfläche.** Der Split "Anthropic für Chat, OpenAI für Embeddings" klang kosteneffizient, kostete in der Integration aber zwei Blocker auf einmal (retired-Modell-404 plus Agent-Inkompatibilität). All-OpenAI (gpt-5-mini + text-embedding-3-small) lief sofort. Für die Demo zählt Robustheit über theoretische Eleganz.

13. **match_documents ist Teil des Setups, nicht des Codes.** Die RPC-Funktion plus korrekte Signatur und Embedding-Dimension gehören ins Supabase-Setup-SQL und müssen versioniert sein. Sonst läuft die Pipeline lokal und bricht beim nächsten frischen Supabase-Projekt.

---

## What's Left for 1.0

| Item | Owner | Blocked by | Risiko |
|------|-------|-----------|--------|
| Supabase + pgvector Setup | Juliana | — | Hoch (0 Commits) |
| API Credentials (Anthropic + OpenAI) | Rustam | — | Niedrig |
| 3 Demo-Fragen Live-Test | Rustam | Supabase | Mittel |
| EU AI Act Analyse | Anastasiia | — | Hoch (0 Commits) |
| 10-Seiten Doku | Alle | EU AI Act | Mittel |
| Reflection Section | Rustam | — | Niedrig (dieses Doc) |
| Präsentation 15 Min + Slides | Alle | Doku | Mittel |
| Live Demo Rehearsal (3-5×) | Alle | Workflow live | Hoch |
| Individual Grading Report | Rustam | — | Niedrig |
| Q&A Vorbereitung | Alle | Präsi | Niedrig |

**Kritischer Pfad:** Supabase → Live-Test → Rehearsal → Präsentation. Wenn Juliana bis 15.05 nicht liefert, übernimmt Rustam.

---

## Timeline

| Datum | Milestone |
|-------|-----------|
| 10.05 | ✅ Workflow v4.2 + Docs gepusht |
| 11.05 | ✅ Workflow v4.3: Modell-Update + Embedding-Fix + Default-Hardening |
| 13.05 | Phase 3 Start: Supabase + Credentials |
| 18.05 | Q&A Session mit Saile (freiwillig) |
| 22.05 | E2E Test mit 3 Demo-Fragen |
| 27.05 | Doku + EU AI Act fertig |
| 29.05 | Live-Integration: Supabase-Credentials, Symlink-Fix, OpenAI-Billing, Agent-Wechsel auf OpenAI Functions, match_documents angelegt |
| 30.05 | Data-Loader-Bug gefixt (Dateiname → Inhalt), System-Prompt gehärtet, Reingestion mit 500/50, End-to-End grün |
| 31.05 | **Submission Deadline** |
| 01.06 | **Präsentation + Live Demo** |

---

---

## Q&A-Vorbereitung — Sailes wahrscheinlichste Fragen

> 15 Min Präsi + 10 Min Q&A. Saile stellt technische Detailfragen. Diese Sektion = Redeskript für Rustam.

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

Saile-Vorgabe: "n8n einfach halten, 3-4 Nodes." Der AI Agent Node ist intern mächtiger als er aussieht:

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

### "Sind Ingestion und Chat miteinander verbunden? Wie kommt ein Dokument überhaupt in den Chat?"

Nein, das sind zwei getrennte Pfade auf einer Canvas, bewusst nicht verdrahtet:

- **Ingestion** (Manual Trigger) läuft einmalig und schreibt die Dokument-Vektoren in Supabase.
- **Query** (Chat Trigger) läuft pro Nutzerfrage und liest aus Supabase.

Die Verbindung ist die Supabase-Tabelle `documents`, kein Draht zwischen den Nodes. Ingestion ist der Schreibvorgang, Query der Lesevorgang auf derselben Datenbank. Eine direkte Verdrahtung wäre sogar falsch, weil der Chat dann bei jeder Frage die komplette Neu-Indexierung auslösen würde.

Die zwei Voraussetzungen, damit das funktioniert: beide Pfade nutzen dieselbe Tabelle und dasselbe Embedding-Modell. Sonst passen die Vektoren von Schreib- und Lesevorgang nicht zusammen.

### "Was passiert, wenn ihr ein Dokument aktualisiert?"

Der Ingestion-Pfad wird erneut ausgeführt. Bei unserem Setup würde man die alten Vektoren vorher leeren (`delete from documents`) und neu indexieren, damit keine veralteten Chunks zurückbleiben. Für den Produktivbetrieb wäre ein Upsert pro Dokument mit Versions-Metadata der sauberere Weg.

### "EU AI Act — welche Rolle spielt euer Chatbot?"

- **Provider:** Wir (Gruppe 1) — entwickeln und deployen den Chatbot
- **Deployer:** BergTech — setzt ihn intern ein
- **Affected Persons:** BergTech-Mitarbeiter — interagieren mit dem Bot
- **GPAI Provider:** Anthropic (Claude) + OpenAI (Embeddings)

Risikoklasse: **Limited-Risk** (Chatbot mit menschlicher Interaktion, Art. 50 Transparenzpflicht).

Umsetzung: Transparenzhinweis im System Prompt, "Ich weiß nicht"-Fallback, Quellenangabe in Antworten, keine PII-Verarbeitung.

---

**Last Updated:** 30.05.2026 (Live-Integration Sprint)  
**Next Review:** 31.05 (Submission) / 01.06 (Präsentation + Live Demo)
