# Import common.sh
. `pwd`/common.sh

# CBody
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/cbody.com/msp/admincerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/cbody.com/msp/cacerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/cbody.com/msp/tlscacerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/cbody.com/msp/users

sudo cp  ${_CRYPTO_CONFIG_DIR}/cbody.com/orderer0/msp/admincerts/cbody.com-admin-cert.pem  ${_CRYPTO_CONFIG_DIR}/cbody.com/msp/admincerts
sudo cp  ${_CRYPTO_CONFIG_DIR}/cbody.com/orderer0/assets/ca/cbody.com-ca-cert.pem  ${_CRYPTO_CONFIG_DIR}/cbody.com/msp/cacerts
sudo cp  ${_CRYPTO_CONFIG_DIR}/cbody.com/orderer0/assets/tls-ca/tls-ca-cert.pem  ${_CRYPTO_CONFIG_DIR}/cbody.com/msp/tlscacerts

# PccH
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/pcch.net/msp/admincerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/pcch.net/msp/cacerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/pcch.net/msp/tlscacerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/pcch.net/msp/users

sudo cp  ${_CRYPTO_CONFIG_DIR}/pcch.net/peer0/msp/admincerts/pcch.net-admin-cert.pem  ${_CRYPTO_CONFIG_DIR}/pcch.net/msp/admincerts
sudo cp  ${_CRYPTO_CONFIG_DIR}/pcch.net/peer0/assets/ca/pcch.net-ca-cert.pem  ${_CRYPTO_CONFIG_DIR}/pcch.net/msp/cacerts
sudo cp  ${_CRYPTO_CONFIG_DIR}/pcch.net/peer0/assets/tls-ca/tls-ca-cert.pem  ${_CRYPTO_CONFIG_DIR}/pcch.net/msp/tlscacerts

# HKGov
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/gov.hk/msp/admincerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/gov.hk/msp/cacerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/gov.hk/msp/tlscacerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/gov.hk/msp/users

sudo cp  ${_CRYPTO_CONFIG_DIR}/gov.hk/peer0/msp/admincerts/gov.hk-admin-cert.pem  ${_CRYPTO_CONFIG_DIR}/gov.hk/msp/admincerts
sudo cp  ${_CRYPTO_CONFIG_DIR}/gov.hk/peer0/assets/ca/gov.hk-ca-cert.pem  ${_CRYPTO_CONFIG_DIR}/gov.hk/msp/cacerts
sudo cp  ${_CRYPTO_CONFIG_DIR}/gov.hk/peer0/assets/tls-ca/tls-ca-cert.pem  ${_CRYPTO_CONFIG_DIR}/gov.hk/msp/tlscacerts

# Ubuntu requires ownership of order certs
sudo chown -R $(whoami):$(whoami) ${_CRYPTO_CONFIG_DIR}/cbody.com

cd ${_FABRIC_DIR}; 
export FABRIC_CFG_PATH=${PWD}
${_FABRIC_DIR}/../bin/configtxgen -profile OrgsOrdererGenesis -outputBlock genesis.block -channelID ordererchannel
${_FABRIC_DIR}/../bin/configtxgen -profile OrgsChannel -outputCreateChannelTx channel.tx -channelID genericchannel

sudo cp genesis.block    ${_CRYPTO_CONFIG_DIR}/cbody.com/orderer0
sudo cp genesis.block    ${_CRYPTO_CONFIG_DIR}/cbody.com/orderer1
sudo cp genesis.block    ${_CRYPTO_CONFIG_DIR}/cbody.com/orderer2
sudo cp genesis.block    ${_CRYPTO_CONFIG_DIR}/cbody.com/orderer3
sudo cp genesis.block    ${_CRYPTO_CONFIG_DIR}/cbody.com/orderer4
sudo mv channel.tx       ${_CRYPTO_CONFIG_DIR}/pcch.net/peer0/assets
