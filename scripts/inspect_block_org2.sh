if [ $# -ne 1 ]
then
    echo [`date +"%Y-%m-%d %H:%M:%S"`] "Usage: inspect_block_org[x].sh [block]" \
         "(e.g. : ./inspect_block_org1.sh 0)"
    exit 1
fi

block="$1"

# Create directory
docker exec cli.gov.wakanda mkdir -p /var/artifacts/inspect_block

# Generate block
docker exec \
        -e "CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/WakandaGovMSP/admin/msp" \
        -e "CORE_PEER_ADDRESS=peer0.gov.wakanda:7251" \
        cli.gov.wakanda \
        peer channel fetch ${block} /var/artifacts/inspect_block/genericchannel_${block}.block -o orderer0.cbody.com:7050 -c genericchannel --tls --cafile "/var/artifacts/crypto-config/WakandaGovMSP/peer0.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem"

sleep 2

# Convert to JSON
docker exec cli.gov.wakanda sh -c "cd /var/artifacts/inspect_block; configtxgen -inspectBlock genericchannel_${block}.block > genericchannel_${block}.json"

