# Jellyfin

Free and open-source media server for streaming movies, TV shows, music, and photos.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Copy `.env.example` to `.env` and configure `TZ`.

2. Start: `docker compose up -d`

## Access

- Web UI: https://media.server.netbird.cloud
- Local: http://localhost:8096

## Service-Specific Configuration

### Volume Paths

Hardcoded to my server setup:
- `/srv/docker/data/jellyfin/config` - Application configuration
- `/srv/docker/data/jellyfin/cache` - Transcoding cache
- `/mnt/media/movies` - Movie library (read-only)
- `/mnt/media/music` - Music library (read-only)

**To make portable:** Change to relative paths in docker-compose.yml.

### Hardware Acceleration

Container has access to `/dev/dri/renderD128` for GPU-accelerated transcoding. Remove `devices` section if not needed.
