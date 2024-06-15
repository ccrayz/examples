#!/bin/bash

# VPN User 인증서 생성
CLIENT_NAME="ccrayz"

docker compose run --rm openvpn easyrsa build-client-full $CLIENT_NAME nopass
# VPN User 파일 꺼내기
docker compose run --rm openvpn ovpn_getclient $CLIENT_NAME > users/$CLIENT_NAME.ovpn

# with a passphrase (recommended)
# docker compose run --rm openvpn easyrsa build-client-full $CLIENT_NAME
# without a passphrase (not recommended)
