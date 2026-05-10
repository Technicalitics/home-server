# NETBIRD.md — Migration from Tailscale to NetBird

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         Your Server                          │
│                                                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌─────────────┐ │
│  │ Jellyfin │  │  Immich  │  │  Glance  │  │  Authentik  │ │
│  │  :8096   │  │  :2283   │  │  :8080   │  │  :9000      │ │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └──────┬──────┘ │
│       │              │             │               │        │
│  ┌────┴──────────────┴─────────────┴───────────────┴──────┐ │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐            │ │
│  │  │  Sonarr  │  │  Radarr  │  │  Seerr   │  ...arr    │ │
│  │  │  :8989   │  │  :7878   │  │  :5055   │  stack     │ │
│  │  └────┬─────┘  └────┬─────┘  └────┬─────┘            │ │
│  │       │              │             │                   │ │
│  │  ┌────┴──────────────┴─────────────┴────────────────┐ │ │
│  │  │                  Caddy (:443)                     │ │ │
│  │  │   Routes *.server.netbird.cloud by SNI to each    │ │ │
│  │  │   TLS via `tls internal` (built-in CA)            │ │ │
│  │  └────────────────────────┬─────────────────────────┘ │ │
│  │                           │                            │
│  │  ┌────────────────────────┴─────────────────────────┐ │ │
│  │  │               NetBird Host Agent                   │ │
│  │  │  IP: 100.x.x.x  │  Extra DNS Label: "*.server"    │ │
│  │  │  Resolves as: *.server.netbird.cloud → host IP    │ │
│  │  └──────────────────────────────────────────────────┘ │ │
│  └─────────────────────────────────────────────────────────┘ │
│                                                              │
│  [Gluetun VPN] → qBittorrent (no NetBird/Caddy access)      │
└──────────────────────────────────────────────────────────────┘
                           │
              ┌────────────┴────────────┐
              │                         │
         You (NetBird client)     Friends (NetBird client)
         + trust Caddy CA         + trust Caddy CA
```

### Why this approach

| Requirement | Solution |
|---|---|
| No open ports | NetBird mesh = WireGuard tunnels, no public ports needed |
| HTTPS green lock | Caddy `tls internal` — self-signed CA, no browser warnings after CA install |
| Named URLs, no ports | `*.server.netbird.cloud` resolves via NetBird DNS (Extra DNS Labels) |
| Mesh-only, not public | All traffic stays within NetBird WireGuard mesh |
| Free | NetBird Cloud Free tier + self-hosted Caddy |
| Future self-host migration | Just change `--management-url` on agents |

### Key differences from Tailscale

| Tailscale | NetBird |
|---|---|
| Sidecar per stack | Single host agent for all services |
| `serve.json` / manual `tailscale serve` inside sidecar | Caddy reverse proxy routes by hostname |
| MagicDNS → `hostname.tailnet.ts.net` | Extra DNS Labels → `*.server.netbird.cloud` |
| Tailscale Funnel (public exposure) | N/A — mesh-only by design |
| `network_mode: service:tailscale` | Bridge network + port publishing to host |
| `cap_drop: ALL` + `NET_ADMIN` | No Docker capabilities needed (host agent) |
| Tailscale sidecar on media_network | Nothing needed — media stack already uses bridge network + localhost-only ports |

Some services expose via `serve.json`; others use manual `tailscale serve` inside the sidecar. Both are replaced by Caddy routes.


---

## Prerequisites

- A **NetBird Cloud** account (free tier, up to 5 users)
- **Setup key** generated with **"Allow Extra DNS Labels"** enabled
- **Caddy** installed on the host (not in Docker)
- **NetBird agent** installed on the host

---

## Phase 1: Install & Configure Host Agent

### 1.1 Install NetBird on the host

```bash
curl -fsSL https://github.com/netbirdio/netbird/releases/latest/download/getting-started.sh | bash
```

Or install the agent directly (see [NetBird install docs](https://docs.netbird.io/get-started/install/linux)).

### 1.2 Generate setup key

NetBird Dashboard → Peers → Setup Keys → **Add Key**:
- Enable **"Allow Extra DNS Labels"**
- Save the key

### 1.3 Register the host

```bash
netbird up --setup-key YOUR_KEY --extra-dns-labels "*.server"
```

Verify: `netbird status` — should show your peer with IP and label.

### 1.4 Configure DNS in NetBird dashboard

For peer DNS names (`*.server.netbird.cloud`) to resolve on **all platforms** (macOS, Windows, iOS, Android), NetBird needs to manage DNS on every peer. Add a primary nameserver:

1. NetBird Dashboard → **DNS** → **Nameservers**
2. Click **Add Nameserver**
3. Leave match domains **blank** (makes it the catch-all/primary)
4. Enter `1.1.1.1` (or any public DNS)
5. Set **Distribution Groups** → `All`
6. Save

This makes every peer use NetBird's local resolver for `*.netbird.cloud` and forward everything else to `1.1.1.1`. Friends do **zero DNS configuration** — it's automatic.

**Android gotcha:** Android's built-in **Private DNS** (DNS-over-TLS) setting bypasses NetBird's resolver. Tell friends with Android devices to go to **Settings → Network & Internet → Private DNS** and set it to **Off**.

### 1.5 Confirm DNS resolution

From any NetBird peer (that's been restarted since the nameserver was added):
```bash
ping jellyfin.server.netbird.cloud
```
Should resolve to your host's NetBird IP.

---

## Phase 2: Install & Configure Caddy

### 2.1 Install Caddy

```bash
sudo apt install caddy  # or official script: caddyserver.com/download
```

### 2.2 Create Caddyfile

```caddy
# /etc/caddy/Caddyfile

