#!/bin/bash

cp .env.sample .env

if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

echo "VPN_ENDPOINT_DNS: $VPN_ENDPOINT_DNS"
echo "VPN_PORT: $VPN_PORT"

# Initalize
# - 기본 OpenVPN 서버 구성 파일(server.conf)을 생성
# - 클라이언트가 서버에 연결할 수 있도록 필요한 설정 추가
# - 지정된 프로토콜(udp)과 서버 주소를 구성 파일에 추가
docker compose run --rm openvpn ovpn_genconfig -u udp://$VPN_ENDPOINT_DNS

# Set the server configuration
OPENVPN_SERVER_CONF_PATH=/mnt/vpn/openvpn.conf
sed -i 's/192.168.255.0/10.100.0.0/g' $OPENVPN_SERVER_CONF_PATH
sed -i 's/192.168.254.0/10.0.0.0/g' $OPENVPN_SERVER_CONF_PATH
echo client-to-client >> $OPENVPN_SERVER_CONF_PATH
echo "### openvpn management" >> $OPENVPN_SERVER_CONF_PATH
echo "management 0.0.0.0 5555" >> $OPENVPN_SERVER_CONF_PATH

# CA(Certificate Authority) 인증서를 생성
docker compose run --rm openvpn ovpn_initpki
sudo chown -R $(whoami): /mnt/vpn


# 1. passpharse 설정 (ex: 1234)
# Enter New CA Key Passphrase:

# 2. Common Name 설정 (ex: Easy-RSA CA)
# Generating RSA private key, 4096 bit long modulus (2 primes)
# ......................................................................++++
# .........................................................................................++++
# e is 65537 (0x010001)
# You are about to be asked to enter information that will be incorporated
# into your certificate request.
# What you are about to enter is what is called a Distinguished Name or a DN.
# There are quite a few fields but you can leave some blank
# For some fields there will be a default value,
# If you enter '.', the field will be left blank.
# -----
# Common Name (eg: your user, host, or server name) [Easy-RSA CA]:

# 3. 지정한 passpharse 입력