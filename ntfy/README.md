# Ntfy

Simple pub/sub notification service. Send notifications via HTTP POST requests.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Copy `.env.example` to `.env` and configure `TZ` (optional).

2. Create directories:
   - `cache` - Message cache
   - `config` - Configuration files

3. Start: `docker compose up -d`

## Access

- Web UI: https://ntfy.server.netbird.cloud

## Service-Specific Configuration

### Configuration File

Optional: Create `config/server.yml` for custom settings. See [official docs](https://docs.ntfy.sh/config/) for options.

Example `server.yml`:
```yaml
base-url: "https://ntfy.server.netbird.cloud"
auth-file: "/var/lib/ntfy/user.db"
auth-default-access: deny-all
behind-proxy: true
```

### Volumes

Hardcoded to my server setup:
- `/srv/docker/data/ntfy/cache` - Message cache
- `/srv/docker/data/ntfy/config` - Configuration files

**To make portable:** Change to relative paths in docker-compose.yml.

### Sending Notifications

```bash
# Send a notification to topic "mytopic"
curl -d "Hello World" https://ntfy.server.netbird.cloud/mytopic

# With priority
curl -d "Urgent!" -H "Priority: urgent" https://ntfy.server.netbird.cloud/mytopic

# With authentication
curl -d "Hello" -u username:password https://ntfy.server.netbird.cloud/mytopic
```
