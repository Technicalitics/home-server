# Donetick

Open-source todo list application with gamification and badge system.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Copy `.env.example` to `.env` and configure:
   - `TS_AUTHKEY` - Your Tailscale auth key
   - `TAILNET_NAME` - Your Tailscale network name

2. Create external network: `docker network create donetick_default`

3. Start: `docker compose up -d`

## Access

- Web UI: http://localhost:2021

## Service-Specific Configuration

### Configuration File

Donetick requires a `selfhosted.yaml` config file in the config directory. This file should be mounted at `/config/selfhosted.yaml` inside the container.

The config directory is mapped to `/srv/docker/data/donetick/config` on the host.

**To make portable:** Change volume paths to relative paths in docker-compose.yml.

### Environment Variables

You can override config keys using `DT_` prefix. For example:
- `DT_AUTH_JWT_SECRET` - JWT secret for authentication
- `DT_DATABASE_URL` - Database connection string

See [Donetick documentation](https://donetick.app) for all configuration options.

### Data Storage

- `/srv/docker/data/donetick/data` - SQLite database
- `/srv/docker/data/donetick/config` - Configuration files

### Tailscale

- Container: `donetick-ts`
- Hostname: `tasks`

### Ports

| Port | Service |
|------|---------|
| 2021 | HTTP |
