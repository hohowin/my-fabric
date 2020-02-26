export CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/WakandaGovMSP/admin/msp
export CORE_PEER_ADDRESS=peer0.gov.wakanda:7251

# Update anchor peer
peer channel update -c genericchannel -f /var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/assets/WakandaGovAnchors.tx \
    -o orderer0.cbody.com:7050 \
    --tls --cafile /var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem
