🇧🇷 [Leia em Português](README.pt-BR.md) (esta página) | 🇺🇸 [English](README.md)

> 🍵 **Parte da Iniciativa IROH** (*It Runs On Hostinger*)  
> Este projeto é um software de código aberto e auto-hospedado construído para hospedagem compartilhada tradicional.  
> Saiba mais no hub principal: [suporterfid/iroh](https://github.com/suporterfid/iroh) | [Manifesto](https://github.com/suporterfid/iroh/blob/main/MANIFESTO.md) | [Índice de Projetos](https://github.com/suporterfid/iroh/blob/main/PROJECTS.md) | [Especificação de Branding](https://github.com/suporterfid/iroh/blob/main/BRANDING.md)

# GrandpaSSOn

> SSO que roda onde o cPanel do seu avô ainda vive.

**Esta é a Community Edition**: o produto completo sob a Licença MIT, publicado como um snapshot por release. Os zips de release prontos para upload (com `vendor/` incluído) estão na [página de Releases](https://github.com/suporterfid/grandpasson-ce/releases). Dúvidas vão para as [Discussions](https://github.com/suporterfid/grandpasson-ce/discussions); veja [CONTRIBUTING.md](CONTRIBUTING.md) e [SECURITY.md](SECURITY.md).

GrandpaSSOn é um broker de Single Sign-On (SSO) leve e auto-hospedado projetado para implantação de alta portabilidade em hospedagens compartilhadas tradicionais (Hostinger, cPanel, Apache/Nginx, PHP 8.2+ com PDO). Ele federa identidades do Google, Microsoft Entra ID e GitHub, oferecendo também login via Email OTP sem senha e fluxo de auto-matrícula com aprovação administrativa.

Como o Provedor de Identidade (IdP) central da **Iniciativa IROH**, o GrandpaSSOn fornece autenticação, claims de organizações multi-tenant, tokens de máquina para clientes de serviço e Personal Access Tokens (PATs) para todas as aplicações do ecossistema IROH, sem qualquer dependência de frameworks pesados, processos daemon ou motores de cache externos como Redis.

---

## Parte da Iniciativa IROH

O GrandpaSSOn é um componente central da **[Iniciativa IROH](https://github.com/suporterfid/iroh)** (*It Runs On Hostinger*). O ecossistema IROH fornece aplicações web leves e auto-hospedadas otimizadas para ambientes cPanel tradicionais e hospedagens web de recursos limitados.

* **Repositório Central (Meta-repo)**: [suporterfid/iroh](https://github.com/suporterfid/iroh)
* **Manifesto**: [Leia o Manifesto IROH](https://github.com/suporterfid/iroh/blob/main/MANIFESTO.md)
* **Índice de Projetos do Ecossistema**: [Explore todos os projetos em PROJECTS.md](https://github.com/suporterfid/iroh/blob/main/PROJECTS.md)
* **Especificação de Branding e Identidade Visual**: [Explore BRANDING.md](https://github.com/suporterfid/iroh/blob/main/BRANDING.md)

---

## Funcionalidades

* **Federação de Identidades Multi-Provedor**: Login via navegador com Google, Microsoft Entra ID e GitHub OAuth2/OIDC.
* **Email OTP e Auto-Matrícula**: Verificação de e-mail OTP sem senha com fluxo de aprovação administrativa (`user:list-pending`, `user:approve`, `user:reject`).
* **Claims Multi-Tenant e Funções de Grupo**: Membresia de tenants (`tenant` / `tenants`) e papéis de grupo dinâmicos entregues via `POST /session/exchange`.
* **Identidade de Máquina para Clientes de Serviço**: Access tokens opacos (`gpat_live_…`) para agentes automatizados, utilitários CLI e APIs entre serviços via `POST /oauth/token` (grant client credentials).
* **Personal Access Tokens (PATs)**: Tokens de acesso à API emitidos por usuários ou gerenciados por administradores, com restrições de escopo e expiração TTL (`/me/pats`).
* **Sessões de Leitor para Publicação Protegida**: Cookie de autenticação de leitor isolado (`GPSREADER`) para acesso de leitores a sites publicados sem comprometer sessões de editor (`AUTHSESSID`).
* **JWTs Assinados e Rotação JWKS**: Tokens JWT opcionais (RS256/HS256) e endpoint JWKS público (`GET /.well-known/jwks.json`) com rotação de chaves (`php cron/admin.php jwt:key-rotate`).
* **Rate Limiting para Hospedagem Compartilhada**: Limitação de taxa de login via banco de dados (15 tentativas / 5 min, IP bloqueado por 15 min) e limitação de tokens OAuth operando puramente em tabelas SQL/SQLite sem Redis.
* **CLI Administrativo e Painel Web**: Kit de ferramentas CLI administrativo completo (`cron/admin.php`) e UI web minimalista (`/admin` & `/admin/api`).

---

## Requisitos e Stack Técnica

* **Runtime PHP**: PHP 8.2+ com extensões `pdo`, `pdo_mysql`, `pdo_sqlite`, `curl`, `openssl`, `json`.
* **Suporte Duplo a Banco de Dados**:
  * **SQLite**: Motor local padrão para testes locais de tenant único, zero-configuração e sites leves.
  * **MySQL / MariaDB**: Recomendado para produção em hospedagem compartilhada cPanel (engine InnoDB).
* **DX Local 100% Containerizada em Docker**: Ambiente de desenvolvimento local completo via Docker Compose:
  * `web`: Servidor web Nginx / proxy reverso (Porta `8080`).
  * `php`: Container PHP 8.2-FPM com drivers SQLite & MySQL.
  * `frontend`: Ambiente de build Node.js / Vite para tokens CSS e assets.
  * `db`: Serviço de banco de dados local MySQL 8.0.
* **Paridade entre Windows (PowerShell) e Linux (Bash)**: Cada comando, script e alvo de build oferece 100% de simetria entre ambientes Windows PowerShell e Linux Bash:
  * Iniciar ambiente: `docker compose up -d` ou `make up`
  * Executar testes: `php vendor/bin/phpunit` ou `make test`
  * Compilar assets & ZIP de release: `npm run build` ou `make build`
  * Executar migrações do banco de dados: `php cron/migrate.php` ou `make check-migrations`

---

## Frontend e Sistema de Design UI

O GrandpaSSOn incorpora a **especificação de identidade visual orientada a conteúdo inspirada no Notion da IROH**:

* **Contrato de Tokens Semânticos CSS**: Contrato público de tokens definido em `public_html/assets/theme.css` com suporte nativo aos temas claro (`:root`, `[data-theme='light']`) e escuro (`[data-theme='dark']`).
* **Conformidade WCAG 2.2 AA**: Pares de cores testados atendendo a padrões rigorosos de contraste em textos, indicadores de status e anéis de foco (contorno de foco de 2px com deslocamento de 2px).
* **Shell Responsivo Mobile-First**: Adaptação dinâmica de viewport (largura de leitura de 720px em `.prose`, alvos de toque de 44px, espaçamento com propriedades lógicas).
* **Tipografia Auto-Hospedada**: Família tipográfica variável (`Inter 4.1`) hospedada localmente sem dependências de CDN externa.
* **Especificação de Design**: Leia [docs/visual-identity.md](docs/visual-identity.md) e o arquivo [BRANDING.md](https://github.com/suporterfid/iroh/blob/main/BRANDING.md) no meta-repositório.

---

## Instalação e Implantação em Hospedagem Compartilhada

O GrandpaSSOn foi projetado para implantação simples em hospedagens compartilhadas cPanel ou Hostinger:

1. **Obter o Artefato de Release**: Baixe `grandpasson-release.zip` da [última release](https://github.com/suporterfid/grandpasson-ce/releases/latest) ou compile-o na sua máquina com Docker:
   ```bash
   make build
   ```
   Isso gera o arquivo `grandpasson-release.zip` contendo `public_html/`, `app/`, `vendor/`, `cron/`, `composer.json` e `.env.example`. Este repositório não inclui `vendor/`; o build instala no zip as dependências de produção travadas em `composer.lock`, então o servidor nunca roda o Composer.

2. **Enviar para o Servidor**:
   Descompacte `grandpasson-release.zip` ao lado da raiz da web (`public_html/`):
   ```text
   ~/auth.example.com/
     public_html/          ← Document root
     app/
     vendor/               ← Dependências de produção pré-empacotadas
     cron/
     composer.json
     .env                  ← Criado a partir de .env.example
   ```

3. **Configurar Ambiente**:
   Crie o arquivo `.env` a partir de `.env.example` e preencha os parâmetros críticos:
   * `APP_ENV=prod`
   * `BROKER_BASE_URL=https://auth.example.com`
   * `DB_HOST`, `DB_NAME`, `DB_USER`, `DB_PASS` (credenciais MySQL do cPanel)
   * Credenciais dos Provedores (`GOOGLE_CLIENT_ID`, `MS_CLIENT_ID`, `GITHUB_CLIENT_ID`, etc.)
   * `ADMIN_API_TOKEN` (Segredo longo para habilitar a UI/API `/admin`)

4. **Executar Migrações do Banco de Dados**:
   Execute o script de migração via SSH ou tarefa agendada:
   ```bash
   php cron/migrate.php
   ```

5. **Configurar Tarefas Cron**:
   Configure as tarefas agendadas no cPanel para limpeza em segundo plano de sessões e tokens:
   * A cada 15 minutos: `php /caminho/para/cron/cleanup_sessions.php`
   * A cada 5 minutos: `php /caminho/para/cron/cleanup_auth_codes.php`
   * A cada hora: `php /caminho/para/cron/cleanup_access_tokens.php`
   * Diariamente: `php /caminho/para/cron/cleanup_audit_log.php`

Para instruções detalhadas de implantação, consulte [docs/deployment.md](docs/deployment.md).

---

## Resumo de Uso

### Inicio Rápido (Docker Local)

```bash
cp .env.example .env
make install   # composer install no Docker (vendor/ não está neste repositório)
make up
make migrate
# O broker estará rodando em: http://localhost:8080
```

### Superfície de Rotas HTTP

| Método | Caminho | Propósito |
|---|---|---|
| `GET` | `/` | Endpoint de verificação de saúde (health check) |
| `GET` | `/.well-known/jwks.json` | JWKS público para verificação de JWTs RS256 |
| `GET` | `/login/{provider}` | Iniciar login OAuth via navegador (google, microsoft, github) |
| `GET` | `/callback/{provider}` | Endpoint de callback do IdP OAuth |
| `POST` | `/session/exchange` | Trocar auth-code por dados do usuário, claims de tenant e grupos |
| `POST` | `/oauth/token` | Obter token de máquina de cliente de serviço ou token de auth-code |
| `POST` | `/oauth/introspect` | Validar token de acesso de máquina ativo ou PAT |
| `POST` | `/oauth/revoke` | Revogar token de acesso de máquina |
| `GET` | `/admin` | UI Web de Administração minimalista (requer `ADMIN_API_TOKEN`) |
| `POST` | `/admin/api` | Endpoint da API JSON de administração |

### Utilitário CLI Administrativo

Execute tarefas administrativas diretamente via linha de comando:
```bash
# Criar organização tenant
php cron/admin.php tenant:create acme "Acme Corp"

# Criar cliente de serviço com identidade de máquina
php cron/admin.php client:create-service "TaskConnect" --scopes=tasks:write --aud=workspace/env_123

# Listar solicitações de acesso pendentes
php cron/admin.php user:list-pending

# Aprovar acesso de usuário pendente
php cron/admin.php user:approve user_123
```

Guia detalhado de integração para clientes: [docs/client-integration.md](docs/client-integration.md).

---

## Autoridade de Single Sign-On (SSO)

O GrandpaSSOn atua como o **Provedor de Identidade Central de Single Sign-On (SSO)** para todas as aplicações web, serviços e micro-ferramentas da iniciativa IROH. As aplicações delegam a autenticação de usuários e a verificação de identidade ao GrandpaSSOn por meio de protocolos padronizados OIDC/OAuth2 e trocas de sessão assinadas.

Referência do repositório: [https://github.com/suporterfid/grandpasson-ce](https://github.com/suporterfid/grandpasson-ce)

---

## Integração com Outros Projetos IROH

O GrandpaSSOn se integra com todas as aplicações do ecossistema IROH:

* **[grandpasson](https://github.com/suporterfid/grandpasson-ce)** — Provedor de Identidade Central de Single Sign-On (SSO) (este projeto).
* **[jotter](https://github.com/suporterfid/jotter)** — Base de conhecimento Markdown auto-hospedada & sincronização WebDAV.
* **[ConvertDocToMd-PHP](https://github.com/suporterfid/ConvertDocToMd-PHP)** — Conversor de DOC/DOCX/PDF para Markdown em PHP puro.
* **[taskconnect](https://github.com/suporterfid/taskconnect)** — Gerenciador leve de tarefas e projetos.
* **[statusconnect](https://github.com/suporterfid/iroh/blob/main/PROJECTS.md)** — Monitoramento de uptime e página de status pública.
* **[tallymark](https://github.com/suporterfid/tallymark)** — Contador minimalista de eventos e contagens.

---

## Contribuição

Contribuições são muito bem-vindas! Leia o [CONTRIBUTING.md](CONTRIBUTING.md) (em inglês): como os pull requests daqui chegam a uma release e o sign-off DCO que todo commit precisa. Reporte vulnerabilidades de forma privada ([SECURITY.md](SECURITY.md)). A governança global e os princípios arquitetônicos da iniciativa são coordenados no hub principal: [suporterfid/iroh CONTRIBUTING.md](https://github.com/suporterfid/iroh/blob/main/CONTRIBUTING.md).

---

## Licença

O GrandpaSSOn é um software de código aberto licenciado sob a [Licença MIT](LICENSE).
