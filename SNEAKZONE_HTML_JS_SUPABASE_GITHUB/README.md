# SNEAKZONE — loja virtual

Projeto acadêmico de e-commerce feito com HTML, CSS e JavaScript, Supabase (PostgreSQL + Auth) e GitHub Pages. Não utiliza PHP.

## 1. O que está incluído
- Página inicial, catálogo com busca/filtros, detalhes do produto, login/cadastro, carrinho/checkout e área do cliente.
- Cadastro e login usando Supabase Auth.
- Catálogo carregado do Supabase.
- Registro e histórico de pedidos no PostgreSQL.
- Carrinho salvo no navegador.
- Consulta de CEP pelo ViaCEP e estimativa ilustrativa de frete.
- Pagamento demonstrativo: não captura nem processa dados bancários/cartões.

## 2. Criar e configurar o Supabase
1. Acesse https://supabase.com/ e crie um projeto.
2. Abra **SQL Editor > New query**.
3. Copie todo o conteúdo de `supabase/schema.sql`, cole e clique em **Run**.
4. Em **Project Settings > API** (ou Connect), copie a Project URL e a chave pública **publishable** (ou a chave `anon` legada).
5. Abra `assets/js/config.js` e substitua os dois valores de exemplo.
6. Não use a chave `service_role`/secret no site. Ela nunca deve ser publicada.

## 3. Testar no computador
- Abra a pasta no VS Code.
- Use a extensão **Live Server** e abra `index.html`.
- Também é possível abrir o `index.html` diretamente, mas Live Server é recomendado.
- Para testar login, cadastro e pedidos, configure primeiro o Supabase.

## 4. Publicar no GitHub Pages
1. Crie um repositório público no GitHub, por exemplo `sneakzone`.
2. Envie todos os arquivos e pastas deste projeto para a raiz do repositório (o `index.html` deve ficar na raiz).
3. No repositório, entre em **Settings > Pages**.
4. Em **Build and deployment**, selecione **Deploy from a branch**.
5. Escolha a branch `main` e a pasta `/ (root)`, depois clique em **Save**.
6. Aguarde a publicação. O GitHub mostrará o endereço do site em Settings > Pages.
7. No Supabase, abra **Authentication > URL Configuration**. Configure o endereço publicado em **Site URL** e adicione o mesmo endereço em **Redirect URLs**. Para teste local, adicione também `http://127.0.0.1:5500/**` se usar Live Server.
8. Compartilhe o link do GitHub Pages com o professor.

## 5. Observações importantes
- GitHub Pages hospeda apenas arquivos estáticos. O banco e autenticação ficam no Supabase, online.
- A chave publishable/anon pode ficar no front-end quando as políticas RLS estiverem corretamente configuradas. Nunca publique `service_role`.
- O frete apresentado é uma estimativa acadêmica baseada no CEP, não uma cotação real de transportadora.
- Pix, cartão e boleto são apenas opções demonstrativas. Não existe integração com gateway nem pagamento real.
- Para produção real, o cálculo final, valores e criação de pedidos devem ser validados no servidor (Edge Function/backend) para impedir manipulação pelo navegador.
- Imagens são carregadas de URLs externas e podem ser substituídas pelas imagens próprias da loja.
