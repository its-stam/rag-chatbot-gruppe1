# Supabase Setup — RAG Chatbot Gruppe 1

**Owner:** Teammitglied B (Supabase Lead)
**Stand:** 17.05.2026

Dieser Ordner enthaelt das Datenbank-Schema fuer den RAG-Chatbot. Supabase dient als Vektor-Datenbank (pgvector) und speichert die Embeddings der HR-Dokumente fuer das Retrieval im Query-Workflow.

---

## Projekt-Konfiguration

| Setting | Wert |
|---|---|
| Provider | Supabase (Free Tier) |
| Region | Central EU (Frankfurt) — DSGVO-konform |
| Datenbank | Postgres mit `pgvector`-Extension |
| Verbindung von n8n | Supabase API Credential (Host + `service_role` Secret) |

---

## Schema

Definiert in `schema.sql`. Komponenten:

| Komponente | Zweck |
|---|---|
| `vector` Extension | Aktiviert den `vector`-Datentyp in Postgres |
| Tabelle `documents` | Speichert Chunks: `id`, `content`, `metadata`, `embedding vector(1536)` |
| Function `match_documents(query_embedding, match_count, filter)` | RPC fuer Cosine-Similarity-Suche, wird vom n8n Supabase Vector Store Node aufgerufen |
| HNSW Index | Approximate Nearest Neighbor Search, O(log n) statt O(n) |
| Row Level Security + Policy | Nur der `service_role`-Key hat Zugriff; `anon`-Zugriff blockiert |

**Embedding-Dimension `1536`** entspricht dem in Workflow v4.7 genutzten Modell `text-embedding-3-small` (OpenAI).

---

## Setup-Schritte (zum Reproduzieren)

1. **Projekt anlegen** auf https://supabase.com (Free Tier, Region Frankfurt, Database-Passwort sicher speichern).
2. **Schema deployen:** Im Supabase Dashboard unter **SQL Editor** → New Query → Inhalt von `schema.sql` einfuegen → **Run**.
3. **Credentials abrufen:** Project Settings → API
   - `Project URL` (z.B. `https://xxxxx.supabase.co`)
   - `service_role` Key (Reveal anklicken)
4. **n8n-Credential anlegen:** Im n8n unter Credentials → "Supabase API"
   - Feld `Host`: Project URL
   - Feld `Service Role Secret`: service_role Key
   - HTTP-Request-Option **deaktiviert** lassen
5. **Im Workflow v4.7 verknuepfen:** Beide Supabase-Nodes (`Supabase Vector Store1` im Ingestion-Block, `Supabase Vector Store` im Query-Block) auf das neue Credential setzen.

---

## n8n-Workflow-Anpassungen (gegenueber v4.7-Export)

Diese Felder muessen pro lokaler n8n-Instanz nachgepflegt werden, weil der JSON-Export sie offen laesst:

### Node "Supabase Vector Store" (Query-Block, `retrieve-as-tool`)

| Feld | Wert |
|---|---|
| Name | `hr_knowledge_base` |
| Description | `Durchsucht die HR-Dokumente der BergTech Maschinenbau GmbH. Nutze dieses Tool fuer alle Fragen zu Onboarding, Urlaub, Krankmeldung, Pflichttrainings, Compliance, HR-FAQ und Offboarding. Liefert relevante Textpassagen mit Quellenangabe.` |

**Warum noetig:** Der `retrieve-as-tool`-Mode macht aus dem Vector Store ein LangChain-Tool fuer den AI Agent. Ohne `Name` und `Description` zeigt der Node ein rotes Warnsymbol und der AI Agent kann das Tool nicht korrekt aufrufen. Die Description ist auch fachlich relevant — der AI Agent (Claude) entscheidet anhand des Beschreibungstextes, ob er das Tool bei einer Nutzerfrage ueberhaupt benutzt.

### Credentials

Pro Node:

| Node | Credential-Typ |
|---|---|
| Embeddings OpenAI (Ingestion + Query) | OpenAI API |
| Chat Model Anthropic | Anthropic API |
| Supabase Vector Store (beide) | Supabase API |

---

## Sicherheit

- **service_role Key niemals committen.** Er gibt vollen DB-Zugriff. Nur in n8n-Credentials oder lokaler `.env`.
- **RLS ist aktiv** auf der `documents`-Tabelle. Ohne service_role-Key gibt es keinen Zugriff.
- **Daten bleiben in der EU** (Region Frankfurt) — wichtig fuer DSGVO und EU AI Act Compliance.
- **Keine PII** in den HR-Dokumenten (Policy-Texte, keine Mitarbeiterdaten).

---

## Verbindung zum Gesamtsystem

Supabase wird ausschliesslich vom n8n-Workflow `workflows/rag-workflows-v4.7.json` angesprochen:

- **Ingestion-Workflow** schreibt Chunks + Embeddings in `documents`
- **Query-Workflow** ruft `match_documents` auf, um relevante Chunks fuer eine Nutzerfrage zu retrieven

Eine ausfuehrliche Architekturerklaerung steht in `docs/rag-architecture-explained.md`.
