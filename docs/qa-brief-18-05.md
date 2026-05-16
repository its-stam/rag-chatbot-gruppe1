# Q&A Brief — Saile-Session 18.05.2026, 8:00–9:30

**Stand:** v4.7 gepusht, GitHub aufgeräumt, PDFs ready
**Modus:** Freiwillige Sprechstunde vor 31.05-Submission
**Ziel:** Saile-Fragen vorab klären, Risiken für Endpräsi minimieren

---

## Eröffnungsstatement (30 Sek, falls Saile fragt "Wo steht ihr?")

> "Workflow v4.7 ist auf GitHub, lauffähig importierbar. Ingestion + Query in einer Canvas, drei Hauptnodes pro Section, Saile-konform. 5 HR-Docs als PDF und MD. Aktuell blockiert: Supabase-Credentials (Juliana) und EU-AI-Act-Analyse (Anastasiia). Ich frage heute: 1) ob unser Workflow strukturell so passt, 2) wie viel EU-AI-Act-Tiefe Sie erwarten, 3) ob die Live-Demo lokal oder über Cloud laufen soll."

---

## 9 wahrscheinliche Saile-Fragen (aus implementation-reflection.md)

### 1. "Warum so viele Workflow-Iterationen?"
KI-generiertes JSON (v1–v3) war syntaktisch korrekt, aber falsche Node-Types + fehlende Sub-Node-Connections. Erst v4 manuell in UI gebaut → funktionsfähig. v4.7 = jetzige Version, Chat Trigger Fix (langchain statt webhook). **Take-away:** n8n-JSON ist Output, nicht Input.

### 2. "Warum GitHub für ein Uni-Projekt?"
Team-Transparenz, Versionierung, professioneller Workflow, Contribution Reports durch Commit-History belegbar. Industriestandard.

### 3. "Warum Claude Haiku und nicht GPT-4/Gemini?"
Haiku = günstig (0.25/1M In, 1.25/1M Out) + schnell. Reasoning-Tiefe reicht für HR-FAQ. Gemini hat keinen n8n-native Node. OpenAI nutzen wir bereits für Embeddings → zwei Provider = Ausfallsicherheit.

### 4. "Warum text-embedding-3-small statt ada-002?"
Neuer (2024), 5× günstiger ($0.02 vs $0.10/1M), bessere MTEB-Scores. Explizit im JSON gesetzt — wir vertrauen Defaults nicht. Ingestion und Query müssen identisches Modell nutzen, sonst Retrieval kaputt.

### 5. "Warum RecursiveCharacterTextSplitter mit 500 Zeichen?"
HR-Docs = kurze, dichte Abschnitte (Policy, FAQ, Checkliste). 500 Zeichen ≈ ein Abschnitt → präzise Matches. Overlap 50 verhindert Cut-offs an Chunk-Grenzen.

### 6. "Warum 3 Nodes und nicht mehr?"
Ihre Vorgabe: "einfach halten". AI Agent ist intern mächtig: `ai_languageModel` + `ai_tool` + `ai_embedding` = 5 Sub-Nodes, sichtbar nur 3 auf Canvas. Best Practice: sichtbare Komplexität minimieren.

### 7. "Was passiert wenn eine Frage nicht beantwortet werden kann?"
System Prompt hat expliziten Fallback: *"Diese Information liegt mir nicht vor. Bitte wende dich an hr@bergtech.de."* Keine Halluzination, keine externen Infos. Wichtig für HR (rechtliche Relevanz) + EU-AI-Act-Transparenz.

### 8. "Wie stellt ihr identische Embeddings zwischen Write und Read sicher?"
Beide Nodes haben explizit `"model": "text-embedding-3-small"`. Kein Default, kein impliziter Fallback. War ein gefixter Bug aus v4.2 → v4.3.

### 9. "EU AI Act — welche Rolle?"
- **Provider:** Gruppe 1 (entwickelt + deployed)
- **Deployer:** BergTech (interner Einsatz)
- **Affected Persons:** BergTech-Mitarbeiter
- **GPAI Provider:** Anthropic + OpenAI
- **Risikoklasse:** Limited-Risk (Art. 50 Transparenzpflicht, menschliche Interaktion)
- **Maßnahmen:** Transparenzhinweis, "Ich weiß nicht"-Fallback, Quellenangabe, keine PII-Speicherung

