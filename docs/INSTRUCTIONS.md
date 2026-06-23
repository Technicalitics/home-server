# Setup Instructions

Common instructions for all services in this repository.

## Quick Start

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` with your configuration (see service README for required variables).

3. Start the service:
   ```bash
   docker compose up -d
   ```

## Environment Variables

Copy `.env.example` to `.env` and configure service-specific variables (see each service's README).

Generate secure passwords with:
```bash
openssl rand -base64 30
```

## Volume Paths

Services use hardcoded paths for my server setup:
- `/srv/docker/data/<service>` - Application data
- `/mnt/media/*` - Media libraries (read-only)

**To make portable:** Change to relative paths in docker-compose.yml:
```yaml
volumes:
  - ./data:/data:z
```

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
