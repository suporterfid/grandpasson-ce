# Agent Directives

> *This project is part of the [IROH Initiative](https://github.com/suporterfid/iroh). See the main hub for manifesto, branding, and ecosystem index.*

This document specifies instructions and operational directives for AI coding agents (such as Antigravity, Claude, and Gemini) working on the `grandpasson` codebase.

---

## Core Architecture & Engineering Principles

1. **Lightweight & Self-Hosted Philosophy**:
   - Zero heavy framework dependencies (e.g. no Laravel/Symfony bloat).
   - Clean, modular PHP 8.2+ with PDO database interaction.
   - Designed to run seamlessly in cPanel / Hostinger shared hosting without persistent daemons, SSH requirements, or external cache engines like Redis.

2. **Dual Database Parity**:
   - Support both **SQLite** (for zero-config local testing and lightweight setups) and **MySQL / MariaDB** (for production cPanel deployments).
   - Ensure all database schema changes and migrations (`cron/migrate.php`) operate identically on both database engines.

3. **100% Containerized Local DX**:
   - Every feature must be testable, buildable, and runnable locally within Docker Compose containers (`web`, `php`, `frontend`, `db`).
   - Maintain cross-platform CLI command parity across Windows PowerShell and Linux Bash.

4. **UI & Design System Contract**:
   - Follow the IROH Notion-inspired visual identity specification ([docs/visual-identity.md](docs/visual-identity.md)).
   - Do NOT inject ad-hoc inline styles or literal HEX colors in templates; use semantic CSS tokens (`:root`, `[data-theme='light']`, `[data-theme='dark']`) from `public_html/assets/theme.css`.
   - Maintain strict WCAG 2.2 AA contrast standards and keyboard accessibility.

5. **Security & Parameter Hygiene**:
   - Never log or expose raw secrets, private keys, or passwords.
   - Use parameterized SQL statements for all database interactions.
   - Ensure strict CSRF protection on browser state-changing endpoints.

---

## Codebase Navigation & Reference Docs

* **Specification**: [docs/grandpasson-spec.md](docs/grandpasson-spec.md) and [docs/grandpasson-spec-v1-extension.md](docs/grandpasson-spec-v1-extension.md)
* **Deployment Guide**: [docs/deployment.md](docs/deployment.md)
* **Client Integration**: [docs/client-integration.md](docs/client-integration.md)
* **Visual Identity**: [docs/visual-identity.md](docs/visual-identity.md)
* **Meta-Repository**: [https://github.com/suporterfid/iroh](https://github.com/suporterfid/iroh)

---

## Developer Verification Commands

When completing any implementation or bugfix task, ALWAYS verify your work by running:

```bash
# 1. Run unit and integration test suite
make test

# 2. Verify migration parity between PHP and MySQL init scripts
make check-migrations

# 3. Compile assets and verify release artifact generation
make build
```
