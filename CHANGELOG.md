# Changelog

> *This project is part of the [IROH Initiative](https://github.com/suporterfid/iroh). See the main hub for manifesto, branding, and ecosystem index.*

All notable changes to GrandpaSSOn will be documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2026-08-07

### Added
- **Multi-Tenant Claims (R1, R2)**: Added tenant membership (`tenant` / `tenants`) and group claims on `POST /session/exchange` and `/me/active-tenant`.
- **Machine Identity & Service Clients (R3, R4, R5)**: Opaque service client access tokens (`gpat_live_…`) issued via `POST /oauth/token` (client credentials grant) with introspection (`POST /oauth/introspect`) and revocation (`POST /oauth/revoke`).
- **Personal Access Tokens (PATs) (R10)**: User-issued and admin-managed API access tokens with scope restrictions and expiration (`/me/pats`).
- **PKCE Support (R11)**: S256 code challenge and code verifier verification for public client authorization code flow.
- **Admin Web Dashboard (R12)**: Minimal administrative web UI (`/admin`) and JSON API (`/admin/api`) protected by `ADMIN_API_TOKEN`.
- **DB-Backed Rate Limiting (R13)**: Throttle logic for login attempts and OAuth requests using database counters (SQLite and MySQL) without requiring Redis.
- **Gated Publishing Reader Sessions (R14)**: Reader auth chooser and provider routing with isolated `GPSREADER` cookie.
- **JWT & JWKS Endpoint (R15, R16)**: Optional companion JWT minting (RS256/HS256) and public JWKS endpoint (`GET /.well-known/jwks.json`) with RS256 key rotation CLI (`php cron/admin.php jwt:key-rotate`).
- **Email OTP & Self-Enrollment (R17)**: Passwordless email verification and access request enrollment workflow with administrative approval.
- **Notion-Inspired UI Design System**: Checked-in semantic CSS token contract (`theme.css`), self-hosted Inter 4.1 variable font, and WCAG 2.2 AA contrast compliance.

---

## [0.1.0] - 2026-07-20

### Added
- **Initial v0 MVP Release**: Core Single Sign-On broker architecture for cPanel shared hosting.
- **Federated OAuth Authentication**: Browser login adapters for Google Cloud, Microsoft Entra ID, and GitHub OAuth2.
- **Session Exchange Protocol**: Relying Party code exchange (`POST /session/exchange`) returning user profile payload.
- **Shared Hosting Deployment**: Build scripts producing production release ZIP (`grandpasson-release.zip`), cPanel database migrations, and scheduled cleanup cron jobs.
- **Docker Compose Local DX**: 100% containerized local stack with Nginx, PHP 8.2-FPM, MySQL, and Vite.
