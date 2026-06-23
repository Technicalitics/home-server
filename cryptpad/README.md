# CryptPad

Encrypted, self-hosted office suite with documents, spreadsheets, presentations, and file storage.

For common setup instructions, see [docs/INSTRUCTIONS.md](../docs/INSTRUCTIONS.md).

## Quick Start

1. Create data directories on HDD and SSD:
   ```bash
   # HDD - documents and files (on ZFS, backed up)
   sudo mkdir -p /mnt/media/cryptpad/{blob,block,data,files}
   sudo chown -R 4001:4001 /mnt/media/cryptpad

   # SSD - configuration (fast, small)
   sudo mkdir -p /srv/docker/data/cryptpad/customize \
                 /srv/docker/data/cryptpad/config
   sudo chown -R 4001:4001 /srv/docker/data/cryptpad
   ```

2. Create and configure `config.js`:
   ```bash
   cp config/config.js /srv/docker/data/cryptpad/config/config.js
   ```
   Then edit `/srv/docker/data/cryptpad/config/config.js` and set:
   ```javascript
   module.exports = {
       httpUnsafeOrigin: 'https://cloud.server.netbird.cloud',
       httpSafeOrigin: 'https://sandbox.server.netbird.cloud',
       httpAddress: '0.0.0.0',
       adminKeys: [],
       installMethod: 'docker',
   };
   ```

3. Set up `application_config.js` (required — sets login salt for password hashing):
   ```bash
   docker compose up -d
   # Wait for container to start, then copy the default template:
   docker exec cryptpad cp customize.dist/application_config.js /cryptpad/customize/application_config.js
   ```
   Then edit `/srv/docker/data/cryptpad/customize/application_config.js` and add:
   ```js
   AppConfig.loginSalt = '<32-char-hex>';
   ```
   Generate a salt with: `openssl rand -hex 32`

4. Copy `.env.example` to `.env`.

5. Restart: `docker compose up -d`

6. Get the setup URL from logs:
   ```bash
   docker compose logs cryptpad | grep -i "setup"
   ```

7. Open the setup URL in your browser to create the admin account.

8. Adjust storage limits and disable donate prompts via the admin panel (`/admin/`).

## Access

- Web UI: https://cloud.server.netbird.cloud
- Sandbox origin: https://sandbox.server.netbird.cloud

## Service-Specific Configuration

### Config.js

The mounted `config.js` overrides specific values from the built-in example config via deep merge. Only the values you set are overridden. A template is at `config/config.js.example` in this repo:

```javascript
module.exports = {
    httpUnsafeOrigin: 'https://cloud.server.netbird.cloud',
    httpSafeOrigin: 'https://sandbox.server.netbird.cloud',
    httpAddress: '0.0.0.0',
    adminKeys: [],
    installMethod: 'docker',
};
```

### Admin Account

The first registered user is NOT automatically an admin. To add admin privileges:

1. Go to User Menu > Settings > Account and copy your **Public Signing Key**
2. Add it to `/srv/docker/data/cryptpad/config/config.js`:
   ```javascript
   adminKeys: [
       "[cryptpad-user1@.../your-public-key]",
   ],
   ```
3. Restart: `docker compose restart cryptpad`

You can also manage admins via the admin panel at `/admin/`.

### Login Salt

Set a login salt BEFORE creating any user accounts. Changing it later breaks all existing logins. Add to `/srv/docker/data/cryptpad/customize/application_config.js`:

```javascript
AppConfig.loginSalt = '<32-char-hex>';
```

Generate with: `openssl rand -hex 32`

The `application_config.js` file must use the factory wrapper format (copied from `customize.dist/application_config.js` inside the container).

### Sandbox Domain

This instance uses a hostname-based sandbox:
- Main: `cloud.server.netbird.cloud` (`httpUnsafeOrigin`)
- Sandbox: `sandbox.server.netbird.cloud` (`httpSafeOrigin`)

The browser treats these as different origins, isolating the editor UI from cryptographic operations. This prevents XSS vulnerabilities in the editor (e.g., a malicious .docx) from accessing your encryption keys.

Both hostnames are proxied by Caddy to the same CryptPad instance on its internal port 3000.

### Storage & Donate Button

After initial setup, adjust storage limits and hide the donate prompt via the admin panel:
- Go to `/admin/` → User Storage → set your desired limit
- The donate button is also toggleable in admin settings

### SSO (Single Sign-On)

This instance supports SSO via the [CryptPad SSO plugin](https://github.com/cryptpad/sso) (OIDC/SAML).

1. Clone the SSO plugin into the repo's `sso/` directory (on your local machine):
   ```bash
   cd cryptpad/sso
   git clone https://github.com/cryptpad/sso.git .
   ```

2. Copy and edit the SSO config on the server:
   ```bash
   cp config/sso.js /srv/docker/data/cryptpad/config/sso.js
   ```
   Then edit `/srv/docker/data/cryptpad/config/sso.js` with your provider details.

3. Restart: `docker compose restart cryptpad`

The compose file mounts `./sso:/cryptpad/lib/plugins/sso:ro,Z`.

### OnlyOffice (Optional)

For better Office format compatibility (.docx, .xlsx, .pptx), you can enable the OnlyOffice integration.

1. Accept the OnlyOffice license: https://github.com/ONLYOFFICE/web-apps/blob/master/LICENSE.txt
2. Uncomment `CPAD_INSTALL_ONLYOFFICE=yes` in `.env`
3. Add OnlyOffice volumes to `docker-compose.yml`:
   ```yaml
   volumes:
     - /srv/docker/data/cryptpad/onlyoffice-dist:/cryptpad/www/common/onlyoffice/dist:Z
     - /srv/docker/data/cryptpad/onlyoffice-conf:/cryptpad/onlyoffice-conf:Z
   ```
4. Create directories: `sudo mkdir -p /srv/docker/data/cryptpad/{onlyoffice-dist,onlyoffice-conf}`
5. Set permissions: `sudo chown -R 4001:4001 /srv/docker/data/cryptpad/{onlyoffice-dist,onlyoffice-conf}`
6. Recreate: `docker compose up -d`

### Customization

The `customize/` directory at `/srv/docker/data/cryptpad/customize/` is mounted into the container. You can customize:

- `application_config.js` - Instance-wide settings (login salt, theme, etc.)
- Logo, accent color, terms of service, and more (via admin panel at `/admin/`)

### Volumes

Hardcoded to my server setup:
- `/mnt/media/cryptpad/blob` - Encrypted blob storage (HDD)
- `/mnt/media/cryptpad/block` - Block metadata (HDD)
- `/mnt/media/cryptpad/data` - User data and settings (HDD)
- `/mnt/media/cryptpad/files` - File datastore (HDD)
- `/srv/docker/data/cryptpad/customize` - Instance customization (SSD)
- `/srv/docker/data/cryptpad/config` - Config files (SSD)

**To make portable:** Change to relative paths in docker-compose.yml.

## Diagnostics

Visit `https://cloud.server.netbird.cloud/checkup/` after setup to verify everything is configured correctly.
