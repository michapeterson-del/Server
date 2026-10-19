#!/bin/sh
# Läuft nur beim allerersten Start (leeres Datenvolume).
# Entspricht supabase/schema.sql + allen Migrationen aus dem To-do-Repo.
set -e
psql -v ON_ERROR_STOP=1 -U postgres -d postgres <<SQL
create role anon nologin;
create role authenticator login noinherit password '${AUTHENTICATOR_PASSWORD}';
grant anon to authenticator;

create extension if not exists pgcrypto;

create table public.tasks (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text not null default '',
  category text not null default 'today' check (category in ('today', 'process', 'private')),
  status text not null default 'open' check (status in ('open', 'done')),
  priority smallint not null default 2 check (priority in (1, 2, 3)),
  recurrence text not null default 'none' check (recurrence in ('none', 'daily', 'weekly', 'monthly')),
  recurrence_day smallint check (recurrence_day is null or (recurrence_day between 1 and 31)),
  source text not null default 'manual' check (source in ('manual', 'screenshot')),
  steps jsonb not null default '[]'::jsonb,
  last_steps text not null default '',
  next_steps text not null default '',
  event_datetime timestamptz,
  event_title text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index tasks_category_idx on public.tasks (category);
create index tasks_created_at_idx on public.tasks (created_at);

create function public.set_updated_at() returns trigger as \$\$
begin
  new.updated_at = now();
  return new;
end;
\$\$ language plpgsql;

create trigger tasks_set_updated_at
  before update on public.tasks
  for each row execute function public.set_updated_at();

grant usage on schema public to anon;
grant select, insert, update, delete on public.tasks to anon;
SQL
