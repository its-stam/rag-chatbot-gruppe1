# Vorschlag: Arbeitszeit-Q&A für das FAQ-Doc

> An: Nastja (die HR-Docs gehören dir, daher nur ein Vorschlag — kein Edit von uns)
> Betrifft: `company-docs/anastasiia/4_HR_FAQ_BergTech.md`
> Grund: Bei der Frage "Wie sind die Arbeitszeiten?" verweist der Bot an HR,
> obwohl die Info im System steht. Sie steht aber nur als beiläufiger Meta-Satz
> im Onboarding-Guide ("Arbeitszeitordnung: Erklärt die Kernarbeitszeit...").
> Das ist für die Vektorsuche zu schwach — es gibt keine eigene Q&A dazu.

## Das eigentliche Problem

Im FAQ gibt es eine Sektion "Arbeitszeit und Flexibilität", aber die behandelt
nur Homeoffice und Krankmeldung — NICHT die eigentlichen Arbeitsstunden.
Die Stunden-Info (Kernarbeitszeit 09:00-15:00, max 10h/Tag) existiert nur
einmal, als Beschreibung im Onboarding-Guide. Deshalb findet der Retriever sie
bei einer direkten Frage nicht zuverlässig.

## Vorschlag: diese Q&A in die FAQ-Sektion "Arbeitszeit und Flexibilität" einfügen

(direkt unter die Homeoffice-Frage, gleicher Stil wie deine bestehenden Q&As)

```
Frage: Wie sind die Arbeitszeiten bei BergTech?

Antwort: Die Kernarbeitszeit ist von 09:00 bis 15:00 Uhr. Innerhalb dieser
Zeit sollen alle Mitarbeiter anwesend bzw. erreichbar sein. Die maximale
tägliche Arbeitszeit beträgt 10 Stunden. Es gelten die gesetzlichen
Pausenregelungen. Die Arbeitszeiterfassung erfolgt über das Terminal im
Eingangsbereich von Gebäude A.
```

## Warum das funktioniert

- Frage ist im natürlichen Nutzer-Wortlaut ("Wie sind die Arbeitszeiten")
  → liegt im Embedding-Raum nah an Demo-Fragen wie "wie lange muss man arbeiten"
- Antwort enthält die konkreten Fakten als eigenständigen, suchbaren Chunk
- Quellen-zitierbar als [HR_FAQ_BergTech], passt zum Halluzinationsschutz

Alle Fakten stammen aus euren bestehenden Docs (Onboarding-Guide
Arbeitszeitordnung + Zeiterfassungs-Terminal), es wird nichts erfunden.

## Nach dem Einfügen

Doc nach `~/.n8n-files/company-docs/anastasiia/` kopieren, dann Re-Ingest
laut `reingest-koordination.md`.