---

## 3 neue v4.7-spezifische Fragen (erwartbar)

### 10. "Warum Chat Trigger getauscht zwischen v4.6 und v4.7?"
v4.6 hatte versehentlich `n8n-nodes-base.webhook` (Standard-POST-Endpoint) statt `@n8n/n8n-nodes-langchain.chatTrigger`. Damit war die n8n-Chat-Sidebar nicht aktivierbar — kein interaktives Chat-Fenster. v4.7: korrekter LangChain Chat Trigger, `public=true`, Respond-to-Webhook entfernt (AI Agent als letztes Node liefert Antwort direkt zurück an Chat).

### 11. "Wie demonstriert ihr live am 01.06.?"
**Plan A:** n8n lokal (Docker, localhost:5678) + Supabase Free Tier + Anthropic Live-Call → Chat-Sidebar als Demo-UI.
**Plan B (Fallback):** Pre-recorded Screen Capture falls Supabase oder Credentials nicht stabil.
**Risk:** Supabase-Setup blockiert durch Juliana (0 Commits). Wenn bis 22.05 nicht da → Plan B verbindlich.

### 12. "Was ist die größte Schwäche eurer Architektur?"
**Antwort ehrlich:** Single-Point-of-Failure beim AI Agent — er macht Retrieval + LLM + Response in einer Black Box. Wenn Anthropic ausfällt, fällt alles. Mitigation: zwei Provider (OpenAI Embeddings + Anthropic Chat), aber kein automatisches Failover. Für Prod würden wir das aufsplitten.

---

## Risiken laut Saile-Aufgabe (Case 1 Pflicht)

Aus PDF wörtlich: *"Incorrect HR guidance, hallucinated policy information and processing of sensitive employee data."*

| Risiko | Maßnahme | Wo |
|--------|----------|-----|
| Falsche HR-Auskunft | System Prompt: nur Fakten aus Docs, sonst Eskalation | AI Agent Node |
| Halluzinierte Policy-Infos | Quellen-Zitation Pflicht ([Dokumentname]) | System Prompt |
| Sensible Mitarbeiterdaten | Keine PII in Docs, keine User-Daten in Logs | Document Curation |
| Veraltete Policies | Re-Ingestion bei Doc-Änderung, Versionsstempel im Doc | Process |

---

## Fragen, die ich Saile stellen will

1. Reicht die Doku-Struktur (company situation → architecture → workflow → questions → risks → EU AI Act → reflection) oder erwartet er eine andere Reihenfolge?
2. Wie tief soll die EU-AI-Act-Analyse sein? Nur Rollen + Art. 50, oder auch Art. 4 (AI-Literacy)?
3. Live-Demo: lokal auf Laptop OK oder n8n Cloud erwartet?
4. Individual Grading Report — Word-Template vorgegeben oder freier Aufbau?
5. PDF-Dokumente: aktuelle Konvertierung aus Markdown akzeptabel oder native Word-Quelle erwartet?

---

## Was NICHT sagen

- Keine "v1 war kaputt" wenn er nicht explizit fragt — wir zeigen v4.7 sauber, alte Versionen sind in `_archiv/`
- Keine Team-Beschwerden über Juliana/Anastasiia — neutral als "noch in Arbeit" framen
- Keine Promises die wir nicht halten können (z.B. "Live-Demo läuft sicher")

---

## Cheat-Sheet zum Abrufen

| Kennzahl | Wert |
|----------|------|
| Workflow-Version | v4.7 |
| LLM | Claude 3.5 Haiku |
| Embeddings | text-embedding-3-small |
| Chunking | 500 Zeichen, Overlap 50 |
| Retrieval | top-5 |
| Vector DB | Supabase (pgvector) |
| Repo | github.com/its-stam/rag-chatbot-gruppe1 |
| Risikoklasse | Limited-Risk (Art. 50) |
| Submission | 31.05 Teams |
| Präsi | 01.06, 15 min + 10 min Q&A |
