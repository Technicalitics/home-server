# LinguaCafe

Self-hosted language learning application. Learn languages through reading with vocabulary tracking and flashcards.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Copy `.env.example` to `.env` and configure:
   - Database credentials
   - Redis password
   - `TS_AUTHKEY` - Your Tailscale auth key
   - `TAILNET_NAME` - Your Tailscale network name

2. Create directories:
   - `database` - MySQL data
   - `storage` - Application storage
   - `cache` - Redis cache
   - `docker/supervisor-horizon.conf`
   - `docker/supervisor-websockets.conf`

3. Start: `docker compose up -d`

## Access

- Web UI: http://localhost:9191
- Via Tailscale: https://cafe.<TAILNET_NAME>.ts.net

## Service-Specific Configuration

### Components

- **database** - MySQL 8.0 database
- **python** - Python service for text processing/tokenization
- **redis** - Redis cache
- **webserver** - Main PHP/Apache web application

### Volumes

Hardcoded to my server setup:
- `/srv/docker/data/linguacafe/database` - MySQL data
- `/srv/docker/data/linguacafe/storage` - Application storage
- `/srv/docker/data/linguacafe/cache` - Redis cache
- `/srv/docker/data/linguacafe/docker/` - Supervisor configs

**To make portable:** Change to relative paths in docker-compose.yml.

### Dependencies

The webserver depends on the database being healthy. Database health is checked via `mysqladmin ping`.

### Tailscale

- Container: `linguacafe-ts`
- Hostname: `cafe`

### Ports

| Port | Service |
|------|---------|
| 9191 | HTTP |
| 6001 | WebSocket |
