# Home Server Configuration

Documentation of my self-hosted home server stack using Docker Compose.

**WARNING:** This repository contains configuration files with hardcoded paths specific to my setup. Do not attempt to clone and run directly - use this repo as a reference.

## Services

| Service | Description | Port |
|---------|-------------|------|
| [authentik](authentik/README.md) | Identity provider & SSO | 9000, 9443 |
| [immich](immich/README.md) | Photo & video management | 2283 |
| [jellyfin](jellyfin/README.md) | Media server | 8096, 8920 |
| [donetick](donetick/README.md) | Todo list with badges | 2021 |
| [invidious](invidious/README.md) | YouTube front-end | 3000 |

## Repository Structure

```
.
├── authentik/           # Authentik identity provider
│   ├── docker-compose.yml
│   ├── .env.example
│   └── README.md
├── immich/              # Immich photo management
│   ├── docker-compose.yml
│   .env.example
│   └── README.md
├── jellyfin/            # Jellyfin media server
│   ├── docker-compose.yml
│   ├── .env.example
│   └── README.md
├── donetick/            # Donetick todo with badges
│   ├── docker-compose.yml
│   ├── .env.example
│   ├── config/
│   │   └── selfhosted.yaml
│   └── README.md
├── invidious/           # Invidious YouTube frontend
│   ├── docker-compose.yml
│   ├── .env.example
│   └── README.md
└── docs/                # Shared documentation
    └── INSTRUCTIONS.md
```

## Prerequisites

- Docker Engine 20.10+
- Docker Compose v2+
- Tailscale (optional, for VPN access)

## Setup

1. Clone this repository
2. For each service:
   - Copy `.env.example` to `.env`
   - Edit `.env` with your values
   - Run `docker compose up -d`

See [docs/INSTRUCTIONS.md](docs/INSTRUCTIONS.md) for common setup details and [individual service READMEs](*/README.md) for service-specific configuration.

## Security Notes

- **Never commit `.env` files** - they contain secrets
- `.gitignore` is configured to exclude environment files
- Use strong passwords and auth keys
- Keep Docker images updated
- Review container permissions regularly

## Backup

This repository serves as a backup of my working docker compose configurations. To restore a docker-compose.yml file:
1. Clone the repository
2. Recreate your `.env` files from `.env.example`
3. Start services with `docker compose up -d`

## License

MIT - feel free to use as reference, but understand the hardcoded paths and secrets will need to be adjusted for your use-case.
