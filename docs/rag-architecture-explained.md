# RAG-Architektur erklaert — Wie unser HR-Chatbot funktioniert

**Projekt:** RAG Chatbot fuer BergTech Maschinenbau GmbH
**Workflow-Version:** v4.7
**Autorin:** Juliana Paar (Supabase Lead)
**Stand:** 17.05.2026

---

## 1. Was ist RAG?

RAG steht fuer **Retrieval-Augmented Generation**. Es ist eine Architektur, die zwei Komponenten kombiniert:

1. **Retrieval** — relevante Informationen werden aus einer Wissensbasis gesucht
2. **Generation** — ein Large Language Model (LLM) generiert daraus eine natuerlichsprachige Antwort

Klassische Chatbots ohne RAG halluzinieren oft, weil sie alles aus ihrem Trainingswissen ableiten muessen. Mit RAG bekommt das LLM bei jeder Anfrage **genau die relevanten Dokumentenstellen** als Kontext mitgeliefert, antwortet faktenbasiert und kann Quellen zitieren.

---

## 2. Was Supabase in unserem System macht

### Was Supabase NICHT ist

Supabase speichert **nicht** unsere HR-Dokumente als Dateien. Die Markdown-Dateien liegen weiterhin lokal auf dem Rechner unter `company-docs/`.

### Was Supabase IST

Supabase ist unsere **Vektor-Datenbank**. Sie speichert die "semantische Bedeutung" der Texte als 1536-dimensionale Zahlen-Arrays (Embeddings). Dadurch koennen wir nicht nach Woertern, sondern nach **Bedeutung** suchen.

**Analogie:** Stell dir Google vor — du suchst nach "Auto" und bekommst auch Ergebnisse fuer "PKW", "Fahrzeug" oder "Wagen". Genau das macht Vektor-Suche, nur viel genauer und auf Satz-Ebene.

### Technischer Aufbau

Wir nutzen die Postgres-Extension `pgvector` in Supabase. Das Schema:

- **Tabelle `documents`** mit Spalten:
  - `id` (Primary Key)
  - `content` (der Original-Text-Chunk)
  - `metadata` (Filename, Quelle, etc. als JSONB)
  - `embedding` (Vektor mit 1536 Dimensionen)
- **RPC-Function `match_documents`** fuer Aehnlichkeitssuche
- **HNSW-Index** auf der `embedding`-Spalte fuer schnelle Suche (O(log n) statt O(n))

---

## 3. Der gesamte Workflow — Phase 1: Ingestion

Die Ingestion-Phase laeuft **einmalig** beim Aufsetzen, oder erneut wenn sich Dokumente aendern.

**Schritt fuer Schritt:**

1. **Manual Trigger** — der Workflow wird in n8n per Knopfdruck gestartet
2. **Read/Write Files from Disk** — n8n liest alle `.md`-Dateien aus dem lokalen Ordner `company-docs/`
3. **Default Data Loader** — bereitet die Dateien fuer das Chunking vor, extrahiert Metadata
4. **Recursive Character Text Splitter** — zerteilt jedes Dokument in kleine, ueberlappende Chunks (500 Zeichen, 50 Zeichen Overlap). Begruendung siehe Abschnitt 6.
5. **Embeddings OpenAI** — jeder Chunk wird durch das Modell `text-embedding-3-small` in einen 1536-dimensionalen Vektor verwandelt
6. **Supabase Vector Store (Insert)** — Original-Text, Metadata und Vektor werden in die `documents`-Tabelle geschrieben

**Ergebnis nach Ingestion:** Die `documents`-Tabelle ist mit allen HR-Chunks und ihren Embeddings gefuellt. Bereit fuer Queries.

---

## 4. Der gesamte Workflow — Phase 2: Query

Die Query-Phase laeuft bei **jeder einzelnen Nutzerfrage**.

**Schritt fuer Schritt:**

