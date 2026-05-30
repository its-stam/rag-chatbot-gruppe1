# Company Docs — Übersicht

Hier liegen unsere internen HR-Dokumente für den RAG-Chatbot. Es gibt zwei Sets
(rustam, anastasiia), die die gleichen fünf Themen abdecken. **Set-Entscheidung
(30.05.): Für die Demo und die Vektor-DB nutzen wir ausschließlich das
anastasiia/-Set.** Das rustam/-Set bleibt als Quell-Archiv im Repo, wird aber
nicht ingested.

## Ordnerstruktur

```
company-docs/
├── anastasiia/     5 .md (pandoc aus .docx) — AKTIVES Set, ingested
└── rustam/         5 .md + pdf/ — Quell-Archiv, NICHT ingested
```

## Saile-Anforderungen (zum Reminder)

Laut Aufgabenstellung:

- Mindestens 5 interne Dokumente pro Gruppe
- Jedes Dokument mindestens eine Seite Inhalt
- Upload als PDF
- Die drei Beispielfragen (Onboarding, Urlaub, Pflichttrainings) müssen damit beantwortbar sein

## Aktuelle Ingestion

Der n8n-Workflow (v4.7.2) zieht ausschließlich das anastasiia/-Set:
`~/.n8n-files/company-docs/anastasiia/**/*.md`. retrieve topK steht auf 8.

## Warum anastasiia/ als aktives Set

Die Entscheidung für ein einzelnes Set vermeidet widersprüchliche Antworten:
beide Sets trafen bei einigen Themen unterschiedliche Aussagen (siehe unten),
was den Chatbot je nach getroffenem Chunk inkonsistent hätte antworten lassen.
Ein Set = eine kanonische Antwort pro Frage.

## Inhaltliche Unterschiede der Sets (dokumentiert, historisch)

| Frage | rustam/ | anastasiia/ |
|-------|---------|-------------|
| Urlaub Vorlaufzeit | 5 Werktage / 14 Tage / 6 Wochen (gestaffelt) | mind. 14 Tage Standard, 3 Arbeitstage bei ≤2 Tagen |
| Krankmeldung | telefonisch vor Arbeitsbeginn, AU ab Tag 3 | bis 08:30 telefonisch oder Mail, AU ab Tag 3 in Personio |
| Pflichttrainings | Liste in eigener Section | UVV, DSGVO, Compliance-Basis, Brandschutz |

Da der Chatbot nur das anastasiia/-Set nutzt, gelten dessen Aussagen als kanonisch.

## Bekannter Recall-Punkt

Direkte Arbeitszeit-Fragen ("Wie sind die Arbeitszeiten?") werden bisher schwach
beantwortet, weil die Info nur als Meta-Satz im Onboarding-Guide steht.
Lösungsvorschlag in `../docs/vorschlag-arbeitszeit-faq.md` (Abstimmung mit
Anastasiia, da es ihre Docs sind).
