alter table public.profiles add column if not exists handle text;
create unique index if not exists profiles_handle_unique on public.profiles(lower(handle)) where handle is not null;

create table if not exists public.friendships(
  user_low uuid not null references auth.users(id) on delete cascade,
  user_high uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key(user_low,user_high),
  check(user_low <> user_high)
);
alter table public.friendships enable row level security;
create policy friendships_members_read on public.friendships for select using(auth.uid() in (user_low,user_high));

create or replace function public.ensure_profile_handle(p_handle text)
returns text language plpgsql security definer set search_path=public as $$
declare safe text;
begin
  safe := lower(regexp_replace(trim(p_handle), '[^a-z0-9_]', '', 'g'));
  if length(safe) < 3 then safe := 'zigi'; end if;
  safe := left(safe, 18) || '_' || substr(replace(auth.uid()::text,'-',''),1,5);
  insert into profiles(id,display_name,handle,updated_at)
  values(auth.uid(), coalesce(nullif(trim(p_handle),''), safe), safe, now())
  on conflict(id) do update set handle=coalesce(profiles.handle, excluded.handle), updated_at=now();
  return (select handle from profiles where id=auth.uid());
end $$;

create or replace function public.find_profile_by_handle(p_handle text)
returns table(id uuid, display_name text, handle text, avatar_url text, already_friends boolean)
language sql security definer set search_path=public as $$
  select p.id,p.display_name,p.handle,p.avatar_url,
    exists(select 1 from friendships f where f.user_low=least(auth.uid(),p.id) and f.user_high=greatest(auth.uid(),p.id))
  from profiles p
  where auth.uid() is not null and p.id <> auth.uid() and lower(p.handle)=lower(trim(p_handle))
  limit 1;
$$;

create or replace function public.add_friend_by_handle(p_handle text)
returns boolean language plpgsql security definer set search_path=public as $$
declare friend_id uuid;
begin
  select id into friend_id from profiles where lower(handle)=lower(trim(p_handle)) and id<>auth.uid();
  if friend_id is null then return false; end if;
  insert into friendships(user_low,user_high) values(least(auth.uid(),friend_id),greatest(auth.uid(),friend_id)) on conflict do nothing;
  return true;
end $$;

create or replace function public.friend_weekly_leaderboard()
returns table(display_name text, handle text, avatar_url text, total_count bigint)
language sql security definer set search_path=public as $$
  with friends as (
    select case when f.user_low=auth.uid() then f.user_high else f.user_low end id
    from friendships f where auth.uid() in(f.user_low,f.user_high)
    union select auth.uid()
  )
  select p.display_name,p.handle,p.avatar_url,coalesce(sum(d.count),0)::bigint
  from friends f join profiles p on p.id=f.id
  left join daily_collections d on d.user_id=p.id and d.deleted_at is null and d.date_key>=date_trunc('week',current_date)::date
  group by p.id,p.display_name,p.handle,p.avatar_url order by total_count desc,p.handle;
$$;
revoke all on function public.ensure_profile_handle(text),public.find_profile_by_handle(text),public.add_friend_by_handle(text),public.friend_weekly_leaderboard() from public;
grant execute on function public.ensure_profile_handle(text),public.find_profile_by_handle(text),public.add_friend_by_handle(text),public.friend_weekly_leaderboard() to authenticated;
