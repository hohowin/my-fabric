cp /var/artifacts/crypto-config/PccHMSP/peer0.pcch.net/assets/genericchannel.block /var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/assets

mkdir -p /var/artifacts/crypto-config/WakandaGovMSP/admin/msp/admincerts
cp /var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/msp/admincerts/gov.wakanda-admin-cert.pem /var/artifacts/crypto-config/WakandaGovMSP/admin/msp/admincerts

export CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/WakandaGovMSP/admin/msp

# peer0 joining the channel
export CORE_PEER_ADDRESS=peer0.gov.wakanda:7251
peer channel join -b /var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/assets/genericchannel.block
peer channel list
peer channel getinfo -c genericchannel

# peer1 joining the channel
export CORE_PEER_ADDRESS=peer1.gov.wakanda:7351
peer channel join -b /var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/assets/genericchannel.block
peer channel list
peer channel getinfo -c genericchannel

