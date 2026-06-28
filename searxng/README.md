# SearXNG

Privacy-respecting metasearch engine that aggregates results from multiple search engines while removing trackers.

I opted to use the [oaklight/searxng image](https://hub.docker.com/r/oaklight/searxng) to make use of the [BM25 Reranking Plugin](https://docs.searxng.org/admin/settings/settings_plugins.html#external-plugins), which should provide higher quality results.

## Quick Start

1. Copy `.env.example` to `.env` and configure:
   - `SEARXNG_SECRET_KEY` - Generate with `openssl rand -hex 32`

2. Start: `docker compose up -d`

## Access

- Via NetBird: https://search.server.netbird.cloud

## Service-Specific Configuration

### Required Files

The `config/settings.yml` file is mounted from the host at `/srv/docker/data/searxng/config/settings.yml`. You can change this, and mount the settings.yml file from wherever you want to store it on your machine.

To create the initial settings file:
```bash
mkdir -p /srv/docker/data/searxng/config
cp config/settings.yml /srv/docker/data/searxng/config/settings.yml
```

### Configuration

See all configuration options at the [official docs](https://docs.searxng.org/admin/settings/index.html). I've provided my configuration which (from my limited testing), seem to provide the best results.

### Data Storage

- `searxng_data` - Cache and temporary data

### Ports

SearXNG runs on port 8080, proxied through Caddy on the host.

| Port | Service |
|------|---------|
| 8080 | HTTP / Caddy upstream |
