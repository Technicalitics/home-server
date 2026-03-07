# Jellyfin

Free and open-source media server for streaming movies, TV shows, music, and photos.

## Quick Start

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` with your configuration:
   - `TS_AUTHKEY` - Your Tailscale auth key
   - `TAILNET_NAME` - Your Tailscale network name

3. Create the external network (if not exists):
   ```bash
   docker network create jellyfin_default
   ```

4. Start the service:
   ```bash
   docker compose up -d
   ```

## Access

- Web UI: http://localhost:8096
- HTTPS: https://localhost:8920

## Configuration Notes

### Volume Paths

The following paths are hardcoded to my server setup:
- `/srv/docker/data/jellyfin/config` - Application configuration
- `/srv/docker/data/jellyfin/cache` - Transcoding cache
- `/mnt/media/movies` - Movie library (read-only)
- `/mnt/media/music` - Music library (read-only)

**To make portable:** Change these to relative paths in docker-compose.yml.

### Hardware Acceleration

The container has access to `/dev/dri/renderD128` for GPU-accelerated transcoding. Remove the `devices` section if not needed.

### Tailscale Integration

This stack includes Tailscale to expose Jellyfin via WireGuard VPN:
- Container: `jellyfin-ts`
- Hostname on tailnet: `media`

**To disable:** Remove the `tailscale` service from docker-compose.yml.

### Ports

| Port | Service |
|------|---------|
| 8096 | HTTP (main UI) |
| 8920 | HTTPS |

## Services

| Service | Description |
|---------|-------------|
| jellyfin | Main media server |
| tailscale | VPN access |

## Troubleshooting

```bash
# View logs
docker compose logs -f

# Check status
docker compose ps

# Restart
docker compose restart

# Stop (preserves data)
docker compose down

# Stop and remove volumes (WARNING: loses all data)
docker compose down -v
```
