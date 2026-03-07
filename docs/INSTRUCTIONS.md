# Setup Instructions

Common instructions for all services in this repository.

## Quick Start

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` with your configuration (see service README for required variables).

3. Create the external network (if required):
   ```bash
   docker network create <service>_default
   ```

4. Start the service:
   ```bash
   docker compose up -d
   ```

## Environment Variables

Copy `.env.example` to `.env` and configure:
- `TS_AUTHKEY` - Your Tailscale auth key (optional)
- `TAILNET_NAME` - Your Tailscale network name (optional)
- Service-specific variables (see each service's README)

Generate secure passwords with:
```bash
openssl rand -base64 30
```

## Tailscale Integration

Most services include a Tailscale container for VPN access:
- Container: `<service>-ts`
- Automatically connects on startup
- Hostname follows pattern (see service README)

**To disable:** Remove the `tailscale` service from `docker-compose.yml`.

## Volume Paths

Services use hardcoded paths for my server setup:
- `/srv/docker/data/<service>` - Application data
- `/mnt/media/*` - Media libraries (read-only)

**To make portable:** Change to relative paths in docker-compose.yml:
```yaml
volumes:
  - ./data:/data:z
```

## External Networks

Some services use an external network (`<service>_default`) for inter-service communication.

**To use default bridge network:** Remove the `networks` section from docker-compose.yml.

## SELinux

Volume mounts use `:z` or `:Z` suffixes for SELinux labeling. Remove on systems without SELinux (standard Ubuntu/Debian).

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

## Ports

Refer to each service's README for specific port mappings.
