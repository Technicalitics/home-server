# Immich

Self-hosted photo and video management solution with machine learning features.

## Quick Start

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` with your configuration:
   - `UPLOAD_LOCATION` - Path to your photos library
   - `DB_DATA_LOCATION` - Path for PostgreSQL data
   - `DB_PASSWORD` - Database password
   - `DB_USERNAME` - Database username
   - `DB_DATABASE_NAME` - Database name
   - `TS_AUTHKEY` - Your Tailscale auth key (optional)
   - `TAILNET_NAME` - Your Tailscale network name (optional)

3. Create the external network (if not exists):
   ```bash
   docker network create immich_default
   ```

4. Start the service:
   ```bash
   docker compose up -d
   ```

## Access

- Web UI: http://localhost:2283

## Configuration Notes

### Volume Paths

The following paths are configured via `.env`:
- `${UPLOAD_LOCATION}` - Your photo library (e.g., `/mnt/storage/photos`)
- `${DB_DATA_LOCATION}` - PostgreSQL data directory

**To make portable:** Use relative paths or create a `.env` with local paths:
```bash
UPLOAD_LOCATION=./photos
DB_DATA_LOCATION=./postgres
```

### External Network

This stack uses an external network (`immich_default`). This allows Immich to communicate with other services on your network.

**To use default bridge network:** Remove the `networks` section from docker-compose.yml.

### Tailscale Integration

This stack includes Tailscale to expose Immich via WireGuard VPN:
- Container: `ts-immich`
- Hostname on tailnet: `images`

**To disable:** Remove the `tailscale` service from `docker-compose.yml`.

### Machine Learning

The `immich-machine-learning` container provides:
- Facial recognition
- Object detection
- Image similarity search

Model cache is stored in the `model-cache` volume.

### Ports

| Port | Service |
|------|---------|
| 2283 | HTTP (main UI) |

### Image Versions

- Server: `${IMMICH_VERSION:-release}` (stable release by default)
- Database: Pinned with specific versions of extensions (vectorchord, pgvectors)
- Redis: Pinned valkey image with SHA256 for reproducibility

## Services

| Service | Description |
|---------|-------------|
| immich-server | Main application |
| immich-machine-learning | ML processing |
| redis | Caching layer |
| database | PostgreSQL with vector extensions |
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
