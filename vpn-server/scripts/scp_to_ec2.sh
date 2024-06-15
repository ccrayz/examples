#/bin/bash

PUB_IP=$1

scp -r -i ./ssh/vpn-ec2-keypair ./docker ubuntu@$PUB_IP:~/docker

