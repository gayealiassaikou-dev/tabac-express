-- Etat des regles de securite Supabase (RLS) au 20/11/2026
-- Document de reference : a coller dans Supabase > SQL Editor pour recreer les regles.

alter table commandes enable row level security;
alter table produits enable row level security;

-- COMMANDES
create policy "admin_all" on commandes for all
  using (auth.jwt() -> 'app_metadata' ->> 'role' = 'admin');
create policy "user_read_own" on commandes for select
  using (auth.uid() = user_id);
create policy "user_insert_own" on commandes for insert
  with check (auth.uid() = user_id);

-- PRODUITS
create policy "produits_write" on produits for all
  using (auth.jwt() -> 'app_metadata' ->> 'role' = 'admin');
create policy "lecture publique des produits" on produits for select
  using (disponible = true);

-- Donner le role admin a un compte (remplacer ID_DU_COMPTE) :
-- update auth.users set raw_app_meta_data = coalesce(raw_app_meta_data,'{}'::jsonb) || '{"role":"admin"}' where id = 'ID_DU_COMPTE';
