# VPN Server

# Installs

install package
```
brew install pyenv
brew install pyenv-virtualenv
```

setup path
```
# code ~/.zshrc
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
# pyenv-virtualenv setting
eval "$(pyenv virtualenv-init -)"
```

pyenv version list
```
pyenv install --list
pyenv install 3.12.2
```

```
# 전역으로 적용
pyenv global 3.12.2

# 현재 프로젝트에만 적용
pyenv local 3.12.2

# verions check
python -V && pip -V
```


# Terraform


### 1. Setup Allow cidr
```bash
export TF_VAR_allowed_cidr_blocks="[\"$(curl -s https://ifconfig.me/)/32\"]"
```

### 2. create ssh key
```bash
./scripts/gen_key.sh
```


### 3. create vpn instance
```bash
cd ./terraform/vpn
terrform init
terrform apply
```


# Docker
```bash
cd ./examples/vpn-server/docker
```


```bash
./scripts/init.sh

# 1. passpharse 설정 (ex: 1234)
# Enter New CA Key Passphrase:

# 2. Common Name 설정 (ex: ccrayz)
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
# - 1번에서 생성한 pass 입력
```

해당 경로에 관련 파일들이 생성된것을 확인할 수 있다.
```bash
ls /mnt/vpn/
```

vpn 서버 실행
```
# examples/vpn-server/docker 에서 실행해야 한다.
docker compose up -d
```

prometheus: http://{YOUR_INSTANE_PUB_IP}:9090
grafana: http://{YOUR_INSTANE_PUB_IP}:3000
- Id: admin
- Pass: 1234
