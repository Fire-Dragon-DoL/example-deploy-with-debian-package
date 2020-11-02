#!/bin/bash

set -e

pushd /opt/CONFIG_PATH >/dev/null

# Migrate
set -a
echo "[Deploy] Loading CONFIG_PATH configuration"
source /etc/opt/CONFIG_PATH/env.sh
echo "[Deploy] Loading CONFIG_PATH Admin configuration"
source /etc/opt/CONFIG_PATH/db-admin.sh
set +a

echo "[Deploy] PATH: ${PATH}"

echo "[Deploy] Migration CONFIG_PATH DB"
rake db:migrate

if [ -f "/var/opt/CONFIG_PATH/first-install" ]; then
  echo "[Deploy] First installation detected"
  echo "[Deploy] CONFIG_PATH needs to be manually enabled"
  # systemctl enable CONFIG_PATH.service
  # systemctl enable CONFIG_PATH-jobs.service
  rm -f /var/opt/CONFIG_PATH/first-install
fi
set +e

popd >/dev/null

echo "[Deploy] Reloading systemd"
systemctl daemon-reload
systemctl reload nginx.service
echo "[Deploy] Restarting rsyslog"
systemctl restart rsyslog.service
echo "[Deploy] Starting CONFIG_PATH"

systemctl start CONFIG_PATH.service
