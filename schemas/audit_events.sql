-- Audit Events Tabelle (v5-production)
-- Append-only Log für DSGVO + Forensics + Multi-Provider-Benchmark
-- Referenz: EIP (Hohpe/Woolf, 2003), SRE Book (Google, 2016)

create table if not exists public.audit_events (
  id uuid primary key default gen_random_uuid(),
  ts timestamptz not null default now(),
  source text not null,                  -- z.B. "ingestion-v5", "query-v5"
  action text not null,                  -- z.B. "doc_ingested", "query_received", "embedding_failed"
  entity_type text,                       -- "document", "query", "chunk"
  entity_id text,                         -- doc_path, query_id, chunk_id
  user_id text,                           -- Chat-User aus Trigger
  request_id text,                        -- Korrelations-ID für ein Run
  payload jsonb,                          -- Original-Input (sanitized)
  result jsonb,                           -- Output, Status, Counts
  latency_ms int,
  status text not null,                   -- "ok", "error", "skipped", "dedup"
  error text,                             -- Stack-Trace oder Message
  metadata jsonb                          -- frei (chunk_count, tokens_used, model)
);

-- Indexe für Query-Performance
create index if not exists idx_audit_ts on public.audit_events (ts desc);
create index if not exists idx_audit_action on public.audit_events (action);
create index if not exists idx_audit_request on public.audit_events (request_id);
create index if not exists idx_audit_status on public.audit_events (status);

-- RLS: nur Service-Role darf schreiben/lesen (kein anonymer Zugriff)
alter table public.audit_events enable row level security;

create policy "service-role full access on audit_events"
  on public.audit_events
  for all
  to service_role
  using (true)
  with check (true);

-- Append-only Enforcement: kein UPDATE/DELETE erlaubt (außer durch Admin-Migration)
create or replace function block_audit_mutation()
returns trigger as $$
begin
  raise exception 'audit_events ist append-only — UPDATE/DELETE nicht erlaubt';
end;
$$ language plpgsql;

create trigger no_audit_update before update on public.audit_events
  for each row execute function block_audit_mutation();

create trigger no_audit_delete before delete on public.audit_events
  for each row execute function block_audit_mutation();

comment on table public.audit_events is
  'Append-only Audit-Log für RAG-Chatbot v5. DSGVO Art. 30 (Verzeichnis Verarbeitungstätigkeiten). Immutable.';
