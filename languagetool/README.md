# LanguageTool

Open-source grammar, style, and spell checker. Self-hosted alternative to Grammarly.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Copy `.env.example` to `.env` and configure:
   - `TS_AUTHKEY` - Your Tailscale auth key
   - `TAILNET_NAME` - Your Tailscale network name

2. Create directories:
   - `fasttext` - FastText models
   - `ngrams` - N-gram data for better suggestions

3. Start: `docker compose up -d`

## Access

- Via Tailscale: https://languagetool.<TAILNET_NAME>.ts.net/v2

## Service-Specific Configuration

### Network

This service uses `network_mode: service:tailscale` - LanguageTool shares Tailscale's network namespace and is only accessible via Tailscale, not directly via host ports.

### Volumes

Hardcoded to my server setup:
- `/srv/docker/data/languagetool/fasttext` - FastText models
- `/srv/docker/data/languagetool/ngrams` - N-gram data

**To make portable:** Change to relative paths in docker-compose.yml.

### Environment Variables

Key configuration:
- `download_ngrams_for_langs` - Languages to download ngrams for (default: en,de)
- `JAVA_XMX` - Maximum Java heap size (default: 2048m)
- `JAVA_XMS` - Minimum Java heap size (default: 512m)
- `LISTEN_PORT` - Port to listen on (default: 8081)

### Usage

Test the API:
```bash
curl -d "language=en-US&text=a simple test" https://languagetool.<TAILNET_NAME>.ts.net/v2/check
```

### Browser Integration

Configure LanguageTool browser extension to use your self-hosted instance:
- Set API server to: `https://languagetool.<TAILNET_NAME>.ts.net/v2`

### Tailscale

- Container: `languagetool-ts`
- Hostname: `languagetool`

### Ports

| Port | Service |
|------|---------|
| None | Accessible via Tailscale only |
