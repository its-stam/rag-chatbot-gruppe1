# Präsentations-Leitfaden — n8n RAG Workflow

Step-by-Step zum Durchklicken in der Live-Demo. Zwei Teile: Ingestion (Doku-Aufbereitung) und Query (Frage beantworten).

---

## TEIL 1 — INGESTION (Dokumente in die Vektor-DB laden)

Wird einmalig ausgeführt — oder erneut, wenn HR-Dokumente aktualisiert werden.

### Was man in der Präsi sagt

"Bevor der Chatbot Fragen beantworten kann, müssen die HR-Dokumente einmal
aufbereitet und in die Vektordatenbank geladen werden. Das macht der
Ingestion-Workflow."

### Die Schritte

**Schritt 1 — READ MD-File (Manual Trigger)**
- Startet den Workflow manuell per Klick.
- Sagen: "Der Ingestion-Workflow läuft nicht automatisch, sondern wird bewusst
  angestoßen, wenn sich Dokumente ändern."

**Schritt 2 — Read/Write Files from Disk**
- Liest die fünf HR-Markdown-Dateien vom Dateisystem (`anastasiia/**/*.md`).
- Sagen: "n8n liest die Dokumente von der Festplatte ein — nicht aus Supabase.
  Supabase ist das Ziel, nicht die Quelle."

**Schritt 3 — Text Splitter + Default Data Loader (Sub-Nodes)**
- Data Loader bekommt die Dateien vom Insert-Node und reicht sie an den Splitter.
  Splitter zerlegt in Chunks (500 Zeichen, 50 Overlap), gibt sie an den Loader zurück.
  Der Loader fügt Metadaten hinzu (Dateiname als Quelle).
- Sagen: "Splitter und Data Loader arbeiten zusammen: Der Loader übergibt den
  Volltext, der Splitter gibt Chunks zurück — ein Hin-und-Her. Zusammen erzeugen sie
  strukturierte Chunks mit Quellen-Metadaten."

**Schritt 4 — Embeddings (Sub-Node)**
- Wandelt jeden Chunk in einen Vektor um. Text rein → Vektor raus.
- Modell: `text-embedding-3-small`. Dasselbe Modell wie bei der Abfrage,
  sonst liefert die Suche keine Treffer.
- Sagen: "Die Embeddings-API ist ein Dienst: Chunk-Text als Anfrage rein,
  Zahlenvektor als Antwort raus. Deshalb als Doppelpfeil dargestellt."

**Schritt 5 — Supabase Vector Store (INSERT)**
- Speichert Chunks + Vektoren in der Tabelle `documents` (pgvector).
- Sagen: "Am Ende liegen alle Vektoren in Supabase und sind durchsuchbar."

### Demo-Hinweis
- Vorher einmal sauber durchlaufen lassen (nach Re-Ingest).
- Zur Kontrolle in Supabase: `SELECT count(*) FROM documents;` zeigt die Chunks.

---

## TEIL 2 — QUERY (Nutzerfrage beantworten)

Läuft bei jeder einzelnen Frage im Chat.

### Was man in der Präsi sagt

"Sobald die Wissensbasis geladen ist, kann der Chatbot Fragen beantworten. Das
übernimmt der Query-Workflow — live über die n8n Chat-Oberfläche."

### Die Schritte

**Schritt 1 — Chat Message (Chat Trigger)**
- Empfängt die Nutzerfrage über die n8n Chat-Sidebar.
- Sagen: "Die Frage kommt über den Chat-Trigger rein."

**Schritt 2 — AI Agent (OpenAI Functions Agent)**
- Zentrale Steuerung. Bekommt den gehärteten System-Prompt und entscheidet,
  das Vector-Store-Tool aufzurufen.
- Sagen: "Der Agent ist das Gehirn. Per System-Prompt ist er gezwungen, bei
  jeder Frage zuerst die Wissensdatenbank zu durchsuchen — kein Allgemeinwissen."

**Schritt 3 — Embeddings (Sub-Node)**
- Die Nutzerfrage wird mit demselben Modell vektorisiert wie die Dokumente.
- Sagen: "Damit die Suche funktioniert, muss die Frage in denselben Vektorraum
  übersetzt werden wie die Dokumente."

**Schritt 4 — Supabase Vector Store (RETRIEVE, als Tool)**
- Findet die 8 ähnlichsten Chunks per Cosine Similarity (topK = 8).
- Sagen: "Supabase liefert die acht passendsten Textstellen zurück. Wir haben
  topK bewusst auf 8 erhöht, damit auch Themen gefunden werden, die nur in
  einem einzelnen Chunk stehen."

**Schritt 5 — Chat Model (gpt-5-mini, Sub-Node)**
- Formuliert aus den gefundenen Chunks die Antwort.
- Sagen: "Das Sprachmodell formuliert die Antwort ausschließlich aus den
  gefundenen Dokumentstellen — mit Quellenangabe."

**Schritt 6 — Antwort an den Nutzer**
- Knappe, faktenbasierte Antwort mit Quelle `[Dokumentname]`. Bei keinem
  Treffer: Verweis an `hr@bergtech.de`.
- Sagen: "Findet die Suche nichts Passendes, erfindet der Bot nichts, sondern
  verweist an HR. Das ist unser Halluzinationsschutz."

### Demo-Fragen (in dieser Reihenfolge zeigen)
1. "Welche Unterlagen muss ich vor dem ersten Arbeitstag einreichen?" (Onboarding)
2. "Wie viele Tage im Voraus muss ich Urlaub beantragen?" (Urlaub)
3. "Welche Pflichtschulungen gibt es im Onboarding?" (Trainings)

Optional als Härtetest: "Wie sind die Arbeitszeiten?" — funktioniert nach
Re-Ingest und FAQ-Ergänzung.

---

## Roter Faden für die Präsentation

1. Problem (HR ertrinkt in repetitiven Fragen) → 30 Sek.
2. Lösung: RAG-Chatbot, Architektur-Diagramm zeigen → 2 Min.
3. Ingestion-Workflow erklären (Teil 1) → 3 Min.
4. Query-Workflow erklären (Teil 2) → 3 Min.
5. Live-Demo mit 3 Fragen → 4 Min.
6. Reflexion: was lief gut/schlecht + EU AI Act → 2 Min.
7. Puffer / Überleitung Q&A → 1 Min.

Gesamt ~15 Min.

## Q&A-Vorbereitung — Theorie & Verständnis (Saile-typisch)

Saile fragt eher nach Verständnis und Konzepten als nach technischen Details.
Diese Fragen kann jeder im Team mit seiner Stärke beantworten.

### "Erklärt mal, wie euer RAG-System funktioniert."
→ Zwei Workflows: Ingestion (Dokumente einmalig in Vektoren umwandeln und in
Supabase speichern) und Query (Nutzerfrage vektorisieren, ähnlichste Chunks
finden, LLM formuliert Antwort). Die Antwort kommt NUR aus unseren HR-Docs, nie
aus Allgemeinwissen. (Rustam)

### "Wie stellt ihr sicher, dass der Bot nichts Falsches sagt?"
→ Drei Schichten: 1) System-Prompt mit Tool-Zwang (erst suchen, dann antworten),
2) Temperatur 0.3, 3) Quellenangabe + Fallback an hr@bergtech.de wenn nichts
gefunden. Wir erfinden nichts. (Rustam)

### "Was bedeutet der EU AI Act für euren Chatbot?"
→ Limited Risk (Art. 50): Transparenzpflicht — Nutzer müssen wissen, dass sie
mit einer KI sprechen. Keine Hochrisiko-Einstufung, da keine rechtswirksamen
Entscheidungen getroffen werden. (Anastasiia)

### "Wie könnte man das System weiterentwickeln?"
→ Conversation Memory für Folgefragen, Mehrsprachigkeit, Live-Daten aus SAP HR.
Embedding-Modell auf domain-spezifische Modelle umstellen. Retrieval mit
Keyword-Suche kombinieren für bessere Abdeckung. (Juliana — ML-Perspektive)

### "Wo liegen die Grenzen von Embedding-basierter Suche?"
→ Semantisch ähnlich ≠ inhaltlich korrekt. Bei dünn belegten Themen (wie unser
Arbeitszeit-Beispiel) findet die Vektorsuche den Chunk nicht zuverlässig.
Keyword-Suche ist deterministisch aber unflexibel. RAG braucht beide Welten.
(Juliana — ML-Perspektive)

### "Was war die größte Herausforderung im Projekt?"
→ Jeder eine Story: Rustam (Workflow-Debugging + LLM-Abkündigung am 30.05.),
Anastasiia (Doku mit Live-Implementierung abgleichen — Deckblatt 2025→2026 etc.),
Juliana (Supabase pgvector + match_documents zum Laufen bringen).

---

## Q&A-Vorbereitung — Technik (falls Saile Details fragt)

- "Warum 500 Zeichen Chunks?" → Balance: Kontext vs. präzises Retrieval.
- "Warum topK 8?" → Trefferrate bei dünn belegten Themen (Arbeitszeit-Beispiel).
- "Warum gpt-5-mini?" → OpenAI-Functions-Agent braucht OpenAI-Modell.
- "Embedding-Konsistenz?" → text-embedding-3-small explizit gesetzt, kein Default.
