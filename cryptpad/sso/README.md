# SSO Plugin

This directory contains the [CryptPad SSO plugin](https://github.com/cryptpad/sso).

## Setup

1. Clone the plugin into this directory:
   ```bash
   git clone https://github.com/cryptpad/sso.git .
   ```

2. Copy the SSO config template to the server config directory and edit:
   ```bash
   cp config/sso.js.example /srv/docker/data/cryptpad/config/sso.js
   ```

3. Edit `/srv/docker/data/cryptpad/config/sso.js` with your provider details (see examples in the file).

4. Restart: `docker compose restart cryptpad`

The compose file already mounts `./sso:/cryptpad/lib/plugins/sso:ro,Z`.
