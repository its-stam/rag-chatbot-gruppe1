# Company Docs — Übersicht

Hier liegen die internen HR-Dokumente, die der RAG-Chatbot als Wissensbasis nutzt.
Fünf Dokumente decken Onboarding, Urlaub, Compliance, HR-FAQ und Offboarding ab.

## Ordnerstruktur

```
company-docs/
└── hr-set-a/     5 .md (pandoc aus .docx) — ingested
```

## Dozent-Anforderungen

Laut Aufgabenstellung:

- Mindestens 5 interne Dokumente pro Gruppe
- Jedes Dokument mindestens eine Seite Inhalt
- Upload als PDF
- Die drei Beispielfragen (Onboarding, Urlaub, Pflichttrainings) müssen damit beantwortbar sein

## Ingestion

Der n8n-Workflow (v4.7.2) zieht das Set unter
`~/.n8n-files/company-docs/hr-set-a/**/*.md`. retrieve topK steht auf 8.
