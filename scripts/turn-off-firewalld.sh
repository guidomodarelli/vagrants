#!/bin/bash

# Script to disable firewalld service
# Improved version with error handling and verification

# Function for logging
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Exit on error
set -e

log "====== Firewalld Deactivation Process ======"

# Check if firewalld is installed
if ! command -v firewall-cmd &> /dev/null; then
  log "Warning: firewalld does not appear to be installed"
  exit 0
fi

# Check current status
if systemctl is-active --quiet firewalld; then
  log "* Firewalld is currently active"

  log "Stopping firewalld service..."
  if systemctl stop firewalld; then
    log "* Firewalld service stopped successfully"
  else
    log "* Failed to stop firewalld service"
    exit 1
  fi
else
  log "* Firewalld is already stopped"
fi

# Check if enabled at boot
if systemctl is-enabled --quiet firewalld; then
  log "* Firewalld is enabled at system boot"

  log "Disabling firewalld service at boot..."
  if systemctl disable firewalld; then
    log "* Firewalld service disabled successfully"
  else
    log "* Failed to disable firewalld service"
    exit 1
  fi
else
  log "* Firewalld is already disabled at boot"
fi

# Verify the service is stopped and disabled
if ! systemctl is-active --quiet firewalld; then
  log "✅ Firewalld service is stopped"
else
  log "❌ Failed to stop firewalld service"
  exit 1
fi

if ! systemctl is-enabled --quiet firewalld; then
  log "✅ Firewalld service is disabled at boot"
else
  log "❌ Failed to disable firewalld at boot"
  exit 1
fi

log "====== Firewalld Deactivation Complete ======"
