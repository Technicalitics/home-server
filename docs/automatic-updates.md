# Automatic Updates with dnf-automatic

Automatically apply security updates on Fedora/RHEL systems and receive notifications via a self-hosted ntfy instance.

## Prerequisites

- Fedora/RHEL-based system
- `dnf-automatic` installed: `sudo dnf install dnf-automatic`
- Self-hosted ntfy instance with a configured topic
    - Alternatively, you can use ntfy.sh

## Setup Steps

1. **Create the configuration file**:
   Copy the example configuration to `/etc/dnf/automatic.conf` (example content provided below):
   ```bash
    sudo cp /path/to/repo/docs/dnf-automatic.conf.example /etc/dnf/automatic.conf
   ```

2. **Configure ntfy placeholders**:
   Edit `/etc/dnf/automatic.conf` and replace `NTFY_INSTANCE_PLACEHOLDER` and `TOPIC_PLACEHOLDER` with your actual ntfy instance URL and topic.

3. **Enable the automatic update timer**:
   Start and enable the systemd timer to run updates automatically:
   ```bash
    sudo systemctl enable --now dnf-automatic.timer
   ```

## Notes

- The timer runs daily by default; adjust the timer schedule via `sudo systemctl edit dnf-automatic.timer`
- To disable automatic reboots, set `reboot=never` in the `[commands]` section
- ntfy notifications include update details, transaction summaries, and download status
- For further information on the configuration, [read the docs](https://dnf.readthedocs.io/en/latest/automatic.html)
