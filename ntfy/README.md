# Ntfy

Simple pub/sub notification service. Send notifications via HTTP POST requests.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Copy `.env.example` to `.env` and configure:
   - `TZ` - Timezone (optional, defaults to UTC)
   - `TS_AUTHKEY` - Your Tailscale auth key
   - `TAILNET_NAME` - Your Tailscale network name

2. Create directories:
   - `cache` - Message cache
   - `config` - Configuration files

3. Create external network: `docker network create ntfy_default`

4. Start: `docker compose up -d`

## Access

- Via Tailscale: https://ntfy.<TAILNET_NAME>.ts.net

## Service-Specific Configuration

### Configuration File

Optional: Create `config/server.yml` for custom settings. See [official docs](https://docs.ntfy.sh/config/) for options.

Example `server.yml`:
```yaml
base-url: "https://ntfy.yourdomain.com"
auth-file: "/var/lib/ntfy/user.db"
auth-default-access: deny-all
behind-proxy: true
```

### Volumes

Hardcoded to my server setup:
- `/srv/docker/data/ntfy/cache` - Message cache
- `/srv/docker/data/ntfy/config` - Configuration files

**To make portable:** Change to relative paths in docker-compose.yml.

### Network

This service uses `network_mode: service:tailscale` - ntfy shares Tailscale's network namespace and is only accessible via Tailscale, not directly via host ports.

### Sending Notifications

```bash
# Send a notification to topic "mytopic"
curl -d "Hello World" http://ntfy.yournet.ts.net/mytopic

# With priority
curl -d "Urgent!" -H "Priority: urgent" http://ntfy.yournet.ts.net/mytopic

# With authentication
curl -d "Hello" -u username:password http://ntfy.yournet.ts.net/mytopic
```

### Tailscale

- Container: `ntfy-ts`
- Hostname: `ntfy`

### Ports

| Port | Service |
|------|---------|
| None | Accessible via Tailscale only |
