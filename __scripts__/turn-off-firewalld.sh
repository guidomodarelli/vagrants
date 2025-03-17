#!/bin/bash

# Script to disable firewalld service
# Improved version with error handling and verification

source "/home/vagrant/styleText.sh"

LOG_PREFIX="[ $(printGreen -b DISABLE-FIREWALLD) ]"

exit_and_log_header() {
  local code=$1
  logHeader "Firewalld Deactivation Complete"
  exit $code
}

# Exit on error
set -e

logHeader "Firewalld Deactivation Process"

# Check if firewalld is installed
if ! command -v firewall-cmd &> /dev/null; then
  logWarn "firewalld does not appear to be installed"
  exit_and_log_header 0
fi

# Check current status
if systemctl is-active --quiet firewalld; then
  logInfo "Firewalld is currently active"

  log "Stopping firewalld service..."
  if systemctl stop firewalld; then
    logSuccess "Firewalld service stopped successfully"
  else
    logError "Failed to stop firewalld service"
    exit_and_log_header 1
  fi
else
  logInfo "Firewalld is already stopped"
fi

# Check if enabled at boot
if systemctl is-enabled --quiet firewalld; then
  logInfo "Firewalld is enabled at system boot"

  log "Disabling firewalld service at boot..."
  if systemctl disable firewalld; then
    logSuccess "Firewalld service disabled successfully"
  else
    logError "Failed to disable firewalld service"
    exit_and_log_header 1
  fi
else
  logInfo "Firewalld is already disabled at boot"
fi

# Verify the service is stopped and disabled
if ! systemctl is-active --quiet firewalld; then
  logSuccess "Firewalld service is stopped"
else
  logError "Failed to stop firewalld service"
  exit_and_log_header 1
fi

if ! systemctl is-enabled --quiet firewalld; then
  logSuccess "Firewalld service is disabled at boot"
else
  logError "Failed to disable firewalld at boot"
  exit_and_log_header 1
fi

exit_and_log_header 0
