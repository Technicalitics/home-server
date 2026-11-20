# Monitoring

A self-hosted observability stack (Prometheus + Loki + Grafana) with Grafana Alloy for log collection, plus node_exporter, blackbox_exporter, and a NetBird sidecar.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Components

- **Grafana** - Dashboards, log search, and alerting (web UI)
- **Prometheus** - Metrics database and scraper
- **Loki** - Log aggregation
- **Alloy** - Collects Docker container logs and host logs into Loki
- **node_exporter** - Host (CPU, memory, disk, network) metrics
- **cAdvisor** - Per-container CPU, memory, network, and filesystem metrics
- **blackbox_exporter** - Synthetic endpoint probes (shares the NetBird network namespace)
- **netbird** - Mesh sidecar; exposes blackbox_exporter on the tailnet

## Quick Start

1. Copy `.env.example` to `.env` and set `GRAFANA_ADMIN_PASSWORD`:
   ```bash
   cp .env.example .env
   ```

2. Create data directories and fix ownership (required for Prometheus/Loki/Grafana):
   ```bash
   sudo mkdir -p /srv/docker/data/monitoring/{prometheus,loki,grafana,alloy}
   sudo chown -R 65534:65534 /srv/docker/data/monitoring/prometheus
   sudo chown -R 10001:10001 /srv/docker/data/monitoring/loki
   sudo chown -R 472:472 /srv/docker/data/monitoring/grafana
   ```

3. Start the stack:
   ```bash
   docker compose pull
   docker compose up -d
   ```
   Use `up -d` (not `restart`) after changing an image tag or environment:
   `restart` reuses the existing container and keeps the old image.

4. (Optional) Apply Caddy reverse proxy changes (see below) and reload Caddy.

## Access

- Grafana UI: https://grafana.server.netbird.cloud (or http://localhost:3001)
- Prometheus: http://localhost:9090 (internal only)
- Loki: http://localhost:3100 (internal only)
- Alloy UI: http://localhost:12345 (internal only)

## Ports

| Port | Service |
|------|---------|
| 3001 | Grafana HTTP (proxied by Caddy) |
| 9090 | Prometheus (internal) |
| 3100 | Loki (internal) |
| 12345 | Alloy (internal) |
| 9100 | node_exporter (internal) |
| 8089 | cAdvisor (internal) |
| 9115 | blackbox_exporter (bound to 127.0.0.1 via the NetBird container) |

## Container metrics (cAdvisor)

Docker Engine 29 stores images with the containerd snapshotter by default, so
`docker info` reports `Storage Driver: overlayfs` and the legacy
`/var/lib/docker/image/overlay2/layerdb` tree does not exist. cAdvisor builds
before v0.55.0 then log this for every container and register none of them:

```
failed to identify the read-write layer ID for container "..."
open /rootfs/.../image/overlayfs/layerdb/mounts/<id>/mount-id: no such file or directory
```

The stack therefore pins `cadvisor:v0.55.1` (the newest gcr.io tag with
containerd-snapshotter support) and mounts `/run/containerd` so cAdvisor can
ask containerd for each container's rootfs. If the host runs the classic
`overlay2` driver instead, the mount is harmless and the legacy path is used.

## NetBird probes

The NetBird sidecar uses the `rootless` image, which runs in netstack (userspace)
mode: there is no kernel tun interface and no `100.64.0.0/10` route in the shared
network namespace. Containers that join it (`blackbox_exporter`) can reach the
Docker bridge normally, but tailnet addresses only through NetBird's built-in
SOCKS5 proxy on `127.0.0.1:1080`.

- `blackbox.yml` `https_2xx` sets `proxy_url: socks5://127.0.0.1:1080` and
  `skip_resolve_phase_with_proxy: true`, so both DNS and TCP for tailnet probes
  go through NetBird.
- `http_2xx` (grafana/loki/prometheus) deliberately has no proxy; it uses
  Docker DNS.
- The `tcp` prober has no proxy support, so raw TCP checks against tailnet
  hosts are not possible in this mode. Use the HTTPS endpoints through Caddy.
- Host-loopback TCP probes (authentik/immich/jellyfin on `127.0.0.1`) are not
  reachable from the sidecar netns at all; they are covered by the HTTPS job.
- If you later need TCP/ICMP probes against the tailnet, replace the rootless
  image with kernel-mode NetBird (`netbirdio/netbird:latest`, `NET_ADMIN`,
  `/dev/net/tun`); the SOCKS5 path is HTTP-only.

Reload the exporter after editing `blackbox.yml`:

```bash
curl -X POST http://127.0.0.1:9115/-/reload
# or: docker kill -s HUP blackbox_exporter
```

Dashboard `7587` populates its target list from
`label_values(probe_success, instance)`; no dashboard changes are needed once
the probes produce data.

## Caddy (reverse proxy) additions

Add to the `*.server.netbird.cloud` block in your Caddyfile to expose Grafana behind Authentik:

```caddy
	# ── Monitoring ────────────────────────
	@grafana host grafana.server.netbird.cloud
	handle @grafana {
		route {
			reverse_proxy /outpost.goauthentik.io/* localhost:9000
			import authentik_single_app
			reverse_proxy localhost:3001
		}
	}
```

Prometheus and Loki intentionally stay internal. Reach them via Grafana or an SSH tunnel. If you want them web-accessible later, add similar blocks behind Authentik.

## Volumes

Hardcoded to my server setup:
- `/srv/docker/data/monitoring/prometheus` - Prometheus TSDB
- `/srv/docker/data/monitoring/loki` - Loki chunks/index
- `/srv/docker/data/monitoring/grafana` - Grafana state
- `/srv/docker/data/monitoring/alloy` - Alloy state

**To make portable:** Change to relative paths in docker-compose.yml.

## Dashboards

Prometheus and Loki are auto-provisioned as Grafana data sources. Import community dashboards by ID:
- Node Exporter Full: `1860`
- cAdvisor: `14282`
- Loki logs: `13639`
- Blackbox: `7587`

## Alerting

Grafana's built-in alerting is enabled. Configure notification channels (e.g., a ntfy webhook) under
**Alerting → Contact points**. Example ntfy webhook URL: `https://ntfy.server.netbird.cloud/grafana-alerts`.

## Retention

- Prometheus: 30 days (`--storage.tsdb.retention.time=30d`)
- Loki: 31 days (`retention_period: 744h`)

Adjust in `prometheus/prometheus.yml` command and `loki/loki-config.yml`.

## Hardening for public internet

- Grafana sign-up is disabled; admin password from `.env`.
- Grafana is the only service exposed via Caddy; everything else binds to `127.0.0.1`.
- Keep `tls internal` → switch to public ACME when going live.
- Back up `/srv/docker/data/monitoring/*` regularly.
- Consider Caddy rate limiting on the Grafana host.