# Authentik

Identity provider and single sign-on solution for self-hosted applications.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Copy `.env.example` to `.env` and configure:
   - `PG_PASS` - PostgreSQL password
   - `AUTHENTIK_SECRET_KEY` - Authentik secret
   - `TS_AUTHKEY` - Your Tailscale auth key
   - `TAILNET_NAME` - Your Tailscale network name

2. Start: `docker compose up -d`

## Access

- Web UI: http://localhost:9000
- API: https://localhost:9443

## Service-Specific Configuration

### Volume Paths

Hardcoded to my server setup:
- `/srv/docker/data/authentik/certs` - SSL certificates
- `/srv/docker/data/authentik/data` - Application data
- `/srv/docker/data/authentik/custom-templates` - Custom templates

**To make portable:** Change to relative paths in docker-compose.yml.

### Tailscale

- Container: `authentik-ts`
- Hostname: `auth`

### Running as Root

The worker container runs as root because it needs to manage certificates and interact with the Docker socket.

### Ports

| Port | Service |
|------|---------|
| 9000 | HTTP |
| 9443 | HTTPS |
