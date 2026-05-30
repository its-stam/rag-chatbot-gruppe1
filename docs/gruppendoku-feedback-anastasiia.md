# Feedback & Ergänzungen zur Gruppendokumentation

> Bezug: `BergTech_RAG_Dokumentation_Gruppe1.docx` (Stand 29.05.)
> Zweck: Abgleich der Doku mit der tatsächlich laufenden Implementierung (Stand 30.05., nach Live-Integration). Vorschläge zum Einpflegen, damit die Doku Q&A-fest ist.
> Owner der .docx bleibt Anastasiia. Das hier sind nur Vorschläge, kein Überschreiben.

---

## Kritisch (faktische Lücke zur echten Implementierung, Q&A-Risiko)

Saile fragt im Q&A technische Details ab. Wo Doku und Workflow auseinanderlaufen, entsteht Angriffsfläche.

| # | Stelle in der Doku | Doku sagt | Realität (Workflow) | Vorschlag |
|---|--------------------|-----------|---------------------|-----------|
| 1 | 4.1 Ingestion, Schritt 2 | "n8n liest die Dateien **aus Supabase**" | n8n liest von der **Festplatte** (Node "Read/Write Files from Disk", Pfad `company-docs/**/*.md`). Supabase ist das **Ziel**, nicht die Quelle | "n8n liest die Dokumentdateien vom Dateisystem (Markdown), zerlegt sie und schreibt die Vektoren nach Supabase" |
| 2 | 2. Dokumentendatenbank | Dokumente "als **PDF**" aufgenommen | Ingestet werden **Markdown-Dateien** (`.md`). PDFs existieren als Quellformat, in die Vektor-DB gehen die `.md` | "fünf interne Dokumente (Markdown), abgeleitet aus den PDF-Vorlagen" |
| 3 | 3.1 + 4.2 LLM | "OpenRouter / GPT-4o **oder Claude 3.5 Sonnet**" | Aktuell **OpenAI `gpt-5-mini` direkt** (kein OpenRouter, kein Claude). Umgestellt am 30.05.: Der OpenAI Functions Agent erzwingt ein OpenAI-Chat-Modell, das Anthropic-Modell war zudem abgekündigt | "Als LLM wird OpenAI `gpt-5-mini` über den n8n OpenAI-Functions-Agent angesprochen" |
| 4 | 4.3 System-Prompt | Alter, weicher Prompt-Auszug | Es läuft ein **gehärteter** Prompt: erzwingt Tool-Aufruf bei jeder Frage, verbietet Rückfragen vor der Suche, verbietet allgemeines Wissen, expliziter HR-Fallback | Aktuellen Prompt-Wortlaut aus dem Node übernehmen (siehe unten) |

### Aktueller System-Prompt (zum Übernehmen in 4.3)

```
Du bist der HR-Assistant der BergTech Maschinenbau GmbH.

Arbeitsweise (zwingend):
- Bei jeder inhaltlichen Frage zuerst das Tool "Supabase Vector Store" aufrufen
  und die HR-Dokumente durchsuchen. Ohne Ausnahme.
- Keine Rückfragen vor der Suche.
- Ausschliesslich Inhalt der gefundenen Dokumente nutzen, kein allgemeines Wissen.

Antwort:
- Knapp und konkret mit Fakten aus den Dokumenten.
- Quelle als [Dokumentname] nennen.
- Wenn die Suche nichts liefert: "Diese Information liegt mir in den HR-Dokumenten
  nicht vor. Bitte wende dich an hr@bergtech.de."
```

---

## Mittel (Konsistenz / Formales)

| # | Stelle | Problem | Vorschlag |
|---|--------|---------|-----------|
| 5 | Deckblatt | "Eingereicht am 31. Mai **2025**" | 2026 |
| 6 | Deckblatt | "Modul: Künstliche Intelligenz / AI-Anwendungen" | An den tatsächlichen Kurs anpassen: "LLM & Agentics" (Dozent Saile). Falls der offizielle Modulname anders lautet, prüfen |
| 7 | 4.2, Schritt 3 | "k = 5" ähnlichste Passagen | Der Retrieve-Node steht aktuell auf **Limit 4**. Entweder Doku auf 4 ändern oder Node auf 5 setzen, beide konsistent halten |
| 8 | Kapitel 7 | Nummerierung springt: "7. Implementierungsreflexion" dann "**8**.1 / 8.2 / 8.3 / 8.4" | Auf 7.1 / 7.2 / 7.3 / 7.4 korrigieren |
| 9 | 4.1, Schritt 3 | Chunking nur "definierter Länge und Überlappung" | Konkret nennen: **500 Zeichen, Overlap 50**, RecursiveCharacterTextSplitter (zeichen-basiert). Das zeigt eine bewusste Entscheidung statt Default |

---

## Stimmt überein (so lassen)

- `text-embedding-3-small` als Embedding-Modell
- pgvector + `match_documents()` + Cosine Similarity
- Demo-Frage 2 ("14 Tage im Voraus") deckt sich mit der Urlaubsrichtlinie
- Quellengebundenheit + HR-Fallback als Halluzinationsschutz
- Risiken-Tabelle (Kapitel 6) ist solide und vollständig

---

## Reflexion (Kap. 7): was gut und was schlecht lief

Die jetzige Reflexion ist sauber, aber generisch (RAG-Paradigma, Vektordatenbanken, Prompt Engineering). Saile honoriert erlebte Tiefe. Hier konkrete Punkte aus der Integration, formal formuliert, direkt übernehmbar in 7.1 (Lernerfahrungen), 7.2 (Stärken) und 7.3 (Schwächen).

### Was gut lief (für 7.1 / 7.2)

