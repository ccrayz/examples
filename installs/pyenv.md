
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

