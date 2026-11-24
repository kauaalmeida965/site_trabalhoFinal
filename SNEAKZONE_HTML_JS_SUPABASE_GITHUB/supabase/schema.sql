-- SNEAKZONE | Execute no SQL Editor do Supabase.
-- O Auth do Supabase gerencia as senhas; não armazene senhas em tabelas próprias.

create extension if not exists pgcrypto;

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category text not null,
  description text,
  price numeric(10,2) not null check (price >= 0),
  image_url text,
  featured boolean not null default false,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  created_at timestamptz not null default now()
);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  address text not null,
  payment_method text not null,
  status text not null default 'Aguardando confirmação (simulação)',
  subtotal numeric(10,2) not null,
  shipping numeric(10,2) not null default 0,
  total numeric(10,2) not null,
  created_at timestamptz not null default now()
);

create table if not exists public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  product_id uuid references public.products(id) on delete set null,
  product_name text not null,
  quantity integer not null check (quantity > 0),
  unit_price numeric(10,2) not null check (unit_price >= 0)
);

alter table public.products enable row level security;
alter table public.profiles enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;

-- Catálogo: visitantes podem consultar produtos ativos.
create policy "Produtos ativos são públicos" on public.products
for select using (active = true);

-- Perfil: cada usuário acessa apenas o próprio perfil.
create policy "Usuário lê próprio perfil" on public.profiles
for select to authenticated using (auth.uid() = id);
create policy "Usuário cria próprio perfil" on public.profiles
for insert to authenticated with check (auth.uid() = id);
create policy "Usuário atualiza próprio perfil" on public.profiles
for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

-- Pedidos: cada usuário cria e consulta somente os próprios pedidos.
create policy "Usuário cria próprio pedido" on public.orders
for insert to authenticated with check (auth.uid() = user_id);
create policy "Usuário consulta próprios pedidos" on public.orders
for select to authenticated using (auth.uid() = user_id);

-- Itens: só pode inserir/consultar itens ligados a pedido do próprio usuário.
create policy "Usuário insere itens do próprio pedido" on public.order_items
for insert to authenticated with check (
  exists (select 1 from public.orders o where o.id = order_id and o.user_id = auth.uid())
);
create policy "Usuário consulta itens do próprio pedido" on public.order_items
for select to authenticated using (
  exists (select 1 from public.orders o where o.id = order_id and o.user_id = auth.uid())
);

-- Produtos de exemplo. Execute uma única vez.
insert into public.products (name,category,description,price,image_url,featured) values
('Velocity Runner','Corrida','Leveza e amortecimento para acompanhar seu ritmo.',399.90,'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',true),
('Street Classic','Casual','Visual versátil para o dia a dia.',329.90,'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=800',true),
('Urban Court','Streetwear','Atitude urbana com conforto.',459.90,'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=800',true),
('Cloud Move','Corrida','Conforto para ir mais longe.',519.90,'https://images.unsplash.com/photo-1495555961986-6d4c1ecb7be3?w=800',false),
('Daily Canvas','Casual','Um clássico que combina com tudo.',279.90,'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=800',false),
('Street Pulse','Streetwear','Design marcante para sua rotina.',489.90,'https://images.unsplash.com/photo-1460353581641-37b9adf8f4b4?w=800',false);
