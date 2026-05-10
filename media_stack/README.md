# Media Stack

Media download and management stack using Gluetun (VPN), qBittorrent, Sonarr, Radarr, Prowlarr, Seerr, Maintainerr, and FlareSolverr.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Copy `.env.example` to `.env` and configure:
   - `TZ` - Your timezone
   - `PUID`/`PGID` - User/group IDs matching your media files
   - VPN provider details (see below)

2. Set up directory permissions:

   ```bash
   sudo mkdir -p /mnt/media/downloads /mnt/media/tv
   sudo chown -R $PUID:$PGID /mnt/media/downloads /mnt/media/tv
   ```

3. Start: `docker compose up -d`

## Access

All services are bound to localhost only (`127.0.0.1`) for security, except Seerr which is also exposed via Tailscale.

| Service | URL | Port |
|---------|-----|------|
| qBittorrent | http://localhost:8080 | 8080 |
| Sonarr | http://localhost:8989 | 8989 |
| Radarr | http://localhost:7878 | 7878 |
| Prowlarr | http://localhost:9696 | 9696 |
| Seerr | http://localhost:5055 / https://requests.${TAILNET_NAME}.ts.net | 5055 |
| Maintainerr | http://localhost:6246 | 6246 |
| FlareSolverr | http://localhost:8191 | 8191 |

## Service-Specific Configuration

### Volume Paths

Hardcoded to my server setup:
- `/srv/docker/data/qbittorrent` - qBittorrent config
- `/srv/docker/data/sonarr` - Sonarr config
- `/srv/docker/data/radarr` - Radarr config
- `/srv/docker/data/prowlarr` - Prowlarr config
- `/srv/docker/data/seerr` - Seerr config
- `/srv/docker/data/maintainerr` - Maintainerr config
- `/mnt/media/downloads` - Download directory
- `/mnt/media/tv` - TV show library
- `/mnt/media/movies` - Movie library

**To make portable:** Change to relative paths in docker-compose.yml.

### Networking

Services communicate over an internal bridge network (`media_network`):
- Sonarr/Radarr connect to qBittorrent at `gluetun:8080`
- Seerr connects to Jellyfin via `https://media.${TAILNET_NAME}.ts.net`
- Seerr connects to Sonarr at `sonarr:8989`, Radarr at `radarr:7878`
- Prowlarr connects to FlareSolverr at `flaresolverr:8191`

### VPN Configuration (Gluetun)

Uncomment and configure your VPN provider in `.env`. Common providers: Mullvad, ProtonVPN, AirVPN, Windscribe, etc.

See the [Gluetun wiki](https://github.com/qdm12/gluetun-wiki) for provider-specific variables.

### Ports

| Port | Service | Protocol |
|------|---------|----------|
| 5055 | Seerr | HTTP |
| 7878 | Radarr | HTTP |
| 8080 | qBittorrent (via gluetun) | HTTP |
| 8989 | Sonarr | HTTP |
| 6246 | Maintainerr | HTTP |
| 8191 | FlareSolverr | HTTP |
| 9696 | Prowlarr | HTTP |

All ports are bound to `127.0.0.1` — not accessible from the local network.
