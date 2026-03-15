# Actual Budget

Open-source budget tracking and management application.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Copy `.env.example` to `.env` and configure:
   - `TS_AUTHKEY` - Your Tailscale auth key
   - `TAILNET_NAME` - Your Tailscale network name

2. Create data directory: `mkdir -p data`

3. Create external network: `docker network create actual_budget_default`

4. Start: `docker compose up -d`

## Access

- Web UI: http://localhost:5006
- Via Tailscale: https://budget.<TAILNET_NAME>.ts.net

## Service-Specific Configuration

### Data Storage

Hardcoded to my server setup:
- `/srv/docker/data/actual_budget/actual-data` - Budget data

**To make portable:** Change to relative path `./data` in docker-compose.yml.

The server will create `server-files` and `user-files` subdirectories in the data folder.

### Features

- Envelope budgeting method
- Multi-device sync
- Bank syncing (US, Canada, UK, EU)
- Import/Export QIF and CSV
- Custom reports
- API access
- End-to-end encryption

### Tailscale

- Container: `actual-budget-ts`
- Hostname: `budget`

### Ports

| Port | Service |
|------|---------|
| 5006 | HTTP |