- **Systematisches Debugging unter Zeitdruck.** In der Integrationsphase trat eine Reihe von Fehlern auf, die einzeln isoliert und an der Ursache behoben wurden, statt symptomatisch zu reagieren.
- **Pragmatische Architekturentscheidung.** Als das ursprünglich geplante Chat-Modell nicht mehr verfügbar war, wurde konsequent auf einen einzigen Anbieter (OpenAI) umgestellt. Das reduzierte die Integrationskomplexität und stellte die Lauffähigkeit zügig wieder her.
- **Verifizierte Quellenbindung.** Die generierten Antworten wurden stichprobenartig gegen die Originaldokumente geprüft. Der Chatbot gibt die Inhalte korrekt und mit Quellenangabe wieder, ohne eigene Fakten zu ergänzen.

### Was schlecht lief / Herausforderungen (für 7.1 / 7.3)

- **Datenmenge ist kein Beleg für Datenqualität.** In einer Phase enthielt die Vektordatenbank zwar die erwartete Anzahl Einträge, diese repräsentierten aber Metadaten statt Dokumentinhalte (Fehlkonfiguration des Data Loaders). Der Fehler war erst durch eine inhaltliche Stichprobe erkennbar.
- **Tool-Nutzung muss erzwungen werden.** Ohne explizite Anweisung im System-Prompt wich das Sprachmodell auf allgemeines Wissen aus, statt die Wissensdatenbank zu durchsuchen. Erst ein restriktiver Prompt sicherte die ausschließliche Nutzung der Dokumente.
- **Abhängigkeit von externen Diensten zeigte sich konkret.** Kontingentgrenzen und die Abkündigung eines Modells führten zu temporären Ausfällen. Das unterstreicht die in Kapitel 6 genannte Drittanbieter-Abhängigkeit als reales, nicht nur theoretisches Risiko.
- **Konsistenz des Embedding-Modells ist kritisch.** Ingestion und Abfrage müssen dasselbe Embedding-Modell verwenden, andernfalls liefert die Vektorsuche keine Treffer. Das Modell wurde daher explizit gesetzt, statt sich auf Voreinstellungen zu verlassen.

Diese Punkte fügen sich in die bestehende Struktur von Kapitel 7 ein, ohne sie zu ersetzen.

---

## Update 30.05. (Stand nach Team-Sync und Workflow v4.7.2)

Diese Punkte sind nach dem ursprünglichen Feedback dazugekommen. Bitte zusätzlich
zu den obigen Stellen in der Doku berücksichtigen.

### A) Set-Entscheidung — nur ein Dokumentensatz

Wir nutzen für die Vektor-DB und die Demo **ausschließlich Anastasiias Dokumentensatz**
(5 Markdown-Docs). Rustams Satz bleibt als Quell-Archiv im Repo, wird aber NICHT
ingested.

- **Warum:** Beide Sätze trafen bei einigen Themen unterschiedliche Aussagen
  (z.B. Urlaubs-Vorlaufzeit). Ein einzelner Satz garantiert pro Frage genau eine
  kanonische Antwort und vermeidet widersprüchliche Chatbot-Antworten.
- **Für die Doku:** Wo erwähnt wird "fünf interne Dokumente" — klarstellen, dass
  es sich um den einen, finalen Satz handelt, nicht um eine Zusammenführung mehrerer.

### B) Retrieval-Parameter aktualisiert: topK = 8

Im vorherigen Feedback (Punkt 7) stand "k = 5 bzw. Node auf 4". Final umgesetzt
ist jetzt **topK = 8**.

- **Für die Doku (Kap. 4.2):** Die Zahl der zurückgegebenen Passagen auf **8**
  korrigieren, falls dort noch 4 oder 5 steht.
- **Begründung (für Q&A):** Mehr abgerufene Passagen erhöhen die Trefferwahrscheinlichkeit
  bei Themen, die nur in einem einzelnen Chunk stehen.

### C) Bekannter Recall-Punkt: Arbeitszeit-Frage

Bei der direkten Frage "Wie sind die Arbeitszeiten?" verwies der Chatbot an HR,
obwohl die Information vorhanden ist.

- **Ursache:** Die Arbeitszeit-Info (Kernarbeitszeit 09:00-15:00, max. 10h) steht
  nur als beiläufiger Satz im Onboarding-Guide ("Arbeitszeitordnung: Erklärt die
  Kernarbeitszeit..."). Es gibt keine eigene, suchbare Q&A dazu. Für die Vektorsuche
  ist dieser eine Meta-Satz zu schwach.
- **Lösungsvorschlag:** Eine eigene Q&A "Wie sind die Arbeitszeiten bei BergTech?"
  ins FAQ-Dokument aufnehmen (konkreter Textvorschlag liegt bei). Da es deine Docs
  sind, entscheidest du, ob/wie wir das einfügen.
- **Für die Doku:** Optional als ehrliches Beispiel in Kapitel 7 (Reflexion) — zeigt
  systematisches Vorgehen bei RAG-Recall-Problemen.

### D) Re-Ingest noch durchzuführen (Koordination Rustam + Nastja)

Damit die Vektor-DB sauber nur Anastasiias Satz enthält, muss einmal neu ingested
werden — in dieser Reihenfolge:

1. **Nastja (Supabase):** `TRUNCATE documents;` im SQL Editor, dann Bescheid geben
2. **Rustam (n8n):** Ingestion-Workflow neu laufen lassen
3. **Gemeinsam verifizieren:** `SELECT count(*)` > 0 und Stichprobe, dass echter
   Dokumenttext (keine Metadaten-Header) in der Tabelle steht
4. **Rustam:** 3 Demo-Fragen + Arbeitszeit-Frage durchtesten

Erst nach diesem Schritt gilt der E2E-Live-Test als bestanden.
