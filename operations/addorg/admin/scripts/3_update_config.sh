export _CRYPTO_CONFIG_DIR=../../../../artifacts/crypto-config/

# Rebel
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/RebelMSP/msp/admincerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/RebelMSP/msp/cacerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/RebelMSP/msp/tlscacerts
sudo mkdir -p ${_CRYPTO_CONFIG_DIR}/RebelMSP/msp/users

sudo cp  ${_CRYPTO_CONFIG_DIR}/RebelMSP/peer1.rebel.inc/msp/admincerts/rebel.inc-admin-cert.pem  ${_CRYPTO_CONFIG_DIR}/RebelMSP/msp/admincerts
sudo cp  ${_CRYPTO_CONFIG_DIR}/RebelMSP/peer1.rebel.inc/assets/ca/rebel.inc-ca-cert.pem  ${_CRYPTO_CONFIG_DIR}/RebelMSP/msp/cacerts
sudo cp  ${_CRYPTO_CONFIG_DIR}/RebelMSP/peer1.rebel.inc/assets/tls-ca/tls-ca-cert.pem  ${_CRYPTO_CONFIG_DIR}/RebelMSP/msp/tlscacerts

cd ../config; 
export FABRIC_CFG_PATH=${PWD}
../../../../bin/configtxgen -printOrg Rebel > Rebel.json
