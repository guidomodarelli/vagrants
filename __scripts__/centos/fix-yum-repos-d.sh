#!/bin/bash


# Script to fix CentOS repositories by switching from mirrorlist to vault.centos.org
# Based on https://stackoverflow.com/a/71309215

# Function for logging
log() {
  echo "[YUM-FIX] $1"
}

# Exit on error
set -e

log "====== CentOS YUM Repositories Fix ======"

# Check if this is a CentOS system
if [ ! -f /etc/centos-release ]; then
  log "Error: This script is intended for CentOS systems only"
  exit 2
fi

log "Starting YUM repositories fix..."

# Navigate to the repos directory
log "Changing to /etc/yum.repos.d/ directory"
cd /etc/yum.repos.d/ || {
  log "Error: Failed to change directory to /etc/yum.repos.d/"
  exit 3
}

# Check if there are CentOS repo files
if ! ls CentOS-* &>/dev/null; then
  log "Error: No CentOS repository files found"
  exit 4
fi

# Replace mirrorlist with vault URLs
log "Disabling mirrorlist in CentOS repo files"
sed -i 's/mirrorlist/#mirrorlist/g' CentOS-* || {
  log "Error: Failed to disable mirrorlist"
  exit 5
}

log "Changing baseurl to vault.centos.org"
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' CentOS-* || {
  log "Error: Failed to update baseurl"
  exit 6
}

# Clean and update package cache
log "Cleaning YUM cache"
yum clean all || log "Warning: Failed to clean YUM cache"

log "Updating YUM cache"
yum makecache || log "Warning: Failed to update YUM cache"

# Run system upgrade
log "Performing system upgrade"
yum upgrade -y
upgrade_status=$?

if [ $upgrade_status -eq 0 ]; then
  log "YUM repositories successfully fixed and system upgraded"
else
  log "WARNING: System upgrade completed with status: $upgrade_status"
fi

log "====== CentOS YUM Repositories Fix Complete ======"
