# Claude Directives

> *This project is part of the [IROH Initiative](https://github.com/suporterfid/iroh). See the main hub for manifesto, branding, and ecosystem index.*

This file provides CLI reference commands, build instructions, and developer workflow guidelines for Claude and other AI coding assistants working in `grandpasson`.

---

## Command Quick Reference

### Environment Management (Docker)
```bash
# Start local development containers (Nginx:8080, PHP 8.2-FPM, MySQL:3306, Vite)
make up
# or
docker compose up -d

# Stop local containers
make down
# or
docker compose down
```

### Database Migrations
```bash
# Run database migrations locally
php cron/migrate.php

# Check migration parity between app migrations and docker MySQL init scripts
make check-migrations
```

### Testing Suite
```bash
# Run full PHPUnit test suite
make test
# or
php vendor/bin/phpunit
```

### Frontend Assets & Release Build
```bash
# Build frontend CSS assets and generate shared-hosting release ZIP (grandpasson-release.zip)
make build
# or
npm run build
```

### Administrative CLI Operations
```bash
# Display admin CLI help and available subcommands
php cron/admin.php --help

# Create tenant organization
php cron/admin.php tenant:create <slug> <name>

# Create machine identity service client
php cron/admin.php client:create-service <name> --scopes=<scope1,scope2> --aud=<audience>

# Rotate RS256 JWT signing key
php cron/admin.php jwt:key-rotate
```

---

## Engineering Guidelines

1. **Shared-Hosting Compatibility**: Keep PHP code compatible with standard shared hosting environments. Avoid relying on shell execution (`exec`/`system`), persistent memory caches, or supervisor daemons.
2. **Dual Database Testing**: Ensure queries work seamlessly on both SQLite and MySQL InnoDB engines.
3. **Design System Adherence**: Use semantic CSS tokens from `public_html/assets/theme.css`. Maintain WCAG 2.2 AA accessibility and contrast compliance.
4. **Cross-Platform Parity**: Ensure all CLI scripts and targets run identically on Windows PowerShell and Linux Bash.
