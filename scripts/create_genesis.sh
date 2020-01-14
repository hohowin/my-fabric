# Import common.sh
. `pwd`/common.sh

# CBody
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/cbody.com/msp/admincerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/cbody.com/msp/cacerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/cbody.com/msp/tlscacerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/cbody.com/msp/users

sudo cp  ${_CRYPTO_CONFIG_DIR}/CBodyMSP/orderer0.cbody.com/msp/admincerts/cbody.com-admin-cert.pem  ${_CRYPTO_CONFIG_DIR}/cbody.com/msp/admincerts
sudo cp  ${_CRYPTO_CONFIG_DIR}/CBodyMSP/orderer0.cbody.com/assets/ca/cbody.com-ca-cert.pem  ${_CRYPTO_CONFIG_DIR}/cbody.com/msp/cacerts
sudo cp  ${_CRYPTO_CONFIG_DIR}/CBodyMSP/orderer0.cbody.com/assets/tls-ca/tls-ca-cert.pem  ${_CRYPTO_CONFIG_DIR}/cbody.com/msp/tlscacerts

# PccH
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/pcch.net/msp/admincerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/pcch.net/msp/cacerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/pcch.net/msp/tlscacerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/pcch.net/msp/users

sudo cp  ${_CRYPTO_CONFIG_DIR}/PccHMSP/peer0.pcch.net/msp/admincerts/pcch.net-admin-cert.pem  ${_CRYPTO_CONFIG_DIR}/pcch.net/msp/admincerts
sudo cp  ${_CRYPTO_CONFIG_DIR}/PccHMSP/peer0.pcch.net/assets/ca/pcch.net-ca-cert.pem  ${_CRYPTO_CONFIG_DIR}/pcch.net/msp/cacerts
sudo cp  ${_CRYPTO_CONFIG_DIR}/PccHMSP/peer0.pcch.net/assets/tls-ca/tls-ca-cert.pem  ${_CRYPTO_CONFIG_DIR}/pcch.net/msp/tlscacerts

# HKGov
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/gov.hk/msp/admincerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/gov.hk/msp/cacerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/gov.hk/msp/tlscacerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/gov.hk/msp/users

sudo cp  ${_CRYPTO_CONFIG_DIR}/HKGovMSP/peer0.gov.hk/msp/admincerts/gov.hk-admin-cert.pem  ${_CRYPTO_CONFIG_DIR}/gov.hk/msp/admincerts
sudo cp  ${_CRYPTO_CONFIG_DIR}/HKGovMSP/peer0.gov.hk/assets/ca/gov.hk-ca-cert.pem  ${_CRYPTO_CONFIG_DIR}/gov.hk/msp/cacerts
sudo cp  ${_CRYPTO_CONFIG_DIR}/HKGovMSP/peer0.gov.hk/assets/tls-ca/tls-ca-cert.pem  ${_CRYPTO_CONFIG_DIR}/gov.hk/msp/tlscacerts

# Ubuntu requires ownership of orderer certs
sudo chown -R $(whoami) ${_CRYPTO_CONFIG_DIR}/cbody.com

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
