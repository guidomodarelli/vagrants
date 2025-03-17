#!/bin/bash

source "/home/vagrant/styleText.sh"

# Script to fix CentOS repositories by switching from mirrorlist to vault.centos.org
# Based on https://stackoverflow.com/a/71309215

LOG_PREFIX="[ $(printGreen -b YUM-REPOS-FIX) ]"

exit_and_log_header() {
  local code="$1"
  logHeader "CentOS YUM Repositories Fix Complete"
  exit "$code"
}

# Exit on error
set -e

logHeader "CentOS YUM Repositories Fix"

# Check if this is a CentOS system
if [ ! -f /etc/centos-release ]; then
  logError "This script is intended for CentOS systems only"
  exit_and_log_header 2
fi

logInfo "Starting YUM repositories fix..."

# Navigate to the repos directory
logInfo "Changing to /etc/yum.repos.d/ directory"
cd /etc/yum.repos.d/ || {
  logError "Failed to change directory to /etc/yum.repos.d/"
  exit_and_log_header 3
}

# Check if there are CentOS repo files
if ! ls CentOS-* &>/dev/null; then
  logError "No CentOS repository files found"
  exit_and_log_header 4
fi

# Replace mirrorlist with vault URLs
logInfo "Disabling mirrorlist in CentOS repo files"
sed -i 's/mirrorlist/#mirrorlist/g' CentOS-* || {
  logError "Failed to disable mirrorlist"
  exit_and_log_header 5
}

logInfo "Changing baseurl to vault.centos.org"
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' CentOS-* || {
  logError "Failed to update baseurl"
  exit_and_log_header 6
}

# Clean and update package cache
logInfo "Cleaning YUM cache"
yum clean all || logWarn "Failed to clean YUM cache"

logInfo "Updating YUM cache"
yum makecache || logWarn "Failed to update YUM cache"

# Run system upgrade
logInfo "Performing system upgrade"
yum upgrade -y
upgrade_status=$?

if [ $upgrade_status -eq 0 ]; then
  logSuccess "✅ YUM repositories successfully fixed and system upgraded"
else
  logWarn "System upgrade completed with status: $upgrade_status"
fi

exit_and_log_header 0
