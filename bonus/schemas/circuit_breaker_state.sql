-- Circuit Breaker State (v5-production)
-- Speichert pro Downstream-Service den Zustand: closed | open | half-open
-- Workflows lesen "is_breaker_open(service)" vor jedem API-Call

create table if not exists public.circuit_breaker_state (
  service text primary key,              -- "openai_embeddings", "anthropic_chat", "supabase"
  state text not null default 'closed',  -- "closed" | "open" | "half_open"
  fail_count int not null default 0,
  threshold int not null default 3,
  cooldown_seconds int not null default 300,
  opened_at timestamptz,
  last_failure_at timestamptz,
  last_success_at timestamptz,
  updated_at timestamptz not null default now()
);

-- Seed
insert into public.circuit_breaker_state (service) values
  ('openai_embeddings'),
  ('anthropic_chat'),
  ('supabase_vector')
on conflict (service) do nothing;

alter table public.circuit_breaker_state enable row level security;

create policy "service-role full access on circuit_breaker_state"
  on public.circuit_breaker_state
  for all
  to service_role
  using (true)
  with check (true);

-- Helper-Functions

create or replace function public.cb_is_open(p_service text)
returns boolean as $$
declare
  v_state text;
  v_opened_at timestamptz;
  v_cooldown int;
begin
  select state, opened_at, cooldown_seconds
  into v_state, v_opened_at, v_cooldown
  from public.circuit_breaker_state where service = p_service;

  if v_state is null then return false; end if;
  if v_state = 'closed' then return false; end if;

  -- open + Cooldown abgelaufen → auf half_open setzen
  if v_state = 'open' and v_opened_at + (v_cooldown || ' seconds')::interval < now() then
    update public.circuit_breaker_state
      set state = 'half_open', updated_at = now()
      where service = p_service;
    return false; -- erlaubt einen Test-Call
  end if;

  return v_state = 'open';
end;
$$ language plpgsql;

create or replace function public.cb_record_success(p_service text)
returns void as $$
begin
  update public.circuit_breaker_state
    set state = 'closed',
        fail_count = 0,
        last_success_at = now(),
        opened_at = null,
        updated_at = now()
  where service = p_service;
end;
$$ language plpgsql;

create or replace function public.cb_record_failure(p_service text)
returns void as $$
declare
  v_fail_count int;
  v_threshold int;
begin
  update public.circuit_breaker_state
    set fail_count = fail_count + 1,
        last_failure_at = now(),
        updated_at = now()
  where service = p_service
  returning fail_count, threshold into v_fail_count, v_threshold;

  if v_fail_count >= v_threshold then
    update public.circuit_breaker_state
      set state = 'open',
          opened_at = now()
    where service = p_service and state != 'open';
  end if;
end;
$$ language plpgsql;

comment on table public.circuit_breaker_state is
  'Circuit Breaker Pattern (Nygard 2007, Fowler 2014). Verhindert Cascade-Failures bei toten Downstream-Services.';
