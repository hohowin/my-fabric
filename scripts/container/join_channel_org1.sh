mkdir -p /var/artifacts/crypto-config/pcch.net/admin/msp/admincerts
cp /var/artifacts/crypto-config/pcch.net/peer0/msp/admincerts/pcch.net-admin-cert.pem /var/artifacts/crypto-config/pcch.net/admin/msp/admincerts

export CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/pcch.net/admin/msp
peer channel create -c genericchannel -f /var/artifacts/crypto-config/pcch.net/peer0/assets/channel.tx -o orderer0.cbody.com:7050 \
    --outputBlock /var/artifacts/crypto-config/pcch.net/peer0/assets/genericchannel.block \
    --tls --cafile /var/artifacts/crypto-config/pcch.net/peer0/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

export CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/pcch.net/admin/msp

# peer0 joining the channel
export CORE_PEER_ADDRESS=peer0.pcch.net:7051
peer channel join -b /var/artifacts/crypto-config/pcch.net/peer0/assets/genericchannel.block
peer channel getinfo -c genericchannel

# peer1 joining the channel
export CORE_PEER_ADDRESS=peer1.pcch.net:7151
peer channel join -b /var/artifacts/crypto-config/pcch.net/peer0/assets/genericchannel.block
peer channel getinfo -c genericchannel

