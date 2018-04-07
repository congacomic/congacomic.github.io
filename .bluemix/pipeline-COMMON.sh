#!/usr/bin/env bash

set -ex

function install_nodejs {
    npm config delete prefix
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install 8
    nvm use 8
    node -v
    npm -v
}

function install_composer {
    npm install -g composer-cli@0.18.1 @ampretia/composer-wallet-cloudant
}

function install_jq {
    curl -o jq -L https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
    chmod +x jq
    export PATH=${PATH}:${PWD}
}