🇧🇷 [Leia em Português](README.pt-BR.md) | 🇺🇸 [English](README.md) (this page)

> 🍵 **Part of the IROH Initiative** (*It Runs On Hostinger*)  
> This project is open-source, self-hosted software built for traditional shared hosting.  
> Learn more at the main hub: [suporterfid/iroh](https://github.com/suporterfid/iroh) | [Manifesto](https://github.com/suporterfid/iroh/blob/main/MANIFESTO.md) | [Projects Index](https://github.com/suporterfid/iroh/blob/main/PROJECTS.md) | [Branding Spec](https://github.com/suporterfid/iroh/blob/main/BRANDING.md)

# GrandpaSSOn

> SSO that runs where your grandpa's cPanel still lives.

**This is the Community Edition**: the whole product under the MIT License, published as one snapshot per release. Ready-to-upload release zips (with `vendor/` bundled) are on the [Releases page](https://github.com/suporterfid/grandpasson-ce/releases). Questions go to [Discussions](https://github.com/suporterfid/grandpasson-ce/discussions); see [CONTRIBUTING.md](CONTRIBUTING.md) and [SECURITY.md](SECURITY.md).

GrandpaSSOn is a self-hosted, lightweight Single Sign-On (SSO) broker designed for high-portability deployment on traditional shared hosting (Hostinger, cPanel, Apache/Nginx, PHP 8.2+ with PDO). It federates identity from Google, Microsoft Entra ID, and GitHub, while offering passwordless Email OTP login and self-service access request enrollment.

As the central Single Sign-On IdentityProvider (IdP) for the **IROH Initiative**, GrandpaSSOn delivers authentication, multi-tenant organization claims, service-client machine tokens, and Personal Access Tokens (PATs) across all applications in the IROH ecosystem with zero dependency on heavy frameworks, daemon processes, or external cache engines like Redis.

---

## Part of the IROH Initiative

GrandpaSSOn is a core component of the **[IROH Initiative](https://github.com/suporterfid/iroh)** (*It Runs On Hostinger*). The IROH ecosystem provides lightweight, self-hosted web applications optimized for traditional cPanel environments and low-resource web hosts.

* **Central Meta-Repository**: [suporterfid/iroh](https://github.com/suporterfid/iroh)
* **Manifesto**: [Read the IROH Manifesto](https://github.com/suporterfid/iroh/blob/main/MANIFESTO.md)
* **Ecosystem Projects Index**: [Browse all projects in PROJECTS.md](https://github.com/suporterfid/iroh/blob/main/PROJECTS.md)
* **Branding & Visual Identity Spec**: [Explore BRANDING.md](https://github.com/suporterfid/iroh/blob/main/BRANDING.md)

---

## Features

* **Multi-Provider Identity Federation**: Browser login via Google, Microsoft Entra ID, and GitHub OAuth2/OIDC.
* **Email OTP & Self-Enrollment**: Passwordless email OTP verification with administrative approval workflow (`user:list-pending`, `user:approve`, `user:reject`).
* **Multi-Tenant Claims & Group Roles**: Dynamic tenant membership (`tenant` / `tenants`) and group role resolution delivered via `POST /session/exchange`.
* **Service Client Machine Identity**: Opaque machine access tokens (`gpat_live_…`) for automated agents, CLI utilities, and inter-service APIs via `POST /oauth/token` (client credentials grant).
* **Personal Access Tokens (PATs)**: User-issued and admin-managed API access tokens with fine-grained scope constraints and TTL expiration (`/me/pats`).
* **Gated Publishing Reader Sessions**: Isolated reader auth cookie (`GPSREADER`) for reader access to published sites without compromising editor sessions (`AUTHSESSID`).
* **Signed JWTs & JWKS Rotation**: Optional RS256/HS256 companion JWT tokens and public JWKS endpoint (`GET /.well-known/jwks.json`) with automated key rotation (`php cron/admin.php jwt:key-rotate`).
* **Shared-Hosting Rate Limiting**: DB-backed login throttle (15 attempts / 5 mins, 15 min IP lockout) and OAuth token throttle operating purely on SQL/SQLite tables without Redis.
* **Admin CLI & Web Dashboard**: Full administrative CLI toolkit (`cron/admin.php`) and minimal web UI (`/admin` & `/admin/api`).

---

## Technical Stack & Requirements

* **PHP Runtime**: PHP 8.2+ with `pdo`, `pdo_mysql`, `pdo_sqlite`, `curl`, `openssl`, `json` extensions.
* **Dual Database Support**:
  * **SQLite**: Default local engine for single-tenant, zero-config testing and lightweight sites.
  * **MySQL / MariaDB**: Recommended for production cPanel shared hosting (InnoDB engine).
* **100% Docker Containerized Local DX**: Complete local development environment via Docker Compose:
  * `web`: Nginx web server / reverse proxy (Port `8080`).
  * `php`: PHP 8.2-FPM container with SQLite & MySQL drivers.
  * `frontend`: Node.js / Vite build environment for CSS tokens and assets.
  * `db`: MySQL 8.0 local database service.
* **Windows (PowerShell) & Linux (Bash) Parity**: Every command, script, and build target offers 100% symmetry across Windows PowerShell and Linux Bash environments:
  * Start environment: `docker compose up -d` or `make up`
  * Run tests: `php vendor/bin/phpunit` or `make test`
  * Compile assets & release ZIP: `npm run build` or `make build`
  * Run database migrations: `php cron/migrate.php` or `make check-migrations`

---

## Frontend & UI Design System

GrandpaSSOn incorporates the **IROH Notion-inspired, content-first visual identity specification**:

* **CSS Semantic Tokens Contract**: Public theme tokens contract defined in `public_html/assets/theme.css` with native support for light (`:root`, `[data-theme='light']`) and dark (`[data-theme='dark']`) themes.
* **WCAG 2.2 AA Contrast Compliance**: Tested color pairs meeting strict contrast standards across text, status indicators, and focus rings (2px focus outline with 2px offset).
* **Mobile-First Responsive Shell**: Dynamic viewport adaptation (`.prose` 720px measure, touch-friendly 44px hit targets, logical-property spacing).
* **Self-Hosted Typography**: Variable font stack (`Inter 4.1`) hosted locally without external CDN dependencies.
* **Design Specification**: Read [docs/visual-identity.md](docs/visual-identity.md) and the meta-repo [BRANDING.md](https://github.com/suporterfid/iroh/blob/main/BRANDING.md).

---

## Installation & Shared Hosting Deployment

GrandpaSSOn is designed for effortless deployment on cPanel or Hostinger shared hosting:

1. **Get the Release Artifact**: Download `grandpasson-release.zip` from the [latest release](https://github.com/suporterfid/grandpasson-ce/releases/latest), or build it on your machine with Docker:
   ```bash
   make build
   ```
   This generates `grandpasson-release.zip` containing `public_html/`, `app/`, `vendor/`, `cron/`, `composer.json`, and `.env.example`. This repository does not ship `vendor/`; the build installs the locked production dependencies (`composer.lock`) into the zip, so the host never runs Composer.

2. **Upload to Host**:
   Unpack `grandpasson-release.zip` beside your host's web root (`public_html/`):
   ```text
   ~/auth.example.com/
     public_html/          ← Document root
     app/
     vendor/               ← Pre-bundled production dependencies
     cron/
     composer.json
     .env                  ← Created from .env.example
   ```

3. **Configure Environment**:
   Create `.env` from `.env.example` and set critical environment parameters:
   * `APP_ENV=prod`
   * `BROKER_BASE_URL=https://auth.example.com`
   * `DB_HOST`, `DB_NAME`, `DB_USER`, `DB_PASS` (cPanel MySQL credentials)
   * Provider credentials (`GOOGLE_CLIENT_ID`, `MS_CLIENT_ID`, `GITHUB_CLIENT_ID`, etc.)
   * `ADMIN_API_TOKEN` (Long secret to enable `/admin` UI/API)

4. **Execute Database Migrations**:
   Run the migration script via SSH or scheduled task:
   ```bash
   php cron/migrate.php
   ```

5. **Configure Cron Jobs**:
   Set up cPanel scheduled tasks for background session and token cleanup:
   * Every 15 minutes: `php /path/to/cron/cleanup_sessions.php`
   * Every 5 minutes: `php /path/to/cron/cleanup_auth_codes.php`
   * Hourly: `php /path/to/cron/cleanup_access_tokens.php`
   * Daily: `php /path/to/cron/cleanup_audit_log.php`

For comprehensive deployment instructions, review [docs/deployment.md](docs/deployment.md).

---

## Usage Summary

### Quickstart (Local Docker)

```bash
cp .env.example .env
make install   # composer install in Docker (vendor/ is not in this repository)
make up
make migrate
# Broker runs at: http://localhost:8080
```

### HTTP Routes Surface

| Method | Path | Purpose |
|---|---|---|
| `GET` | `/` | Health check endpoint |
| `GET` | `/.well-known/jwks.json` | Public JWKS for RS256 JWT verification |
| `GET` | `/login/{provider}` | Initiate OAuth browser login (google, microsoft, github) |
| `GET` | `/callback/{provider}` | OAuth IdP callback endpoint |
| `POST` | `/session/exchange` | Exchange RP auth-code for user details, tenant claims & groups |
| `POST` | `/oauth/token` | Obtain service-client machine token or auth-code token |
| `POST` | `/oauth/introspect` | Validate active machine access token or PAT |
| `POST` | `/oauth/revoke` | Revoke machine access token |
| `GET` | `/admin` | Minimal Web Admin UI (requires `ADMIN_API_TOKEN`) |
| `POST` | `/admin/api` | Admin JSON API endpoint |

### Admin CLI Utility

Run administrative tasks directly from CLI:
```bash
# Create tenant organization
php cron/admin.php tenant:create acme "Acme Corp"

# Create machine identity service client
php cron/admin.php client:create-service "TaskConnect" --scopes=tasks:write --aud=workspace/env_123

# List pending access requests
php cron/admin.php user:list-pending

# Approve pending user access
php cron/admin.php user:approve user_123
```

Detailed client integration guide: [docs/client-integration.md](docs/client-integration.md).

---

## Single Sign-On (SSO) Authority

GrandpaSSOn serves as the **Central Single Sign-On (SSO) IdentityProvider** for all web applications, services, and micro-tools within the IROH initiative. Applications delegate user authentication and identity verification to GrandpaSSOn via standardized OIDC/OAuth2 protocols and signed session exchanges.

Repository reference: [https://github.com/suporterfid/grandpasson-ce](https://github.com/suporterfid/grandpasson-ce)

---

## Integration with Other IROH Projects

GrandpaSSOn connects with all applications in the IROH ecosystem:

* **[grandpasson](https://github.com/suporterfid/grandpasson-ce)** — Central Single Sign-On (SSO) IdentityProvider (this project).
* **[jotter](https://github.com/suporterfid/jotter)** — Self-hosted Markdown knowledge base & WebDAV sync.
* **[ConvertDocToMd-PHP](https://github.com/suporterfid/ConvertDocToMd-PHP)** — Plain PHP DOC/DOCX/PDF to Markdown converter.
* **[taskconnect](https://github.com/suporterfid/taskconnect)** — Lightweight task & project manager.
* **[statusconnect](https://github.com/suporterfid/iroh/blob/main/PROJECTS.md)** — Uptime monitoring & public status page.
* **[tallymark](https://github.com/suporterfid/tallymark)** — Minimalist tally & event counter.

---

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md): how pull requests here reach a release, and the DCO sign-off every commit needs. Report vulnerabilities privately ([SECURITY.md](SECURITY.md)). Initiative-wide governance and architectural principles are coordinated at the main hub: [suporterfid/iroh CONTRIBUTING.md](https://github.com/suporterfid/iroh/blob/main/CONTRIBUTING.md).

---

## License

GrandpaSSOn is open-source software licensed under the [MIT License](LICENSE).