*.server.netbird.cloud {
    tls internal

    # ── Identity ──────────────────────────
    @authentik host auth.server.netbird.cloud
    handle @authentik {
        reverse_proxy localhost:9000
    }

    # ── Media Server ──────────────────────
    @jellyfin host media.server.netbird.cloud
    handle @jellyfin {
        reverse_proxy localhost:8096
    }

    # ── Photos ────────────────────────────
    @immich host images.server.netbird.cloud
    handle @immich {
        reverse_proxy localhost:2283
    }

    # ── Dashboard ─────────────────────────
    @glance host home.server.netbird.cloud
    handle @glance {
        reverse_proxy localhost:8080
    }

    # ── Notifications ─────────────────────
    @ntfy host ntfy.server.netbird.cloud
    handle @ntfy {
        reverse_proxy localhost:80
    }

    # ── YouTube frontend ──────────────────
    @invidious host youtube.server.netbird.cloud
    handle @invidious {
        reverse_proxy localhost:3000
    }

    # ── Search ────────────────────────────
    @searxng host search.server.netbird.cloud
    handle @searxng {
        reverse_proxy localhost:8080
    }

    # ── Tasks ─────────────────────────────
    @donetick host tasks.server.netbird.cloud
    handle @donetick {
        reverse_proxy localhost:2021
    }

    # ── Podcasts ──────────────────────────
    @pinepods host podcasts.server.netbird.cloud
    handle @pinepods {
        reverse_proxy localhost:8080
    }

    # ── Location tracking ─────────────────
    @owntracks host tracks.server.netbird.cloud
    handle @owntracks {
        reverse_proxy localhost:8080
    }

    # ── Budget ────────────────────────────
    @actual host budget.server.netbird.cloud
    handle @actual {
        reverse_proxy localhost:5006
    }

    # ── Grammar ───────────────────────────
    @languagetool host grammar.server.netbird.cloud
    handle @languagetool {
        reverse_proxy localhost:8010
    }

    # ── Gaming ────────────────────────────
    @crafty host crafty.server.netbird.cloud
    handle @crafty {
        reverse_proxy localhost:8443
    }

    @neko host neko.server.netbird.cloud
    handle @neko {
        reverse_proxy localhost:8080
    }

    # ── Video streaming ───────────────────
    @vdoninja host vdo.server.netbird.cloud
    handle @vdoninja {
        reverse_proxy localhost:80
    }

    # ── Collaborative docs ────────────────
    @cryptpad host cloud.server.netbird.cloud
    handle @cryptpad {
        reverse_proxy localhost:3000
    }

    # ── Media stack (*arr) ────────────────
    # These already bind to 127.0.0.1 only (via gluetun or direct publish)
    @seerr host requests.server.netbird.cloud
    handle @seerr {
        reverse_proxy localhost:5055
    }

    @sonarr host sonarr.server.netbird.cloud
    handle @sonarr {
        reverse_proxy localhost:8989
    }

    @radarr host radarr.server.netbird.cloud
    handle @radarr {
        reverse_proxy localhost:7878
    }

    @prowlarr host prowlarr.server.netbird.cloud
    handle @prowlarr {
        reverse_proxy localhost:9696
    }

    @maintainerr host maintainerr.server.netbird.cloud
    handle @maintainerr {
        reverse_proxy localhost:6246
    }
}
```

**Note:** Verify each service's actual port from its `docker-compose.yml` before finalizing.

### 2.3 Start Caddy

```bash
sudo systemctl enable --now caddy
```

### 2.4 Extract Caddy's root CA

```bash
sudo cat /var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt
```

Save as `caddy-root-ca.crt` — this is what friends install on their devices.

---

## Phase 3: Migrate Service Stacks

### 3.1 General pattern per docker-compose.yml

Each service stack follows the same conversion:

```yaml
# ── BEFORE (Tailscale sidecar) ──
services:
  tailscale:
    image: dhi.io/tailscale:1
    container_name: myapp-ts
    restart: unless-stopped
    command: [/usr/local/bin/containerboot]
    env_file: [.env]
    environment:
      - TS_STATE_DIR=/var/lib/tailscale
      - TS_ACCEPT_DNS=true
      - TS_SERVE_CONFIG=/config/serve.json
    hostname: myapp
    cap_add: [NET_ADMIN]
    cap_drop: [ALL]
    security_opt: [no-new-privileges:true]
    tmpfs: [/tmp, /var/run]
    devices: [/dev/net/tun:/dev/net/tun]
    volumes:
      - tailscale_state:/var/lib/tailscale:z
      - ./serve.json:/config/serve.json:ro,Z
    deploy:
      resources:
        limits:
          memory: 128M

  app:
    image: myapp:latest
    container_name: myapp
    restart: unless-stopped
    network_mode: service:tailscale
    depends_on:
      tailscale:
        condition: service_started
    # 127.0.0.1 for DB/Redis (shared namespace)

  db:
    image: dhi.io/postgres:17-alpine3.22
    container_name: myapp-db
    restart: unless-stopped
    network_mode: service:tailscale
    volumes: [pgdata:/var/lib/postgresql/data]

volumes:
  tailscale_state:
  pgdata:

---

# ── AFTER (Bridge network + port publish) ──
services:
  app:
    image: myapp:latest
    container_name: myapp
    restart: unless-stopped
    ports:
      - "APP_PORT:CONTAINER_PORT"
    environment:
      - DB_HOST=db          # was 127.0.0.1
      - REDIS_HOST=redis    # was 127.0.0.1
    depends_on:
      db:
        condition: service_healthy
    networks:
      - myapp_net

  db:
    image: dhi.io/postgres:17-alpine3.22
    container_name: myapp-db
    restart: unless-stopped
    volumes: [pgdata:/var/lib/postgresql/data]
    networks:
      - myapp_net
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U myapp"]
      interval: 5s
      timeout: 5s
      retries: 5

networks:
  myapp_net:
    driver: bridge
```

### 3.2 Service-specific notes

#### Simple services (single container, no DB)

| Service | Directory | Web port | Notes |
|---|---|---|---|
| **Jellyfin** | `jellyfin/` | 8096 | Easiest — single container |
| **Glance** | `glance/` | 8080 | Single container. Update dashboard labels |
| **Ntfy** | `ntfy/` | 80 | Single container |
| **Donetick** | `donetick/` | 2021 | App + valkey. Keep valkey on internal network |
| **SearXNG** | `searxng/` | 8080 | App + redis |
| **Actual Budget** | `actual_budget/` | 5006 | Single container |
| **LanguageTool** | `languagetool/` | 8010 | App + nginx |
| **Crafty** | `crafty/` | 8443 | Single container |
| **Neko** | `neko/` | 8080 | Chromium + WebRTC. May need extra WebRTC config |

#### Services with DB backends

| Service | Directory | Web port | Dependencies | Notes |
|---|---|---|---|---|
| **Authentik** | `authentik/` | 9000 | postgres, redis, geoip, worker, outposts | Most complex. Worker/outposts on internal net |
| **Immich** | `immich/` | 2283 | postgres, redis, microservices, ml | Complex — many containers |
| **Invidious** | `invidious/` | 3000 | postgres | Already uses bridge network (exception to sidecar pattern) |
| **Pinepods** | `pinepods/` | 8080 | postgres | |
| **OwnTracks** | `owntracks/` | 8080 | postgres, mosquitto | |
| **CryptPad** | `cryptpad/` | 3000 | postgres, redis, onlyoffice | |

#### Media stack (media_stack/)

This stack already uses a bridge network (`media_network`) with ports published to `127.0.0.1` only — so it's already well-isolated. The only Tailscale component is `media-ts` which proxies to Seerr.

**Migration:**
1. Remove the `media-ts` service block
2. Remove `media_tailscale_state` volume
3. Remove `./serve.json` volume mount
4. Remove `env_file` + `TS_*` env vars from `media-ts`
5. Everything else stays — Gluetun, qBittorrent (through Gluetun), Sonarr, Radarr, Flaresolverr, Prowlarr, Seerr, Maintainerr
6. Add Caddy routes for whatever services you want accessible (Seerr:5055, Sonarr:8989, Radarr:7878, etc.)

The Gluetun container stays as-is — it routes qBittorrent through your VPN provider. qBittorrent uses `network_mode: service:gluetun` and Gluetun publishes `127.0.0.1:8080` for the web UI.

### 3.3 Update Glance dashboard labels

After migration, update Glance labels to point to the new NetBird URLs:

```yaml
# Before
labels:
  glance.url: https://auth.${TAILNET_NAME}.ts.net

