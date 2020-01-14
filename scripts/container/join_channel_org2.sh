cp /var/artifacts/crypto-config/PccHMSP/peer0.pcch.net/assets/genericchannel.block /var/artifacts/crypto-config/HKGovMSP/peer0.gov.hk/assets

mkdir -p /var/artifacts/crypto-config/HKGovMSP/admin/msp/admincerts
cp /var/artifacts/crypto-config/HKGovMSP/peer0.gov.hk/msp/admincerts/gov.hk-admin-cert.pem /var/artifacts/crypto-config/HKGovMSP/admin/msp/admincerts

export CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/HKGovMSP/admin/msp

# peer0 joining the channel
export CORE_PEER_ADDRESS=peer0.gov.hk:7251
peer channel join -b /var/artifacts/crypto-config/HKGovMSP/peer0.gov.hk/assets/genericchannel.block
peer channel getinfo -c genericchannel

# peer1 joining the channel
export CORE_PEER_ADDRESS=peer1.gov.hk:7351
peer channel join -b /var/artifacts/crypto-config/HKGovMSP/peer0.gov.hk/assets/genericchannel.block
peer channel getinfo -c genericchannel

