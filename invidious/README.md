# Invidious

Open-source alternative front-end to YouTube. No ads, no tracking, no need for a Google account.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Copy `.env.example` to `.env` and configure:
   - `HMAC_KEY` - Generate with `pwgen 16 1`
   - `INVIDIOUS_COMPANION_KEY` - Generate with `pwgen 16 1`
   - `TS_AUTHKEY` - Your Tailscale auth key
   - `TAILNET_NAME` - Your Tailscale network name

2. Create external network: `docker network create invidious_default`

3. Start: `docker compose up -d`

## Access

- Web UI: http://localhost:3000
- Via Tailscale: https://youtube.<TAILNET_NAME>.ts.net

## Service-Specific Configuration

### Required Files

Invidious requires SQL init files from the Invidious repository. Mount these from your config directory:
- `/srv/docker/data/invidious/config/sql` - Database initialization scripts
- `/srv/docker/data/invidious/init-invidious-db.sh` - Database init script

**To make portable:** Clone [iv-org/invidious](https://github.com/iv-org/invidious) and mount `./config/sql` and `./docker/init-invidious-db.sh`.

### Configuration

Configuration is inline in `docker-compose.yml` via `INVIDIOUS_CONFIG` environment variable. Key settings:
- `db.*` - Database connection settings
- `hmac_key` - Secret key (REQUIRED, generate with `pwgen 16 1`)
- `invidious_companion_key` - Companion secret (generate with `pwgen 16 1`)
- `domain` - Your Tailscale domain
- `https_only: true` - Force HTTPS

### Data Storage

- `invidious_postgresdata` - PostgreSQL database
- `invidious_companioncache` - YouTube.js cache
- `invidious_tailscale_state` - Tailscale state

### Tailscale

- Container: `invidious-ts`
- Hostname: `youtube`

### Invidious Companion

The `invidious_companion` service runs on the host network (`network_mode: host`) to allow direct communication with the browser extension. This is required because the companion needs to receive requests from the local network.

### IPv6 SLAAC Addressing

The host network is configured with SLAAC addressing that rotates IPv6 addresses periodically. The companion service binds to all interfaces to ensure connectivity across address changes.

### Ports

| Port | Service |
|------|---------|
| 3000 | HTTP |
| 8282 | Companion (internal) |

### Healthchecks

- `invidious-db`: PostgreSQL health check
- `invidious`: Trending API endpoint check
