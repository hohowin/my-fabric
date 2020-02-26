# Import common.sh
. `pwd`/common.sh

cd ${_FABRIC_DIR}; 
export FABRIC_CFG_PATH=${PWD}

# Update Anchor peer
${_FABRIC_DIR}/../bin/configtxgen -profile OrgsChannel -outputAnchorPeersUpdate PccHAnchors.tx -channelID genericchannel -asOrg PccH
mkdir -p ${_CRYPTO_CONFIG_DIR}/PccHMSP/peer0.pcch.net/assets
sudo mv PccHAnchors.tx ${_CRYPTO_CONFIG_DIR}/PccHMSP/peer0.pcch.net/assets
${_FABRIC_DIR}/../bin/configtxgen -profile OrgsChannel -outputAnchorPeersUpdate WakandaGovAnchors.tx -channelID genericchannel -asOrg WakandaGov
mkdir -p ${_CRYPTO_CONFIG_DIR}/WakandaGovMSP/peer0.gov.wakanda/assets
sudo mv WakandaGovAnchors.tx ${_CRYPTO_CONFIG_DIR}/WakandaGovMSP/peer0.gov.wakanda/assets

sleep 2

docker exec cli.pcch.net sh -c "/setup/update_anchor_org1.sh"
docker exec cli.gov.wakanda sh -c "/setup/update_anchor_org2.sh"
