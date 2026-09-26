create table if not exists public.campaigns(
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  title text not null,
  description text not null,
  target_count bigint not null check(target_count > 0),
  starts_at date not null,
  ends_at date,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.campaign_participants(
  campaign_id uuid not null references public.campaigns(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  joined_at timestamptz not null default now(),
  primary key(campaign_id, user_id)
);

alter table public.campaigns enable row level security;
alter table public.campaign_participants enable row level security;
create policy campaigns_authenticated_read on public.campaigns for select to authenticated using(true);
create policy campaign_participants_own_read on public.campaign_participants for select using(auth.uid() = user_id);
create policy campaign_participants_own_insert on public.campaign_participants for insert with check(auth.uid() = user_id);
create policy campaign_participants_own_delete on public.campaign_participants for delete using(auth.uid() = user_id);

create or replace function public.campaign_overview()
returns table(
  id uuid, slug text, title text, description text, target_count bigint,
  current_count bigint, starts_at date, ends_at date, joined boolean,
  personal_count bigint
) language sql security definer set search_path=public as $$
  select c.id,c.slug,c.title,c.description,c.target_count,
    coalesce(sum(d.count) filter (where d.deleted_at is null and d.date_key >= c.starts_at and (c.ends_at is null or d.date_key <= c.ends_at)),0)::bigint,
    c.starts_at,c.ends_at,
    exists(select 1 from campaign_participants p where p.campaign_id=c.id and p.user_id=auth.uid()),
    coalesce((
      select sum(own.count) from daily_collections own
      join campaign_participants p on p.campaign_id=c.id and p.user_id=auth.uid()
      where own.user_id=auth.uid() and own.deleted_at is null
        and own.date_key >= greatest(c.starts_at,p.joined_at::date)
        and (c.ends_at is null or own.date_key <= c.ends_at)
    ),0)::bigint
  from campaigns c
  left join campaign_participants member on member.campaign_id=c.id
  left join daily_collections d on d.user_id=member.user_id
  where c.active and c.starts_at <= current_date and (c.ends_at is null or c.ends_at >= current_date)
  group by c.id,c.slug,c.title,c.description,c.target_count,c.starts_at,c.ends_at
  order by c.starts_at desc;
$$;

create or replace function public.join_campaign(p_campaign_id uuid)
returns boolean language plpgsql security definer set search_path=public as $$
begin
  insert into campaign_participants(campaign_id,user_id) values(p_campaign_id,auth.uid()) on conflict do nothing;
  return true;
end $$;

create or replace function public.leave_campaign(p_campaign_id uuid)
returns boolean language plpgsql security definer set search_path=public as $$
begin
  delete from campaign_participants where campaign_id=p_campaign_id and user_id=auth.uid();
  return true;
end $$;

revoke all on function public.campaign_overview(),public.join_campaign(uuid),public.leave_campaign(uuid) from public;
grant execute on function public.campaign_overview(),public.join_campaign(uuid),public.leave_campaign(uuid) to authenticated;