1. **When chat message received** (Chat Trigger) — Mitarbeiter stellt eine Frage in der n8n Chat-Sidebar, z.B. "Wie viele Tage vorher muss ich Urlaub beantragen?"
2. **AI Agent** — der zentrale Orchestrator. Er bekommt die Frage und entscheidet, ob er das Vector-Store-Tool aufruft.
3. **Embeddings OpenAI** — die Frage wird mit dem gleichen Modell (`text-embedding-3-small`) in einen Vektor verwandelt. **Wichtig:** Das Embedding-Modell muss bei Write und Read identisch sein, sonst funktioniert die Suche nicht!
4. **Supabase Vector Store (retrieve-as-tool)** — n8n ruft in Supabase die Funktion `match_documents(...)` auf. Supabase macht eine Cosine-Similarity-Suche und liefert die **5 aehnlichsten Chunks** zurueck.
5. **Chat Model Anthropic (Claude 3.5 Haiku)** — bekommt vom AI Agent die Frage und die 5 retrieved Chunks als Kontext. Generiert die Antwort gemaess System Prompt.
6. **Antwort** erscheint in der Chat-Sidebar mit Quellenangabe.

---

## 5. Erklaerung aller verwendeten Tools

### n8n
Visuelles Workflow-Automation-Tool. Wir nutzen es lokal (npx) auf `localhost:5678`. Bietet drag-and-drop-Bausteine fuer LLM-Workflows. Vorteil: keine eigenes Backend zu schreiben, JSON-Export fuer Versionskontrolle.

### Supabase
Backend-as-a-Service auf Basis von Postgres. Wir nutzen ausschliesslich die Vector-Datenbank-Funktionalitaet via `pgvector`-Extension. Free Tier reicht fuer unser Projekt voellig aus.

### pgvector
Postgres-Extension, die einen `vector`-Datentyp und Aehnlichkeits-Operatoren wie `<=>` (Cosine Distance) bereitstellt. Industriestandard fuer Vektor-Suche in relationalen Datenbanken.

### HNSW Index
**H**ierarchical **N**avigable **S**mall **W**orld — ein Approximate-Nearest-Neighbor-Algorithmus. Reduziert die Vektor-Suche von O(n) auf etwa O(log n). State-of-the-Art-Index fuer Embedding-Datenbanken.

### OpenAI text-embedding-3-small
Embedding-Modell von OpenAI (2024). Erzeugt 1536-dimensionale Vektoren. Wir nutzen es, weil:
- 5x guenstiger als das aeltere `ada-002` ($0.02 vs $0.10 pro 1M Tokens)
- Bessere MTEB-Benchmark-Scores
- Wir setzen es **explizit** im JSON, damit n8n nicht den Default benutzt

### Anthropic Claude 3.5 Haiku
LLM fuer die Antwort-Generierung. Wir nutzen es, weil:
- Sehr guenstig ($0.25/1M Input, $1.25/1M Output)
- Schnell genug fuer Live-Demo (< 10 Sekunden Latenz)
- Reasoning-Tiefe reicht fuer HR-FAQ
- Temperatur 0.3 — wenig Kreativitaet, mehr Faktenfokus

### Default Data Loader (n8n LangChain)
Sub-Node, der Dateien einliest und fuer Embeddings vorbereitet. Setzt automatisch Metadata wie Dateinamen.

### Recursive Character Text Splitter
Sub-Node, der lange Texte rekursiv in Chunks zerteilt. Arbeitet **Zeichen-basiert** (nicht Token-basiert!). Wir nutzen 500 Zeichen pro Chunk mit 50 Zeichen Overlap.

### AI Agent (n8n LangChain)
Das zentrale Node im Query-Pfad. Er kapselt:
- LLM-Call (Anthropic Sub-Node)
- Tool-Auswahl (Vector Store Sub-Node)
- Antwort-Formatierung
Bietet Saile-konforme "3 sichtbare Nodes"-Architektur, weil die internen 5 Sub-Nodes nicht auf dem Canvas erscheinen.

### Chat Trigger (LangChain, nicht Standard-Webhook!)
Spezieller n8n-Node, der die Chat-Sidebar in n8n aktiviert. Wichtig: NICHT der Standard-`n8n-nodes-base.webhook` — der gibt nur einen HTTP-Endpoint ohne Chat-UI. Dieser Bug wurde in Workflow v4.6 entdeckt und in v4.7 gefixt.

