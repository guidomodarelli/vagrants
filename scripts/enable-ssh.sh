#!/bin/bash

echo
echo "Enabling password authentication"
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo
grep '^\s*PasswordAuthentication' /etc/ssh/sshd_config
echo
echo "Restarting sshd service"
systemctl restart sshd
echo
