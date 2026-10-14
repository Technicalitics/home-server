# Actual Budget

Open-source budget tracking and management application.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Customize volumes section to the location of the data directory you want

2. Create data directory: `mkdir -p data`

3. Start: `docker compose up -d`

## Access

- Web UI: https://budget.server.netbird.cloud

## Service-Specific Configuration

### Volume Paths

Hardcoded to my server setup:
- `/srv/docker/data/actual_budget/actual-data` - Budget data

**To make portable:** Change to relative path `./data` in docker-compose.yml.

The server will create `server-files` and `user-files` subdirectories in the data folder.
