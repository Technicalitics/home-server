# Glance

A self-hosted dashboard that puts all your feeds in one place.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Create config files:
   - `config/glance.yml` - Main configuration (download from [official docs](https://glance.github.io/configuration/))

2. Start: `docker compose up -d`

## Access

- Web UI: https://home.server.netbird.cloud

## Service-Specific Configuration

### Configuration File

Glance requires a `glance.yml` config file in the config directory. Download the example:
```bash
wget -O config/glance.yml https://raw.githubusercontent.com/glanceapp/glance/refs/heads/main/docs/glance.yml
```


See [official documentation](https://glance.github.io/) for widget configuration.

### Volumes

Hardcoded to my server setup:
- `/srv/docker/data/glance/config` - Configuration files
- `/srv/docker/data/glance/assets` - Custom assets (CSS, etc.)
- `/mnt/media` - Media files (read-only)

**To make portable:** Change to relative paths in docker-compose.yml.
