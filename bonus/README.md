# Bonus — Production-Variante (v5)

**Separater Zusatzbeleg. Nicht Teil der Pflichtabgabe.**

Die Pflichtabgabe ist der von Prof. Dozent abgenommene Workflow **v4.7** im
Hauptprojekt (`../workflows/v4.7/`). Dieser Ordner zeigt freiwillig, was beim
Übergang vom akademischen Prototyp in einen echten Produktionsbetrieb zusätzlich
nötig wäre. v4.7 und v5 werden bewusst nicht vermischt.

## Inhalt

```
bonus/
├── v4.7-vs-v5-comparison.md     # Feature-Vergleich Prototyp vs Production
├── schemas/                     # SQL für die Production-Tabellen
│   ├── audit_events.sql
│   ├── failed_jobs.sql          # Dead-Letter Queue
│   └── circuit_breaker_state.sql
└── v5-production/
    ├── ARCHITECTURE.md          # Architektur + Pattern-Map
    ├── README.md                # Setup, Test, Limitationen
    ├── rag-ingestion-v5.json
    └── rag-query-v5.json
```

## Worum es geht

v4.7 erfüllt die Kursanforderung sauber: Chunking, Embedding, Vector Search,
LLM-Antwort mit Quellenbelegen. v5 ergänzt die sieben Patterns, die ein
Production-System zusätzlich braucht: HMAC-Signatur, Schema-Validation,
Dead-Letter Queue, Structured Logging, Rate-Limit + Backoff, Circuit Breaker,
Audit Logs. Dazu Prompt-Injection-Filter und Idempotency.

Details, akademische Quellen und ehrliche Limitationen stehen in
`v5-production/README.md`.

## Status

v5 ist als Demonstration gebaut, nicht produktiv deployt. Die genannten
Limitationen (z.B. Circuit-Breaker-State in Supabase, single-shared HMAC-Secret,
regex-basierter Injection-Filter) sind in `v5-production/README.md` dokumentiert.
