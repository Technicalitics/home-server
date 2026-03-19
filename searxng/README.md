# SearXNG

Privacy-respecting metasearch engine that aggregates results from multiple search engines while removing trackers.

## Quick Start

1. Copy `.env.example` to `.env` and configure:
   - `SEARXNG_SECRET_KEY` - Generate with `openssl rand -hex 32`
   - `TS_AUTHKEY` - Your Tailscale auth key
   - `TAILNET_NAME` - Your Tailscale network name

2. Create external network: `docker network create searxng_default`

3. Start: `docker compose up -d`

## Access

- Via Tailscale: https://search.<TAILNET_NAME>.ts.net

## Service-Specific Configuration

### Required Files

The `config/settings.yml` file is mounted from the host at `/srv/docker/data/searxng/config/settings.yml`. This allows portable configuration while maintaining your custom settings across deployments.

To create the initial settings file:
```bash
mkdir -p /srv/docker/data/searxng/config
cp config/settings.yml /srv/docker/data/searxng/config/settings.yml
```

### Configuration

Key settings in `settings.yml`:

- **Engines**: Configured to use only privacy-respecting search engines (no Google, Bing, etc.)
- **Theme**: Dark mode by default
- **Safe Search**: Moderate (configurable in search preferences)
- **Base URL**: Set via `SEARXNG_BASE_URL` environment variable

### Enabled Search Engines

Privacy-focused engines only:
- Brave Search, Mojeek (independent indexes)
- DuckDuckGo, Qwant, Ecosia, MetaGer (privacy-respecting)
- Wikipedia, Wikidata, GitHub, Arch Wiki (reference/developer)
- Marginalia, Wiby (privacy-focused indexers)
- Searx, YaCy (decentralized/self-hosted)
- Invidious (YouTube via your self-hosted instance)

### Data Storage

- `searxng_data` - Cache and temporary data
- `tailscale_state` - Tailscale state

### Tailscale

- Container: `searxng-ts`
- Hostname: `search`

### Ports

SearXNG runs internally on port 8080, accessible only via Tailscale HTTPS.

| Port | Service |
|------|---------|
| 8080 | HTTP (Tailscale-only) |

### Healthchecks

- HTTP health endpoint check at `/healthz`
