#!/bin/bash
# Exit on errors
set -e
# Uncomment to set the root password to login for runtime debugging.
passwd root
# Display chkconfig info
chkconfig --list
exec /usr/sbin/init
systemctl list-unit-files > /usr/local/tmp/unit-files.rpt
systemctl restart autofs
# run the command given as arguments from CMD
eval "$@"
