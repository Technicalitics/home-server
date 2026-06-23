# LanguageTool

Open-source grammar, style, and spell checker. Self-hosted alternative to Grammarly.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Create directories:
   - `fasttext` - FastText models
   - `ngrams` - N-gram data for better suggestions

2. Start: `docker compose up -d`

## Access

- Web UI: https://grammar.server.netbird.cloud/v2
- Local: http://localhost:8086/v2

## Service-Specific Configuration

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
curl -d "language=en-US&text=a simple test" https://grammar.server.netbird.cloud/v2/check
```

### Browser Integration

Configure LanguageTool browser extension to use your self-hosted instance:
- Set API server to: `https://grammar.server.netbird.cloud/v2`
