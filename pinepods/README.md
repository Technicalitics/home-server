# Pinepods

Complete podcast management system. Play, download, and keep track of your favorite podcasts.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Copy `.env.example` to `.env` and configure:
   - Database credentials
   - Admin user account
   - `TS_AUTHKEY` - Your Tailscale auth key
   - `TAILNET_NAME` - Your Tailscale network name

2. Create directories:
   - `pgdata` - PostgreSQL data
   - `valkey` - Valkey cache
   - `backups` - Backup location
   - `downloads` - Download location

3. Start: `docker compose up -d`

## Access

- Web UI: http://localhost:8040
- Via Tailscale: https://podcasts.<TAILNET_NAME>.ts.net

## Service-Specific Configuration

### Components

- **db** - PostgreSQL 17 database
- **valkey** - Valkey (Redis fork) cache
- **pinepods** - Main application

### Volumes

Hardcoded to my server setup:
- `/mnt/media/podcasts/pinepods/pgdata` - PostgreSQL data
- `/mnt/media/podcasts/pinepods/valkey` - Valkey cache
- `/mnt/media/podcasts/pinepods/backups` - Backups
- `/mnt/media/podcasts/pinepods/downloads` - Downloads

**To make portable:** Change to relative paths in docker-compose.yml.

### Dependencies

The pinepods service depends on the database being healthy. Database health is checked via `pg_isready`.

### Tailscale

- Container: `pinepods-ts`
- Hostname: `podcasts`

### Ports

| Port | Service |
|------|---------|
| 8040 | HTTP |
