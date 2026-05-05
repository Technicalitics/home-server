# VDO.Ninja

Free, open-source tool for peer-to-peer video streaming. No account needed, works in-browser.

## Quick Start

1. Copy `.env.example` to `.env` and configure:
   - `TS_AUTHKEY` - Your Tailscale auth key
   - `TAILNET_NAME` - Your Tailscale network name

2. Create external network: `docker network create vdoninja_default`

3. Start: `docker compose up -d`

4. Configure Tailscale Serve (see below)

## Access

- Via Tailscale: https://vdo.<TAILNET_NAME>.ts.net

## Service-Specific Configuration

### About

VDO.Ninja creates peer-to-peer video connections when there are only 2-3 people in a call. For larger meetings, it uses a room-style connection to manage bandwidth efficiently.

### Tailscale Serve Setup

After starting the container, configure Tailscale to serve HTTPS:

```bash
# SSH into your server and run:
tailscale --host=vdo serve https+http://127.0.0.1:8080
```

This proxies HTTPS traffic from `https://vdo.<TAILNET_NAME>.ts.net` to the VDO.Ninja container.

To verify:
```bash
tailscale serve status
```

### Data Storage

- `vdoninja_data` - Persistent data (temporary streams, settings)
- `tailscale_state` - Tailscale state

### Tailscale

- Container: `vdoninja-ts`
- Hostname: `vdo`

### Ports

| Port | Service |
|------|---------|
| 8080 | HTTP (localhost only, proxied via Tailscale) |

### Healthchecks

- HTTP health endpoint check

### WebRTC

VDO.Ninja uses WebRTC for video/audio streaming. The connection is established peer-to-peer when possible, reducing server bandwidth usage. For larger audiences, a TURN server may be needed.
