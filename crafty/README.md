# Crafty Controller

A Minecraft server manager with web UI for managing multiple Minecraft servers.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Copy `.env.example` to `.env` and configure:
   - `TZ` - Timezone (optional, defaults to UTC)
   - `TS_AUTHKEY` - Your Tailscale auth key
   - `TAILNET_NAME` - Your Tailscale network name

2. Create directories:
   ```bash
   mkdir -p /srv/docker/data/crafty/{backups,logs,servers,config,import}
   ```

3. Start: `docker compose up -d`

## Access

- Via Tailscale: https://crafty.<TAILNET_NAME>.ts.net:8443
- First run: Create admin account via the web UI

## Service-Specific Configuration

### Volumes

Hardcoded to my server setup:
- `/srv/docker/data/crafty/backups` - Server backups
- `/srv/docker/data/crafty/logs` - Crafty logs
- `/srv/docker/data/crafty/servers` - Minecraft server files
- `/srv/docker/data/crafty/config` - Crafty configuration
- `/srv/docker/data/crafty/import` - Files to import

**To make portable:** Change to relative paths in docker-compose.yml.

### Network

This service uses `network_mode: service:tailscale` - Crafty shares Tailscale's network namespace and is only accessible via Tailscale, not directly via host ports.

- Web UI (8443) - Access via Tailscale URL
- Minecraft servers - Access directly via `crafty.<TAILNET_NAME>.ts.net:PORT`

### Tailscale

- Container: `crafty-ts`
- Hostname: `crafty`
- Minecraft ports (25500-25600, 19132) are accessible directly over Tailscale

### Ports

| Port | Service |
|------|---------|
| 8443 | Crafty Web UI (HTTPS) |
| 25500-25600 | Minecraft Java servers |
| 19132 | Minecraft Bedrock server (UDP) |

All ports are accessible via Tailscale only.
