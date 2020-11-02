#!/bin/bash

# $1 server address (ssh alias or ip)

release() {
  mkdir -p ./tmp/deploy
  rm -f ./tmp/deploy/MYPKGNAME.deb
  rm -rf ./tmp/deploy/MYPKGNAME
  docker build -f ./deploy/Dockerfile -t MYPKGNAME . &&
    docker create -ti --name dummyMYPKGNAME MYPKGNAME bash >/dev/null &&
    docker cp dummyMYPKGNAME:/app/MYPKGNAME.deb \
      ./tmp/deploy/MYPKGNAME.deb >/dev/null &&
    docker cp dummyMYPKGNAME:/app ./tmp/deploy/MYPKGNAME >/dev/null &&
    docker rm -fv dummyMYPKGNAME >/dev/null
}

upload_to() {
  # $1 server_address
  local server_address
  server_address="$1"

  scp "./tmp/deploy/MYPKGNAME.deb" \
    "${server_address}:MYPKGNAME.deb"
}

deploy_to() {
  # $1 server_address
  local server_address
  server_address="$1"
  echo "[Deploy] Deploying to ${server_address}"

  ssh -t "${server_address}" \
    "sudo apt install --reinstall ./MYPKGNAME.deb"
}

deploy() {
  # $1 server_address
  local server_address
  server_address="$1"

  release
  upload_to "$server_address"
  deploy_to "$server_address"
}

clean() {
  docker rmi MYPKGNAME
}

deploy "$1"
