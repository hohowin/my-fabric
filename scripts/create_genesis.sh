# Import common.sh
. `pwd`/common.sh

# CBody
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/CBodyMSP/msp/admincerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/CBodyMSP/msp/cacerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/CBodyMSP/msp/tlscacerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/CBodyMSP/msp/users

sudo cp  ${_CRYPTO_CONFIG_DIR}/CBodyMSP/orderer0.cbody.com/msp/admincerts/cbody.com-admin-cert.pem  ${_CRYPTO_CONFIG_DIR}/CBodyMSP/msp/admincerts
sudo cp  ${_CRYPTO_CONFIG_DIR}/CBodyMSP/orderer0.cbody.com/assets/ca/cbody.com-ca-cert.pem  ${_CRYPTO_CONFIG_DIR}/CBodyMSP/msp/cacerts
sudo cp  ${_CRYPTO_CONFIG_DIR}/CBodyMSP/orderer0.cbody.com/assets/tls-ca/tls-ca-cert.pem  ${_CRYPTO_CONFIG_DIR}/CBodyMSP/msp/tlscacerts

# PccH
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/PccHMSP/msp/admincerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/PccHMSP/msp/cacerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/PccHMSP/msp/tlscacerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/PccHMSP/msp/users

sudo cp  ${_CRYPTO_CONFIG_DIR}/PccHMSP/peer0.pcch.net/msp/admincerts/pcch.net-admin-cert.pem  ${_CRYPTO_CONFIG_DIR}/PccHMSP/msp/admincerts
sudo cp  ${_CRYPTO_CONFIG_DIR}/PccHMSP/peer0.pcch.net/assets/ca/pcch.net-ca-cert.pem  ${_CRYPTO_CONFIG_DIR}/PccHMSP/msp/cacerts
sudo cp  ${_CRYPTO_CONFIG_DIR}/PccHMSP/peer0.pcch.net/assets/tls-ca/tls-ca-cert.pem  ${_CRYPTO_CONFIG_DIR}/PccHMSP/msp/tlscacerts

# HKGov
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/HKGovMSP/msp/admincerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/HKGovMSP/msp/cacerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/HKGovMSP/msp/tlscacerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/HKGovMSP/msp/users

sudo cp  ${_CRYPTO_CONFIG_DIR}/HKGovMSP/peer0.gov.hk/msp/admincerts/gov.hk-admin-cert.pem  ${_CRYPTO_CONFIG_DIR}/HKGovMSP/msp/admincerts
sudo cp  ${_CRYPTO_CONFIG_DIR}/HKGovMSP/peer0.gov.hk/assets/ca/gov.hk-ca-cert.pem  ${_CRYPTO_CONFIG_DIR}/HKGovMSP/msp/cacerts
sudo cp  ${_CRYPTO_CONFIG_DIR}/HKGovMSP/peer0.gov.hk/assets/tls-ca/tls-ca-cert.pem  ${_CRYPTO_CONFIG_DIR}/HKGovMSP/msp/tlscacerts

# Ubuntu requires ownership of orderer certs
sudo chown -R $(whoami) ${_CRYPTO_CONFIG_DIR}/CBodyMSP/orderer0.cbody.com
sudo chown -R $(whoami) ${_CRYPTO_CONFIG_DIR}/CBodyMSP/orderer1.cbody.com
sudo chown -R $(whoami) ${_CRYPTO_CONFIG_DIR}/CBodyMSP/orderer2.cbody.com
sudo chown -R $(whoami) ${_CRYPTO_CONFIG_DIR}/CBodyMSP/orderer3.cbody.com
sudo chown -R $(whoami) ${_CRYPTO_CONFIG_DIR}/CBodyMSP/orderer4.cbody.com

cd ${_FABRIC_DIR}; 
export FABRIC_CFG_PATH=${PWD}
${_FABRIC_DIR}/../bin/configtxgen -profile OrgsOrdererGenesis -outputBlock genesis.block -channelID ordererchannel
${_FABRIC_DIR}/../bin/configtxgen -profile OrgsChannel -outputCreateChannelTx channel.tx -channelID genericchannel

sudo cp genesis.block    ${_CRYPTO_CONFIG_DIR}/CBodyMSP/orderer0.cbody.com
sudo cp genesis.block    ${_CRYPTO_CONFIG_DIR}/CBodyMSP/orderer1.cbody.com
sudo cp genesis.block    ${_CRYPTO_CONFIG_DIR}/CBodyMSP/orderer2.cbody.com
sudo cp genesis.block    ${_CRYPTO_CONFIG_DIR}/CBodyMSP/orderer3.cbody.com
sudo cp genesis.block    ${_CRYPTO_CONFIG_DIR}/CBodyMSP/orderer4.cbody.com
sudo mv channel.tx       ${_CRYPTO_CONFIG_DIR}/PccHMSP/peer0.pcch.net/assets
