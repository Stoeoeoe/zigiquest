# Supabase setup

Run `supabase link --project-ref YOUR_REF` and `supabase db push`. The migration creates owner-only RLS and a private Storage bucket. Confirm that no permissive dashboard-created policy exists. Use `supabase db reset` for local development. The account deletion RPC removes private objects before deleting `auth.users`; deploy it only after reviewing it for your project policy.