# After
labels:
  glance.url: https://auth.server.netbird.cloud
```

### 3.4 Cleanup per stack

After confirming the service works via Caddy:

```bash
docker compose down -v  # removes tailscale_state volume
# Edit docker-compose.yml with the new config
docker compose up -d
```

Remove these files:
- `serve.json` (per service directory)
- Tailscale env vars from `.env` (`TS_AUTHKEY`, `TAILNET_NAME`)

---

## Phase 4: Friend Onboarding

### 4.1 Friends install NetBird

- Linux: `curl -fsSL https://github.com/netbirdio/netbird/releases/latest/download/getting-started.sh | bash`
- macOS/Windows/Android/iOS: Download from [app.netbird.io/install](https://app.netbird.io/install)
- They run `netbird up --setup-key YOUR_KEY`

### 4.2 Friends trust Caddy's root CA

Share `caddy-root-ca.crt` with instructions:

| Platform | Steps |
|---|---|
| **Windows** | Double-click `.crt` → Install Certificate → Local Machine → Trusted Root Certification Authorities |
| **macOS** | Double-click → Keychain Access → System → Get Info → Trust → Always Trust |
| **Linux** | `sudo cp root.crt /usr/local/share/ca-certificates/ && sudo update-ca-certificates` |
| **iOS** | Download via Safari → Settings → Profile → Install → Enable Trust |
| **Android** | Settings → Security → Install certificate (Chrome trusts user CAs; some native apps may not). **Also:** Go to Settings → Network & Internet → **Private DNS** → set to **Off**. Android's Private DNS bypasses NetBird's DNS resolver, breaking `*.server.netbird.cloud` resolution. |

### 4.3 Access services

Friends open `https://service-name.server.netbird.cloud/` — green lock.

---

## Phase 5: Future Self-Hosted Migration

When you can open ports and want to self-host NetBird:

1. Deploy NetBird management/signal/relay on a VPS with ports 80, 443, 3478 open
2. Optionally configure a custom DNS domain (e.g., `netbird.yourdomain.com`)
3. On each agent (server + friends):
   ```bash
   netbird down
   netbird up --management-url https://your-mgmt-server
   ```
4. If DNS domain changed, re-register labels:
   ```bash
   netbird up --extra-dns-labels "*.server"
   ```

**Caddy and all service configs stay unchanged** — only the NetBird management URL changes.

---

## Migration Order (recommended)

1. **Foundation** — Set up NetBird host agent + Caddy + extract root CA
2. **Simple services** (single container) — Jellyfin, Glance, Ntfy, Donetick, SearXNG, Actual Budget, LanguageTool, Crafty
3. **Medium services** (app + DB) — Invidious, OwnTracks, Pinepods, CryptPad, Neko
4. **Media stack** — Already mostly there; just remove media-ts, update Caddy
5. **Complex stacks** (multi-service) — Authentik, Immich
6. **Glance** — Update dashboard labels last (after all services migrated)
7. **Cleanup** — Remove `serve.json` files, `.env` Tailscale vars, `media_tailscale_state` volume

---

## Rollback

Each service migration is independent. If a service doesn't work post-migration:

1. Revert that stack's `docker-compose.yml` to its Tailscale version
2. Run `docker compose up -d` to restore
3. The Caddy route stays — it'll just hit the restored service

Old `serve.json` files can stay until everything is confirmed working.
