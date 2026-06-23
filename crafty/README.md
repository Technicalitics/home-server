# Crafty Controller

A Minecraft server manager with web UI for managing multiple Minecraft servers.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Copy `.env.example` to `.env` and configure `TZ` (optional).

2. Create directories:
   ```bash
   mkdir -p /srv/docker/data/crafty/{backups,logs,servers,config,import}
   ```

3. Start: `docker compose up -d`

## Access

- Web UI: https://crafty.server.netbird.cloud
- Local: http://localhost:8443
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

### Ports

| Port(s) | Service |
|---------|---------|
| 8443 | Crafty Web UI (HTTPS) — proxied by Caddy |
| 25500-25600 | Minecraft Java servers (TCP) — connect via host NetBird IP |

### Minecraft Server Access

Minecraft ports (25500-25600) are published to all host interfaces. Connect via the server's NetBird IP:
```
Server Address: 100.x.x.x:25565
```

To find the host's NetBird IP: `netbird status` on the server. Restrict access by configuring your host firewall to only allow traffic from the NetBird interface.
