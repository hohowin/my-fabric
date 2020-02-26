export CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/PccHMSP/admin/msp
export CORE_PEER_ADDRESS=peer0.pcch.net:7051

# Update anchor peer
peer channel update -c genericchannel -f /var/artifacts/crypto-config/PccHMSP/peer0.pcch.net/assets/PccHAnchors.tx \
    -o orderer0.cbody.com:7050 \
    --tls --cafile /var/artifacts/crypto-config/PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem
