#!/bin/bash
echo "Installing Docker..."

sudo apt-get upgrade -y
sudo apt-get update -y

sudo apt-get install -y \
    net-tools \
    unzip \
    htop \
    gcc \
    build-essential \
    ca-certificates \
    curl \
    gnupg \
    parted

sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo usermod -aG docker ubuntu

MOUNT_PATH=/mnt/vpn
mkdir -p $MOUNT_PATH

# 디스크에 GPT 파티션 테이블을 생성
# - gpt는 GUID Partition Table의 약자로, MBR보다 더 많은 파티션을 지원
sudo parted -s /dev/nvme1n1 mklabel gpt

# - mkpart: 파티션을 생성
# - primary: 주 파티션을 생성
# - xfs: XFS 파일 시스템을 사용할 파티션
# - 0%: 파티션의 시작 위치를 디스크의 시작으로 설정
# - 100%: 파티션의 끝 위치를 디스크의 끝으로 설정
sudo parted -s /dev/nvme1n1 mkpart primary xfs 0% 100%

# /dev/nvme1n1에 XFS 파일 시스템을 생성
sudo mkfs.xfs -f /dev/nvme1n1

# /mnt/vpn 디렉터리에 /dev/nvme1n1을 마운트
sudo mount /dev/nvme1n1 $MOUNT_PATH

# /etc/fstab 파일에 UUID를 이용하여 부팅 시 자동으로 마운트되도록 설정
UUID=$(sudo blkid -s UUID -o value /dev/nvme1n1)
echo "UUID=$UUID $MOUNT_PATH xfs defaults,nofail 0 2" | sudo tee -a /etc/fstab

echo "Done!"
