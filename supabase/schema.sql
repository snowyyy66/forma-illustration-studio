-- Run once in Supabase SQL Editor.
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text not null check (username ~ '^[A-Za-z0-9_]{3,24}$'),
  created_at timestamptz not null default now()
);
create unique index if not exists profiles_username_lower_unique on public.profiles (lower(username));
alter table public.profiles enable row level security;
create policy "Profiles are readable by their owner" on public.profiles for select using (auth.uid() = id);
create policy "Owners may update their profile" on public.profiles for update using (auth.uid() = id) with check (auth.uid() = id);

create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles (id, username)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'username', split_part(new.email, '@', 1)));
  return new;
end;
$$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
for each row execute procedure public.handle_new_user();

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade default auth.uid(),
  name text not null check (char_length(name) between 1 and 60),
  data jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.projects enable row level security;
create policy "Users can read their projects" on public.projects for select using (auth.uid() = user_id);
create policy "Users can create their projects" on public.projects for insert with check (auth.uid() = user_id);
create policy "Users can update their projects" on public.projects for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Users can delete their projects" on public.projects for delete using (auth.uid() = user_id);
create index if not exists projects_user_updated_idx on public.projects (user_id, updated_at desc);

-- Allow signup UI to provide an immediate friendly response for taken nicknames.
create or replace function public.is_username_available(p_username text)
returns boolean language sql security definer set search_path = '' as $$
  select not exists (select 1 from public.profiles where lower(username) = lower(p_username));
$$;
grant execute on function public.is_username_available(text) to anon, authenticated;
