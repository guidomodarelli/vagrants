#!/bin/bash

# Script to enable SSH password authentication
# Improved version with error handling and verification

# Function for logging
log() {
  echo "[ENABLE-SSH] $1"
}

# Exit on error
set -e

# Config file path
SSH_CONFIG="/etc/ssh/sshd_config"
KEY="PasswordAuthentication"

# Check if SSH config file exists
if [[ ! -f "$SSH_CONFIG" ]]; then
  log "Error: SSH configuration file not found at $SSH_CONFIG"
  exit 1
fi

log "====== SSH Configuration Setup ======"

# Check current setting
log "Current configuration:"
if grep -q "^\s*$KEY no" "$SSH_CONFIG"; then
  log "* Password authentication is currently disabled"

  log "Enabling password authentication..."
  sed -i "s/^\s*$KEY no/$KEY yes/" "$SSH_CONFIG"

  # Verify the change
  if grep -q "^\s*$KEY yes" "$SSH_CONFIG"; then
    log "* Password authentication successfully enabled"
  else
    log "* Failed to enable password authentication"
    exit 1
  fi
elif grep -q "^\s*$KEY yes" "$SSH_CONFIG"; then
  log "* Password authentication is already enabled"
else
  log "* Adding password authentication setting..."
  echo "$KEY yes" >> "$SSH_CONFIG"
fi

log "Current SSH password authentication setting:"
grep "^\s*$KEY" "$SSH_CONFIG" | while read -r line; do
  log "$line"
done

log "Restarting SSH service..."
if systemctl restart sshd; then
  log "* SSH service restarted successfully"
else
  log "* Failed to restart SSH service"
  exit 1
fi

log "✅ SSH password authentication is now enabled"
log "====== SSH Configuration Complete ======"
