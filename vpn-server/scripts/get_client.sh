#!/bin/bash

PUB_IP=$1
CLIENT_NAME=$2

scp -r -i ./ssh/vpn-ec2-keypair ubuntu@$PUB_IP:~/docker/users/$CLIENT_NAME.ovpn ./users/$CLIENT_NAME.ovpn

