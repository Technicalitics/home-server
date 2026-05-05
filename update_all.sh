#!/usr/bin/env bash

set -e

BASE_DIR="${1:-/srv/docker/compose}"
FAILED_FILE=$(mktemp)

# Cleanup on exit
trap 'rm -f "$FAILED_FILE"' EXIT

# Verify base directory exists
if [ ! -d "$BASE_DIR" ]; then
  echo "Error: Base directory '$BASE_DIR' does not exist"
  exit 1
fi

export FAILED_FILE

# Function to update a single service
update_service() {
  local dir="$1"
  echo "Updating $dir"
  if cd "$dir" && timeout 300 docker compose up -d --pull=always; then
    return 0
  else
    echo "$dir" >> "$FAILED_FILE"
    return 1
  fi
}

export -f update_service

# Find all directories with docker-compose.yml and update in parallel
find "$BASE_DIR" -maxdepth 1 -type d | while read -r dir; do
  if [ -f "$dir/docker-compose.yml" ]; then
    echo "$dir"
  fi
done | xargs -P 4 -I {} bash -c 'update_service "$@"' _ {}

echo "----"
echo "Failures:"
if [ -s "$FAILED_FILE" ]; then
  cat "$FAILED_FILE"
else
  echo "None"
fi
