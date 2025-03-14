#!/bin/bash

echo
echo "Turn off firewalld"
systemctl stop firewalld
systemctl disable firewalld
echo
