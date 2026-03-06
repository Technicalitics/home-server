# Authentik

Identity provider and single sign-on solution for self-hosted applications.

## Quick Start

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` with your configuration:
   - `PG_PASS` - PostgreSQL password (generate: `openssl rand -base64 30`)
   - `AUTHENTIK_SECRET_KEY` - Authentik secret (generate: `openssl rand -base64 60`)
   - `TS_AUTHKEY` - Your Tailscale auth key
   - `TAILNET_NAME` - Your Tailscale network name

3. Start the service:
   ```bash
   docker compose up -d
   ```

## Access

- Web UI: http://localhost:9000
- API: https://localhost:9443

## Configuration Notes

### Volume Paths

The following paths are hardcoded to my server setup:
- `/srv/docker/data/authentik/certs` - SSL certificates
- `/srv/docker/data/authentik/data` - Application data
- `/srv/docker/data/authentik/custom-templates` - Custom templates

**To make portable:** Change these to relative paths:
```yaml
volumes:
  - ./data/certs:/certs:Z
  - ./data:/data:z
```

### Tailscale Integration

This stack includes Tailscale to expose Authentik via WireGuard VPN:
- Container: `authentik-ts`
- Connects automatically on startup
- Hostname on tailnet: `auth`

**To disable:** Remove the `tailscale` service from `docker-compose.yml`.

### SELinux Labels

The `:z` and `:Z` suffixes on volumes enable SELinux labeling. Remove on systems without SELinux (e.g., standard Ubuntu/Debian without enforced SELinux).

### Running as Root

The worker container runs as root (`user: "root"`) because:
1. It needs to manage certificates in `/certs`
2. It interacts with Docker socket for container management
3. Authentik's proxy service requires it

### Ports

| Port | Service |
|------|---------|
| 9000 | HTTP (main UI) |
| 9443 | HTTPS (API) |

Customize with environment variables or port mappings in docker-compose.

## Troubleshooting

```bash
# View logs
docker compose logs -f

# Check status
docker compose ps

# Restart
docker compose restart

# Stop and remove volumes (WARNING: loses all data)
docker compose down -v
```
