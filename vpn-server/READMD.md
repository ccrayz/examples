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


