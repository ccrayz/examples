#!/bin/bash

cp .env.sample .env

if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

echo "VPN_END_POINT_DNS: $VPN_END_POINT_DNS"
echo "VPN_PORT: $VPN_PORT"

# Initalize
docker compose run --rm openvpn ovpn_genconfig -u udp://$VPN_END_POINT_DNS
docker compose run --rm openvpn ovpn_initpki
sudo chown -R $(whoami): ./data

# 1. passpharse 설정
# 2. Common Name: home
# 3. 지정한 passpharse 입력