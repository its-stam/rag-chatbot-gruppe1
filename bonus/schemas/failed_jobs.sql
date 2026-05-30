-- Failed Jobs Tabelle = Dead-Letter Queue (v5-production)
-- Failed Ingestion/Query landet hier statt verloren zu gehen
-- Retry-Worker verarbeitet sie später ab

create table if not exists public.failed_jobs (
  id uuid primary key default gen_random_uuid(),
  ts timestamptz not null default now(),
  source text not null,                  -- "ingestion-v5", "query-v5"
  job_type text not null,                -- "embed_document", "process_query"
  payload jsonb not null,                -- Original-Input für Retry
  error text not null,                   -- Error-Message
  error_class text,                       -- "RateLimitError", "TimeoutError", "ValidationError"
  retry_count int not null default 0,
  max_retries int not null default 5,
  last_retry_at timestamptz,
  resolved_at timestamptz,                -- gefüllt wenn erfolgreich retry'd
  resolved_by text,                       -- "auto-retry-worker", "manual"
  request_id text                         -- Korrelations-ID
);

create index if not exists idx_failed_unresolved
  on public.failed_jobs (ts desc)
  where resolved_at is null;

create index if not exists idx_failed_retry_due
  on public.failed_jobs (last_retry_at)
  where resolved_at is null and retry_count < max_retries;

alter table public.failed_jobs enable row level security;

create policy "service-role full access on failed_jobs"
  on public.failed_jobs
  for all
  to service_role
  using (true)
  with check (true);

comment on table public.failed_jobs is
  'Dead-Letter Queue für RAG v5. Failed Jobs werden hier persistiert statt verloren zu gehen.';