---

## 6. Warum diese Architekturentscheidungen?

### Warum RAG und nicht einfach alle Docs in den Prompt?

| Problem | RAG-Loesung |
|---|---|
| Context Window — Claude Haiku hat 200k Tokens. 25 Docs x 5000 Woerter wuerden eng werden | Nur 5 relevante Chunks pro Query ~ 2500 Tokens |
| Kosten — jede Anfrage zahlt pro Token | 100x weniger Tokens = 100x guenstiger |
| Geschwindigkeit — viel Text = langsame Antwort | Kleine Chunks = schnelle Antwort, NFR (< 10s) eingehalten |
| Genauigkeit — Claude verliert sich in zu viel Text ("lost in the middle") | Nur das Relevante = praezisere Antworten |
| Skalierbarkeit — bei 1000 Docs unmoeglich | Vector-Search skaliert auf Millionen Docs |

### Warum Chunking mit 500 Zeichen?

HR-Dokumente bestehen aus kurzen, dichten Abschnitten (Policy-Regeln, FAQ-Antworten, Checklisten-Items). 500 Zeichen entspricht etwa einem Abschnitt. So landet jede Policy-Regel als eigener Chunk und das Retrieval findet praezise Matches.

**Overlap 50** verhindert, dass Informationen an Chunk-Grenzen abgeschnitten werden.

Groessere Chunks (1000+) wuerden mehrere Themen mischen und das Retrieval unscharf machen.

### Warum nur 3 sichtbare Nodes pro Workflow-Section?

Saile-Vorgabe: "n8n einfach halten." Der AI Agent Node ist intern maechtiger als er aussieht — er enthaelt 5 Sub-Nodes (LLM, Tool, Embeddings), aber auf dem Canvas sieht man nur 3. Weniger sichtbare Komplexitaet bedeutet weniger Failure-Points in der Live-Demo.

### Warum Cosine Similarity?

OpenAI-Embeddings sind so trainiert, dass die Richtung des Vektors die Bedeutung kodiert, nicht die Laenge. Cosine Similarity vergleicht nur die Richtung (Winkel zwischen Vektoren), ist also genau die richtige Metrik fuer Embeddings.

---

## 7. Sicherheit & DSGVO

### Was wir umgesetzt haben

- **Row Level Security (RLS)** auf der `documents`-Tabelle — ohne RLS waere die Tabelle ueber den public `anon`-Key lesbar
- **Service-Role-Only-Policy** — nur n8n (mit dem `service_role`-Key) kann lesen und schreiben
- **EU-Region (Frankfurt)** — Daten verlassen Europa nicht
- **Keine PII (Personal Identifiable Information)** in den HR-Dokumenten — die Docs enthalten Policies, keine Mitarbeiterdaten
- **service_role-Key wird niemals committet** — nur lokal in n8n-Credentials und ggf. `.env`-Files

### EU AI Act Compliance

Unser System faellt unter **Limited Risk** (Chatbot mit menschlicher Interaktion). Pflichten nach Art. 50:

- Transparenz: Nutzer wissen, dass sie mit einer KI sprechen
- Quellenangabe: Antworten enthalten `[Dokumentname]`
- Fallback: "Diese Information liegt mir nicht vor. Bitte wende dich an hr@bergtech.de."

---

## 8. Zusammenfassung in einem Satz

> Supabase ist eine "Google fuer unsere HR-Dokumente" — anstatt nach Woertern zu suchen, sucht es nach Bedeutung. Die Original-Dateien bleiben auf der Festplatte, Supabase haelt nur die semantischen Koordinaten als Vektoren. Dadurch findet das System bei jeder Frage die relevantesten Stellen, gibt sie an Claude weiter, und Claude generiert daraus eine faktenbasierte Antwort mit Quellenangabe.

---

**Quellen:**
- Workflow: `workflows/rag-workflows-v4.7.json`
- Schema: `supabase/schema.sql`
- PRD: `PRD.md`
- Reflection: `docs/implementation-reflection.md`
- Q&A-Brief: `docs/qa-brief-18-05.md`
