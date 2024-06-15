#!/bin/bash
# SSH 키페어를 생성할 디렉토리 경로 설정
KEY_DIR="./ssh"
KEY_NAME="vpn-ec2-keypair"

# 키페어 생성
echo "Creating SSH key pair..."
mkdir -p $KEY_DIR
ssh-keygen -t rsa -b 2048 -f "$KEY_DIR/$KEY_NAME" -N ""

# 생성된 키페어 정보 출력
echo "SSH key pair created successfully!"
echo "Private Key: $KEY_DIR/$KEY_NAME"
echo "Public Key: $KEY_DIR/$KEY_NAME.pub"
