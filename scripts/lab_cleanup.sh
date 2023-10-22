#!/bin/bash

# Store the release names alone for a specific namespace.
helm_releases=( $(helm list --short --namespace "dev") )

# Store current date in seconds since epoch
CURRENT_TIME_SECONDS=$(date '+%s')

# Calculate the threshold time (3 hours ago) in seconds
THRESHOLD_TIME_SECONDS=$((CURRENT_TIME_SECONDS - 10800))  # 3 hours = 3 * 60 * 60 seconds

for RELEASE in "${helm_releases[@]}"; do
  LAST_DEPLOYED=$(helm status "$RELEASE" --namespace "dev" --output json | jq -r '.info.last_deployed')
  LAST_DEPLOYED_SECONDS=$(date -d "$LAST_DEPLOYED" '+%s')
  
  if [ "$LAST_DEPLOYED_SECONDS" -lt "$THRESHOLD_TIME_SECONDS" ]; then
    echo "$RELEASE is older than 3 hours. Proceeding to delete it."
    helm delete "$RELEASE" --namespace "dev"
  fi
done
