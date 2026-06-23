# Actual Budget

Open-source budget tracking and management application.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Create data directory: `mkdir -p data`

2. Start: `docker compose up -d`

## Access

- Web UI: https://budget.server.netbird.cloud
- Local: http://localhost:5006

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
