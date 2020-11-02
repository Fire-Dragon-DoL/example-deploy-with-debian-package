#!/bin/bash

default_config_path='/etc/opt/MYPKGNAME/env.sh'
config_path="${MPN_CONFIG_PATH:-$default_config_path}"
set -a
echo "[Peon] Loading MYPKGNAME configuration"
source "$config_path"
set +a

kill -SIGINT "$1"
