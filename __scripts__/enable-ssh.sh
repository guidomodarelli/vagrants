#!/bin/bash

source "/home/vagrant/styleText.sh"

# Script to enable SSH password authentication
# Improved version with error handling and verification

LOG_PREFIX="[ $(printGreen -b ENABLE-SSH) ]"

# Exit on error
set -e

# Config file path
SSH_CONFIG="/etc/ssh/sshd_config"
KEY="PasswordAuthentication"

# Check if SSH config file exists
if [[ ! -f "$SSH_CONFIG" ]]; then
  logError "SSH configuration file not found at $SSH_CONFIG"
  exit 1
fi

logHeader "SSH Configuration Setup"

# Check current setting
if grep -q "^\s*$KEY no" "$SSH_CONFIG"; then
  logWarn "Password authentication is currently disabled"

  logInfo "Enabling password authentication..."
  sed -i "s/^\s*$KEY no/$KEY yes/" "$SSH_CONFIG"

  # Verify the change
  if grep -q "^\s*$KEY yes" "$SSH_CONFIG"; then
    logSuccess "Password authentication successfully enabled"
  else
    logError "Failed to enable password authentication"
    exit 1
  fi
elif grep -q "^\s*$KEY yes" "$SSH_CONFIG"; then
  logSuccess "Password authentication is already enabled"
else
  logInfo "Adding password authentication setting..."
  echo "$KEY yes" >> "$SSH_CONFIG"
fi

logInfo "Current SSH password authentication setting:"
grep "^\s*$KEY" "$SSH_CONFIG" | while read -r line; do
  log "$line"
done

logInfo "Restarting SSH service..."
if systemctl restart sshd; then
  logSuccess "SSH service restarted successfully"
else
  logError "Failed to restart SSH service"
  exit 1
fi

logSuccess "✅ SSH password authentication is now enabled"
logHeader "SSH Configuration Complete"
