# SparkyFitness

Self-hosted fitness tracking application. Alternative to MyFitnessPal with nutrition, exercise, water intake, and body measurements tracking.

## Quick Start

1. Copy `.env.example` to `.env` and configure:
   - Generate secrets with `openssl rand -hex 32`
   - Set up Authentik OAuth provider (see below)
   - Configure Tailscale variables

2. Create external network: `docker network create sparkyfitness_default`

3. Create data directories:
   ```bash
   mkdir -p /srv/docker/data/sparkyfitness/{postgresql,backup,uploads}
   ```

4. Start: `docker compose up -d`

## Access

- Via Tailscale: https://fit.<TAILNET_NAME>.ts.net

## Service-Specific Configuration

### Authentik OIDC Setup

1. In Authentik, create an OAuth2 Provider:
   - **Name**: SparkyFitness
   - **Slug**: sparky-fitness
   - **Redirect URIs**: `https://fit.<TAILNET_NAME>.ts.net/api/auth/callback/oidc`
   - **Signing Key**: default
   - **Client ID**: Copy to `SPARKY_FITNESS_OIDC_CLIENT_ID`
   - **Client Secret**: Copy to `SPARKY_FITNESS_OIDC_CLIENT_SECRET`

2. Create an Application pointing to this provider

### Data Storage

- `/srv/docker/data/sparkyfitness/postgresql` - PostgreSQL database
- `/srv/docker/data/sparkyfitness/backup` - Server backups
- `/srv/docker/data/sparkyfitness/uploads` - Profile pictures, exercise images
- `tailscale_state` - Tailscale state

### Tailscale

- Container: `sparkyfitness-ts`
- Hostname: `fit`

### Ports

| Port | Service |
|------|---------|
| 3004 | HTTP (localhost only) |

### Features

- Nutrition tracking with barcode scanning
- Exercise logging
- Water intake tracking
- Body measurements
- AI chatbot (requires Ollama)
- Family sharing
- Garmin Connect integration (optional)
