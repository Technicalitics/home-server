# Neko

A self-hosted virtual browser that runs in Docker and uses WebRTC technology. Access a full browser instance from any device with a browser - no software installation required.

## Quick Start

1. Copy `.env.example` to `.env`
2. Edit `.env` with your values:
   - `SERVER_TAILNET_IP`: Your host machine's Tailscale IP address
   - `ADMIN_PASSWORD`: Password for admin access
   - `USER_PASSWORD`: Password for regular user access
   - `TS_AUTHKEY`: Your Tailscale auth key
   - `TAILNET_NAME`: Your Tailscale network name
3. Run `docker compose up -d`

## Access

| Method | URL |
|--------|-----|
| Tailscale | https://neko.`${TAILNET_NAME}`.ts.net |

## Volume Paths

| Host Path | Description |
|-----------|-------------|
| `/srv/docker/data/neko/settings/` | Firefox profile and settings |
| `/srv/docker/data/neko/policy.json` | Browser policy configuration |

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `SERVER_TAILNET_IP` | Host machine's Tailscale IP for WebRTC NAT traversal | Yes |
| `ADMIN_PASSWORD` | Password for admin control | Yes |
| `USER_PASSWORD` | Password for regular user access | Yes |
| `TS_AUTHKEY` | Tailscale authentication key | Yes |
| `TAILNET_NAME` | Your Tailscale tailnet name | Yes |
| `NEKO_DESKTOP_SCREEN` | Display resolution and refresh rate | No (default: 1920x1080@60) |
| `NEKO_WEBRTC_EPR` | WebRTC ephemeral port range | No (default: 56000-56100) |

## Tailscale

- **Container name**: `neko-ts`
- **Hostname**: `neko`
- **WebRTC ports**: 56000-56100/UDP (exposed on host)

## Browser Options

This setup uses Firefox. Other browser images available:

| Browser | Image |
|---------|-------|
| Chromium | `ghcr.io/m1k1o/neko/chromium` |
| Brave | `ghcr.io/m1k1o/neko/brave` |
| Chrome | `ghcr.io/m1k1o/neko/google-chrome` |
| Tor Browser | `ghcr.io/m1k1o/neko/tor-browser` |

## Hardware Requirements

| Resolution | Cores | RAM | Performance |
|------------|-------|-----|-------------|
| 1024x576@30 | 2 | 2GB | Not Recommended |
| 1280x720@30 | 4 | 3GB | Good |
| 1280x720@30 | 6 | 4GB | Recommended |

## Documentation

Full documentation available at [neko.m1k1o.net](https://neko.m1k1o.net/docs/v3/introduction)
