create or replace function public.sync_daily_collection(
  p_id uuid,
  p_date_key date,
  p_count integer,
  p_updated_at timestamptz
) returns uuid
language plpgsql
security invoker
set search_path = public
as $$
declare
  result_id uuid;
begin
  insert into public.daily_collections (
    id, user_id, date_key, count, created_at, updated_at
  ) values (
    p_id, auth.uid(), p_date_key, p_count, now(), p_updated_at
  )
  on conflict (user_id, date_key) do update
  set count = excluded.count,
      updated_at = excluded.updated_at,
      deleted_at = null
  where public.daily_collections.updated_at <= excluded.updated_at
  returning id into result_id;

  if result_id is null then
    select id into result_id
    from public.daily_collections
    where user_id = auth.uid() and date_key = p_date_key;
  end if;
  return result_id;
end;
$$;

grant execute on function public.sync_daily_collection(uuid, date, integer, timestamptz) to authenticated;