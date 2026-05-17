-- ============================================================
-- RAG Chatbot Gruppe 1 — Supabase Schema
-- Konform zu workflows/rag-workflows-v4.7.json
-- Embedding-Modell: text-embedding-3-small (1536 dim)
-- Vector DB: Supabase pgvector
-- Owner: Juliana (Supabase Lead)
-- ============================================================

-- 1. pgvector Extension (Pflicht fuer vector-Typ)
create extension if not exists vector;

-- 2. documents-Tabelle (Schema laut n8n Supabase Vector Store Node)
create table documents (
  id        bigserial primary key,
  content   text,          -- Chunk-Text (500 Zeichen, 50 Overlap)
  metadata  jsonb,          -- Filename + Source-Info vom Default Data Loader
  embedding vector(1536)    -- text-embedding-3-small Dimension
);

-- 3. RPC-Function fuer Similarity Search
--    Wird vom n8n Supabase Vector Store Node (retrieve-as-tool) aufgerufen
--    Signatur muss exakt so heissen, sonst findet n8n sie nicht
create or replace function match_documents (
  query_embedding vector(1536),
  match_count int default null,
  filter jsonb default '{}'
) returns table (
  id bigint,
  content text,
  metadata jsonb,
  similarity float
)
language plpgsql
as $$
begin
  return query
  select
    documents.id,
    documents.content,
    documents.metadata,
    1 - (documents.embedding <=> query_embedding) as similarity
  from documents
  where documents.metadata @> filter
  order by documents.embedding <=> query_embedding
  limit match_count;
end;
$$;

-- 4. HNSW Index fuer schnelle Vektor-Suche
--    Hierarchical Navigable Small World — state-of-the-art fuer ANN-Search
--    Q&A-Talking-Point: O(log n) statt O(n) bei skalierender Doku-Anzahl
create index on documents using hnsw (embedding vector_cosine_ops);

-- 5. Row Level Security (Pflicht fuer public schema!)
--    Sicherheitsrelevant: ohne RLS waere die Tabelle ueber anon-Key lesbar
alter table documents enable row level security;

-- 6. Policy: nur service_role darf lesen/schreiben
--    n8n nutzt service_role-Key -> kein anon-Zugriff moeglich
create policy "service_role full access"
  on documents
  for all
  to service_role
  using (true)
  with check (true);
