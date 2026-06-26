# Bulk Service Updates

## Principles

This approach follows four key principles:

1. **Control** - Explicit service updates with clear failure tracking
2. **Avoiding Repetition** - Single command updates all services instead of manual `cd` + `docker compose` per service
3. **Speed** - Parallel execution with `xargs -P 4` reduces total update time
4. **Documentation** - Self-documenting script with clear output and failure reporting

## What It Does

The `update_all.sh` script:

- Scans a base directory for subdirectories containing `docker-compose.yml`
- Updates each service by pulling latest images and recreating containers
- Runs up to 4 updates in parallel using `xargs`
- Tracks and reports failed updates in a temp file
- Accepts an optional base directory argument (defaults to `/srv/docker/compose`)

## Usage

```bash
# Using default base directory (/srv/docker/compose)
./update_all.sh

# Specify custom directory
./update_all.sh /path/to/your/compose/files
```

## Customization

Some ways you could modify `update_all.sh`:

### Base Directory

Pass as argument or edit the default in the script:

```bash
BASE_DIR="${1:-/srv/docker/compose}"
```

### Parallel Jobs

Change `-P 4` to desired concurrency:

```bash
xargs -P 2  # Reduce to 2 parallel jobs
xargs -P 8  # Increase to 8 parallel jobs
```

**Note**: Setting `-P 0` enables unlimited parallelism (not recommended).

### Timeout

Adjust or remove the `timeout 300` value (in seconds):

```bash
timeout 600 docker compose up -d --pull=always  # 10 minutes
```

### Pull Behavior

Change `--pull=always` to:

- `--pull=missing` - Only pull if image not present locally (saves bandwidth)
- Remove `--pull` flag entirely - Never pull, only recreate with existing images
