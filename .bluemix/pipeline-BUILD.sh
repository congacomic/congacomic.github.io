#!/usr/bin/env bash

set -ex

source .bluemix/pipeline-COMMON.sh

export CONTRACTS=$(ls contracts)

function test_contracts {
    for CONTRACT in ${CONTRACTS}
    do
        test_contract ${CONTRACT}
    done
}

function test_contract {
    if [ -f contracts/$1/package.json ]
    then
        test_composer_contract $1
    else
        echo unrecognized contract type $1
        exit 1
    fi
}

function test_composer_contract {
    echo testing composer contract $1
    pushd contracts/$1
    npm install
    npm test
    rm -rf node_modules
    popd
}

install_nodejs
test_contracts