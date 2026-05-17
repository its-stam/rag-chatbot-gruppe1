# Company Docs — Übersicht

Hier liegen unsere internen HR-Dokumente für den RAG-Chatbot. Aktuell haben wir zwei parallele Sets, weil wir unabhängig voneinander gestartet sind. Beide decken die gleichen fünf Themen ab — was wir am Ende für die Demo nutzen, klären wir gemeinsam.

## Ordnerstruktur

```
company-docs/
├── rustam/         5 .md + pdf/ (1. Iteration)
└── hr-set-a/     5 .docx (Original) + 5 .md (pandoc-konvertiert)
```

## Dozent-Anforderungen (zum Reminder)

Laut Aufgabenstellung:

- Mindestens 5 interne Dokumente pro Gruppe
- Jedes Dokument mindestens eine Seite Inhalt
- Upload als PDF
- Die drei Beispielfragen (Onboarding, Urlaub, Pflichttrainings) müssen damit beantwortbar sein

## Stand der Sets

| # | Thema | rustam/ (Wörter) | hr-set-a/ (Wörter) |
|---|-------|------------------|----------------------|
| 1 | Onboarding | 588 | 339 |
| 2 | Vacation | 521 | 256 |
| 3 | Compliance | 543 | 197 |
| 4 | HR-FAQ | 761 | 136 |
| 5 | Offboarding | 626 | 139 |

Standard sind ~250–300 Wörter pro Seite. Bei mehreren Docs aus dem hr-set-a-Set sind wir nah an oder unter der "eine Seite"-Schwelle — kann durch Listen, Whitespace und Schriftgröße trotzdem optisch auf eine Seite kommen, sieht man erst nach PDF-Render.

## Inhaltliche Unterschiede (Beispiele)

Beim Querlesen sind ein paar Stellen aufgefallen, wo unsere Sets unterschiedliche Aussagen treffen. Wichtig vor allem für die drei Dozent-Demo-Fragen — der Bot würde sonst je nach getroffenem Chunk zwei verschiedene Antworten geben.

| Frage | rustam/ | hr-set-a/ |
|-------|---------|-------------|
| Urlaub Vorlaufzeit | 5 Werktage / 14 Tage / 6 Wochen (gestaffelt nach Länge) | mind. 14 Tage Standard, 3 Arbeitstage bei ≤2 Tagen |
| Krankmeldung | telefonisch vor Arbeitsbeginn, AU ab Tag 3 | bis 08:30 telefonisch oder Mail, AU ab Tag 3 in Personio |
| Pflichttrainings Onboarding | Liste in eigener Section | UVV, DSGVO, Compliance-Basis, Brandschutz |

Es geht nicht darum welches "richtig" ist (ist ja eine fiktive Firma) — wir müssen uns nur auf eine Linie einigen, damit der Chatbot konsistent antwortet.

## Aktuelle Ingestion

Aktuell zieht der n8n-Workflow nur das rustam/-Set (Symlink von `~/.n8n-files/company-docs/` ins Repo). Das ist ein Zwischenstand, keine endgültige Auswahl. Sobald wir beim Sync besprechen welches Set wir nehmen oder mergen, passen wir die Ingestion an.

## Was beim nächsten Sync zu klären wäre

1. Welches Set wir als Primary nehmen (oder Merge)
2. Falls Merge: wer welche Doc-Stelle übernimmt
3. Konflikte auflösen — pro Frage eine kanonische Antwort
4. PDF-Render am Ende, um zu prüfen ob alle Docs visuell auf eine Seite kommen

Keine Eile, kein "muss heute" — vor 31.05. ist Zeit.
