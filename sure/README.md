# Sure

Open-source personal finance app for managing, tracking, and budgeting

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Customize volumes section to the location of the data directory you want

2. Create storage directory: `mkdir -p storage`

3. Start: `docker compose up -d`

## Access

- Web UI: https://budget.server.netbird.cloud

## Service-Specific Configuration

### Volume Paths

Hardcoded to my server setup:
- `/srv/docker/data/sure/storage` - Sure's storage directory

**To make portable:** Change to relative path `./storage` in docker-compose.yml.

### AI-related

