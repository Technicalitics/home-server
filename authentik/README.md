# Authentik

Identity provider and single sign-on solution for self-hosted applications.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Copy `.env.example` to `.env` and configure:
   - `PG_PASS` - PostgreSQL password
   - `AUTHENTIK_SECRET_KEY` - Authentik secret

2. Start: `docker compose up -d`

## Access

- Web UI: https://auth.server.netbird.cloud
- Local: http://localhost:9000

## Service-Specific Configuration

### Volume Paths

Hardcoded to my server setup:
- `/srv/docker/data/authentik/certs` - SSL certificates
- `/srv/docker/data/authentik/data` - Application data
- `/srv/docker/data/authentik/custom-templates` - Custom templates

**To make portable:** Change to relative paths in docker-compose.yml.

### Environment Variables

Key configuration:
- `AUTHENTIK_SECRET_KEY` - Required secret key (generate with `openssl rand -base64 60`)
- `PG_PASS` - PostgreSQL password
- `AUTHENTIK_POSTGRESQL__HOST=postgresql` - (auto-set in compose, no need to configure)

### Ports

| Port | Service |
|------|---------|
| 9000 | HTTP (proxied by Caddy) |
| 9443 | HTTPS (internal) |
