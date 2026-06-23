# Immich

Self-hosted photo and video management solution with machine learning features.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Copy `.env.example` to `.env` and configure:
   - `UPLOAD_LOCATION` - Path to your photos library
   - `DB_DATA_LOCATION` - Path for PostgreSQL data
   - `DB_PASSWORD` - Database password

2. Start: `docker compose up -d`

## Access

- Web UI: https://images.server.netbird.cloud
- Local: http://localhost:2283

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

### Ports

| Port | Service |
|------|---------|
| 2283 | HTTP |
