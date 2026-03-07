# Immich

Self-hosted photo and video management solution with machine learning features.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Copy `.env.example` to `.env` and configure:
   - `UPLOAD_LOCATION` - Path to your photos library
   - `DB_DATA_LOCATION` - Path for PostgreSQL data
   - `DB_PASSWORD` - Database password
   - `TS_AUTHKEY` - Your Tailscale auth key (optional)
   - `TAILNET_NAME` - Your Tailscale network name (optional)

2. Create external network: `docker network create immich_default`

3. Start: `docker compose up -d`

## Access

- Web UI: http://localhost:2283

## Service-Specific Configuration

### Volume Paths

Configured via `.env`:
- `${UPLOAD_LOCATION}` - Your photo library
- `${DB_DATA_LOCATION}` - PostgreSQL data

**To make portable:** Use relative paths in `.env`:
```bash
UPLOAD_LOCATION=./photos
DB_DATA_LOCATION=./postgres
```

### Tailscale

- Container: `ts-immich`
- Hostname: `images`

### Machine Learning

The `immich-machine-learning` container provides facial recognition, object detection, and image similarity search. Model cache is stored in the `model-cache` volume.

### Ports

| Port | Service |
|------|---------|
| 2283 | HTTP |
