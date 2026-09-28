-- Rhythm Dictation Trainer: class leaderboard setup for Supabase.
-- Paste this whole file into Supabase → SQL Editor and click Run.
--
-- BEFORE YOU RUN IT: change 2468 on the line marked "YOUR TEACHER PIN" below.
-- It's safe to run this file again later (for example, to change your PIN).

-- 1. The scores table -------------------------------------------------------
create table if not exists public.rhythm_scores (
  id         uuid primary key default gen_random_uuid(),
  name       text not null check (char_length(name) between 2 and 24 and name ~ '^[A-Za-zÀ-ÿ'' .-]+$'),
  correct    int  not null check (correct >= 0),
  total      int  not null check (total between 1 and 200 and correct <= total),
  score      numeric generated always as (round(correct::numeric * 100 / total, 1)) stored,
  time_sec   int  not null check (time_sec between 1 and 36000),
  created_at timestamptz not null default now()
);

-- Visitors can read the board and add a score, but can't change or delete anything.
alter table public.rhythm_scores enable row level security;
drop policy if exists "anyone can read scores" on public.rhythm_scores;
drop policy if exists "anyone can add a score" on public.rhythm_scores;
create policy "anyone can read scores" on public.rhythm_scores for select to anon, authenticated using (true);
create policy "anyone can add a score" on public.rhythm_scores for insert to anon, authenticated with check (true);
grant select, insert on public.rhythm_scores to anon, authenticated;

-- 2. Teacher PIN (stored where visitors can't read it) ----------------------
create schema if not exists private;
revoke all on schema private from public, anon, authenticated;
create table if not exists private.teacher_pin (only_row boolean primary key default true check (only_row), pin text not null);
insert into private.teacher_pin (only_row, pin)
values (true, '2468')                                   -- ← YOUR TEACHER PIN
on conflict (only_row) do update set pin = excluded.pin;

create or replace function private.check_pin(pin text) returns void
language plpgsql security definer set search_path = '' as $$
begin
  if pin is distinct from (select t.pin from private.teacher_pin t) then
    raise exception 'Wrong PIN.';
  end if;
end $$;

-- 3. Teacher tools (the app's Teacher button calls these) --------------------
create or replace function public.teacher_list(pin text) returns setof public.rhythm_scores
language plpgsql security definer set search_path = '' as $$
begin
  perform private.check_pin(pin);
  return query select * from public.rhythm_scores s order by s.score desc, s.time_sec asc, s.created_at asc;
end $$;

create or replace function public.teacher_delete(pin text, score_id uuid) returns void
language plpgsql security definer set search_path = '' as $$
begin
  perform private.check_pin(pin);
  delete from public.rhythm_scores where id = score_id;
end $$;

create or replace function public.teacher_reset(pin text) returns void
language plpgsql security definer set search_path = '' as $$
begin
  perform private.check_pin(pin);
  delete from public.rhythm_scores where true;
end $$;

revoke all on function public.teacher_list(text), public.teacher_delete(text, uuid), public.teacher_reset(text) from public;
grant execute on function public.teacher_list(text), public.teacher_delete(text, uuid), public.teacher_reset(text) to anon, authenticated;
