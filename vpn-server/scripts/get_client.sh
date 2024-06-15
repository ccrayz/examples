#!/bin/bash

PUB_IP=$1
CLIENT_NAME=$2
CLIENT_PATH=/home/ubuntu/examples/vpn-server/docker/clients

scp -r -i ./ssh/vpn-ec2-keypair ubuntu@$PUB_IP:$CLIENT_PATH/$CLIENT_NAME.ovpn ./clients/$CLIENT_NAME.ovpn
