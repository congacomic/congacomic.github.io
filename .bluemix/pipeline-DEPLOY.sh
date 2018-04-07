#!/usr/bin/env bash

set -ex

source .bluemix/pipeline-COMMON.sh
source .bluemix/pipeline-CLOUDANT.sh
source .bluemix/pipeline-BLOCKCHAIN.sh

export CONTRACTS=$(ls contracts)

function deploy_contracts {
    for CONTRACT in ${CONTRACTS}
    do
        deploy_contract ${CONTRACT}
    done
}

function deploy_contract {
    if [ -f contracts/$1/package.json ]
    then
        deploy_composer_contract $1
        deploy_composer_rest_server $1
    else
        echo unrecognized contract type $1
        exit 1
    fi
}

function deploy_composer_contract {
    CONTRACT=$1
    echo deploying composer contract ${CONTRACT}
    pushd contracts/${CONTRACT}
    BUSINESS_NETWORK_NAME=$(jq --raw-output '.name' package.json)
    BUSINESS_NETWORK_VERSION=$(jq --raw-output '.version' package.json)
    BUSINESS_NETWORK_ARCHIVES=$(ls dist/*.bna)
    BUSINESS_NETWORK_CARD=admin@${BUSINESS_NETWORK_NAME}
    for BUSINESS_NETWORK_ARCHIVE in ${BUSINESS_NETWORK_ARCHIVES}
    do
        if ! OUTPUT=$(composer runtime install -c ${BLOCKCHAIN_NETWORK_CARD} -n ${BUSINESS_NETWORK_NAME} 2>&1)
        # 0.19.x - if ! OUTPUT=$(composer network install -c ${BLOCKCHAIN_NETWORK_CARD} -a ${BUSINESS_NETWORK_ARCHIVES} 2>&1)
        then
            if [[ "${OUTPUT}" != *"already installed"* ]]
            then
                echo failed to install composer contract ${CONTRACT}
                exit 1
            fi
        fi
        while ! OUTPUT=$(composer network start -c ${BLOCKCHAIN_NETWORK_CARD} -a ${BUSINESS_NETWORK_ARCHIVE} -A ${BLOCKCHAIN_NETWORK_ENROLL_ID} -S ${BLOCKCHAIN_NETWORK_ENROLL_SECRET} -f adminCard.card 2>&1)
        # 0.19.x - while ! OUTPUT=$(composer network start -c ${BLOCKCHAIN_NETWORK_CARD} -n ${BUSINESS_NETWORK_NAME} -V ${BUSINESS_NETWORK_VERSION} -A ${BLOCKCHAIN_NETWORK_ENROLL_ID} -S ${BLOCKCHAIN_NETWORK_ENROLL_SECRET} -f adminCard.card 2>&1)
        do
            if [[ "${OUTPUT}" = *"REQUEST_TIMEOUT"* ]]
            then
                sleep 30
            elif [[ "${OUTPUT}" = *"chaincode exists"* ]]
            then
                BUSINESS_NETWORK_UPGRADE=true
                break
            else
                echo failed to start composer contract ${CONTRACT}
                exit 1
            fi
        done
        if [[ "${BUSINESS_NETWORK_UPGRADE}" = "true" ]]
        then
            while ! OUTPUT=$(composer network update -c ${BUSINESS_NETWORK_CARD} -a ${BUSINESS_NETWORK_ARCHIVE} 2>&1)
            # 0.19.x - while ! OUTPUT=$(composer network upgrade -c ${BLOCKCHAIN_NETWORK_CARD} -n ${BUSINESS_NETWORK_NAME} -V ${BUSINESS_NETWORK_VERSION} 2>&1)
            do
                if [[ "${OUTPUT}" = *"REQUEST_TIMEOUT"* ]]
                then
                    sleep 30
                else
                    echo failed to upgrade composer contract ${CONTRACT}
                    exit 1
                fi
            done
        else
            if composer card list -n ${BUSINESS_NETWORK_CARD} > /dev/null 2>&1
            # 0.19.x - if composer card list -c ${BUSINESS_NETWORK_CARD} > /dev/null 2>&1
            then
                composer card delete -n ${BUSINESS_NETWORK_CARD}
                # 0.19.x - composer card delete -c ${BUSINESS_NETWORK_CARD}
            fi
            composer card import -f adminCard.card -n ${BUSINESS_NETWORK_CARD}
            # 0.19.x - composer card import -f adminCard.card -c ${BUSINESS_NETWORK_CARD}
        fi
    done
    popd
}

function deploy_composer_rest_server {
    CONTRACT=$1
    echo deploying composer rest server ${CONTRACT}
    pushd contracts/${CONTRACT}
    BUSINESS_NETWORK_NAME=$(jq --raw-output '.name' package.json)
    BUSINESS_NETWORK_CARD=admin@${BUSINESS_NETWORK_NAME}
    CF_APP_NAME=composer-rest-server-${BUSINESS_NETWORK_NAME}
    cf push \
        ${CF_APP_NAME} \
        --docker-image sstone1/composer-rest-server:0.18.1 \
        -i 1 \
        -m 256M \
        --no-start \
        --no-manifest
    cf set-env ${CF_APP_NAME} NODE_CONFIG "${NODE_CONFIG}"
    cf set-env ${CF_APP_NAME} COMPOSER_CARD ${BUSINESS_NETWORK_CARD}
    cf set-env ${CF_APP_NAME} COMPOSER_NAMESPACES required
    cf set-env ${CF_APP_NAME} COMPOSER_WEBSOCKETS true
    cf start ${CF_APP_NAME}
    popd
}

install_nodejs
install_composer
install_jq
provision_cloudant
create_cloudant_database
configure_composer_wallet
provision_blockchain
create_blockchain_network_card
deploy_contracts