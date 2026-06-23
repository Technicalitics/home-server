# Pinepods

Complete podcast management system. Play, download, and keep track of your favorite podcasts.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Copy `.env.example` to `.env` and configure:
   - Database credentials
   - Admin user account

2. Create directories:
   - `pgdata` - PostgreSQL data
   - `valkey` - Valkey cache
   - `backups` - Backup location
   - `downloads` - Download location

   **Note:** The paths shown below are specific to this server's ZFS pool mounted outside the OS drive. Customize these paths to match your own setup.

3. Fix permissions for hardened images (required before first start):
   This service uses Docker Hardened Images (`dhi.io`) which run as non-root users:

   | Service | Image | User | UID | Directory |
   |---------|-------|------|-----|----------|
   | PostgreSQL | `dhi.io/postgres:17-alpine3.22` | postgres | 70 | Your PostgreSQL data path |
   | Valkey | `dhi.io/valkey:9` | nonroot | 65532 | Your Valkey data path |

   **For the default paths in this setup:**
   ```bash
   # PostgreSQL (UID 70)
   sudo chown -R 70:70 /mnt/media/podcasts/pinepods/pgdata

   # Valkey (UID 65532)
   sudo chown -R 65532:65532 /mnt/media/podcasts/pinepods/valkey
   ```

   **To find UIDs for any hardened image:**
   ```bash
   docker run --rm dhi.io/IMAGE_NAME id
   ```

4. Start: `docker compose up -d`

## Access

- Web UI: https://podcasts.server.netbird.cloud
- Local: http://localhost:8040

## Service-Specific Configuration

### Components

- **db** - PostgreSQL 17 database
- **valkey** - Valkey (Redis fork) cache
- **pinepods** - Main application

### Volumes

Hardcoded to my server setup:
- `/mnt/media/podcasts/pinepods/pgdata` - PostgreSQL data
- `/mnt/media/podcasts/pinepods/valkey` - Valkey cache
- `/mnt/media/podcasts/pinepods/backups` - Backups
- `/mnt/media/podcasts/pinepods/downloads` - Downloads

**To make portable:** Change to relative paths in docker-compose.yml.

### Dependencies

The pinepods service depends on the database being healthy. Database health is checked via `pg_isready`.

### Ports

| Port | Service |
|------|---------|
| 8040 | HTTP |
