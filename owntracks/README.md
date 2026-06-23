# OwnTracks

Self-hosted location tracking with OwnTracks. Track your devices' locations privately.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Copy `.env.example` to `.env` and configure:
   - `OTR_USER` - Username for recorder
   - `OTR_PASS` - Password for recorder

2. Create required directories:
   - `mosquitto/config`, `mosquitto/data`, `mosquitto/log`
   - `recorder/config`, `recorder/store`

3. Start: `docker compose up -d`

## Access

- Web UI: https://tracks.server.netbird.cloud
- Local: http://localhost:8085

## Service-Specific Configuration

### Components

- **mqtt** - Eclipse Mosquitto MQTT broker
- **frontend** - OwnTracks web interface
- **recorder** - Stores location data

### Volumes

Hardcoded to my server setup:
- `/srv/docker/data/owntracks/mosquitto/config` - MQTT config
- `/srv/docker/data/owntracks/mosquitto/data` - MQTT data
- `/srv/docker/data/owntracks/mosquitto/log` - MQTT logs
- `/srv/docker/data/owntracks/recorder/config` - Recorder config
- `/srv/docker/data/owntracks/recorder/store` - Location data storage

**To make portable:** Change to relative paths in docker-compose.yml.

### Recorder Configuration

Key environment variables:
- `OTR_HOST` - MQTT broker hostname (default: mqtt)
- `OTR_PORT` - MQTT port (default: 1883)
- `OTR_TOPIC` - MQTT topic to subscribe to (default: owntracks/#)
- `OTR_STORAGEDIR` - Where to store data (default: /store)

### Ports

| Port | Service |
|------|---------|
| 8085 | Frontend HTTP (proxied by Caddy) |
| 1883 | MQTT (internal) |
| 8083 | Recorder HTTP (internal) |

### SmartPhone Configuration

Configure the OwnTracks app on your phone:
- Mode: MQTT
- Host: Your NetBird hostname
- Port: 8883 (with TLS) or 1883 (without TLS)
- Username: `OTR_USER` from .env
- Password: `OTR_PASS` from .env
- Tracker ID: Unique identifier for your device
