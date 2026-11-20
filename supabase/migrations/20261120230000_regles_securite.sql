alter table commandes enable row level security;
alter table produits enable row level security;

drop policy if exists "admin_all" on commandes;
create policy "admin_all" on commandes for all
  using (auth.jwt() -> 'app_metadata' ->> 'role' = 'admin');

drop policy if exists "user_read_own" on commandes;
create policy "user_read_own" on commandes for select
  using (auth.uid() = user_id);

drop policy if exists "user_insert_own" on commandes;
create policy "user_insert_own" on commandes for insert
  with check (auth.uid() = user_id);

drop policy if exists "produits_write" on produits;
create policy "produits_write" on produits for all
  using (auth.jwt() -> 'app_metadata' ->> 'role' = 'admin');

drop policy if exists "lecture publique des produits" on produits;
create policy "lecture publique des produits" on produits for select
  using (disponible = true);
