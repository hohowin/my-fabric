cp /var/artifacts/crypto-config/PccHMSP/peer0.pcch.net/assets/genericchannel.block /var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/assets

mkdir -p /var/artifacts/crypto-config/WakandaGovMSP/admin/msp/admincerts
cp /var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/msp/admincerts/gov.wakanda-admin-cert.pem /var/artifacts/crypto-config/WakandaGovMSP/admin/msp/admincerts

export CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/WakandaGovMSP/admin/msp

# peer0 joining the channel
export CORE_PEER_ADDRESS=peer0.gov.wakanda:7251
peer channel join -b /var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/assets/genericchannel.block
peer channel getinfo -c genericchannel

# peer1 joining the channel
export CORE_PEER_ADDRESS=peer1.gov.wakanda:7351
peer channel join -b /var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/assets/genericchannel.block
peer channel getinfo -c genericchannel

# Update anchor peer
peer channel update -c genericchannel -f /var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/assets/WakandaGovAnchors.tx \
    -o orderer0.cbody.com:7050 \
    --tls --cafile /var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem
