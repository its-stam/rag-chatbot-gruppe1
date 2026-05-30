# Re-Ingest Koordination — Rustam + Nastja

> Zweck: Saubere Neu-Einspielung der Vektoren, damit die Live-Demo robust läuft.
> Hintergrund: Bei einer gezielten Arbeitszeit-Frage hat der Bot an HR verwiesen,
> obwohl die Info existiert. Ursachen: (1) evtl. alte/gemischte Embeddings in
> Supabase, (2) topK stand auf Default 4, (3) Arbeitszeit-Info steht nur in einem
> schwachen Meta-Satz. Punkte 1-2 fixen wir hier, Punkt 3 siehe
> `vorschlag-arbeitszeit-faq.md`.

## Wichtig: Reihenfolge einhalten

Truncate (Nastja) und Re-Ingest (Rustam) müssen NACHEINANDER laufen. Sonst sind
entweder noch alte Embeddings drin oder die Tabelle ist beim Demo-Versuch leer.

## Ablauf

### Schritt 1 — Nastja (Supabase)
Im Supabase SQL Editor:
```sql
TRUNCATE documents;
```
Danach kurz Bescheid geben ("Tabelle leer").

### Schritt 2 — Rustam (n8n)
Erst NACH Nastjas OK:
- Ingestion-Workflow öffnen
- Manual Trigger "READ MD-File" starten
- Läuft durch alle Docs unter `company-docs/anastasiia/**/*.md`

### Schritt 3 — Verify (gemeinsam)
Nastja prüft im Supabase SQL Editor:
```sql
SELECT count(*) FROM documents;
-- sollte > 0 sein (mehrere Chunks pro Doc)

SELECT left(content, 80) FROM documents LIMIT 5;
-- muss echten Dokumenttext zeigen, KEINE Metadaten-Header
```
Der zweite Check ist wichtig: Wenn dort nur "DOKUMENTEN-METADATEN: ..." steht,
ist der Data-Loader wieder falsch konfiguriert (bekannter Bug vom 30.05.).

### Schritt 4 — Rustam (Demo-Test)
3 Demo-Fragen durchlaufen lassen, plus die kritische:
- "Wie viele Urlaubstage habe ich?"
- "Was muss ich beim Onboarding beachten?"
- "Welche Pflichttrainings gibt es?"
- "Wie sind die Arbeitszeiten?" (der bisher fehlschlagende Fall)

## Aktueller n8n-Stand (Rustam, erledigt)
- Ingestion-Pfad auf `anastasiia/**/*.md` eingegrenzt (nur Nastjas Set)
- topK im Retrieve-Node auf 8 erhöht
- Re-Export als v4.7.2

## Falls "Arbeitszeit" weiter scheitert
Dann liegt es am schwachen Quell-Satz, nicht an n8n. Lösung: die Q&A aus
`vorschlag-arbeitszeit-faq.md` in das FAQ-Doc aufnehmen (Entscheidung Nastja,
da es ihre Docs sind) und erneut re-ingesten.
