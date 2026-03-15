# Glance

A self-hosted dashboard that puts all your feeds in one place.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Copy `.env.example` to `.env` and configure:
   - `TS_AUTHKEY` - Your Tailscale auth key
   - `TAILNET_NAME` - Your Tailscale network name

2. Create config files:
   - `config/glance.yml` - Main configuration (download from [official docs](https://glance.github.io/configuration/))

3. Create external network: `docker network create glance_default`

4. Start: `docker compose up -d`

## Access

- Web UI: http://localhost:8080

## Service-Specific Configuration

### Configuration File

Glance requires a `glance.yml` config file in the config directory. Download the example:
```bash
wget -O config/glance.yml https://raw.githubusercontent.com/glanceapp/glance/refs/heads/main/docs/glance.yml
```

### Volumes

Hardcoded to my server setup:
- `/srv/docker/data/glance/config` - Configuration files
- `/srv/docker/data/glance/assets` - Custom assets (CSS, etc.)
- `/mnt/media` - Media files (read-only)

**To make portable:** Change to relative paths in docker-compose.yml.

### Widgets

Glance supports various widgets including:
- RSS feeds
- YouTube/Twitch videos
- Hacker News
- Reddit
- Weather
- Calendar
- Server stats (requires docker.sock)
- And more...

See [official documentation](https://glance.github.io/) for widget configuration.

### Tailscale

- Container: `glance-ts`
- Hostname: `home`

### Ports

| Port | Service |
|------|---------|
| 8080 | HTTP |
