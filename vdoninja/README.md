# VDO.Ninja

Free, open-source tool for peer-to-peer video streaming. No account needed, works in-browser.

## Quick Start

1. Start: `docker compose up -d`

## Access

- Web UI: https://vdo.server.netbird.cloud

## Service-Specific Configuration

### About

VDO.Ninja creates peer-to-peer video connections when there are only 2-3 people in a call. For larger meetings, it uses a room-style connection to manage bandwidth efficiently.

### Data Storage

- `vdoninja_data` - Persistent data (temporary streams, settings)

### WebRTC

VDO.Ninja uses WebRTC for video/audio streaming. The connection is established peer-to-peer when possible, reducing server bandwidth usage. For larger audiences, a TURN server may be needed.
