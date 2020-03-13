##############
# Environments
##############

export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export NC='\033[0m'

export COMPOSE_PROJECT_NAME=myproject
export IMAGE_TAG=1.4.6
export DOCKER_CRYPTO=/var/artifacts/crypto-config/

##############
# Functions
##############

print() {
  MESSAGE=$1
  CODE=$2

  if [ $2 -ne 0 ] ; then
    printf "${RED}${MESSAGE} failed${NC}\n"
    exit -1
  fi
  printf "${GREEN}Complete ${MESSAGE}${NC}\n\n"
  sleep 1
}

subject() {
    printf "${YELLOW}"
    echo ''
    echo '####'
    echo '#### ' $1
    echo '####'
    echo ''
    printf "${NC}"
}

#############################
#     Start Bootstrap       #
#############################
#
subject "Start CA Servers..."
#

docker-compose -f config/caservers.yaml up -d
print "docker-compose -f config/caservers.yaml up -d" $?

#############################
#
subject "Generate Certs..."
#

docker exec tls-ca.cbody.com sh -c "/setup/enroll_tls.sh"
print "enroll TLS Certs" $?
docker exec rca.cbody.com sh -c "/setup/enroll_org0.sh"
print "enroll for CBody" $?
docker exec rca.pcch.net sh -c "/setup/enroll_org1.sh"
print "enroll for PccH" $?
docker exec rca.gov.wakanda sh -c "/setup/enroll_org2.sh"
print "enroll for WakandaGov" $?

#############################
#
subject "Start Peer Nodes..."
#

docker-compose -f config/peernodes.yaml up -d
print "docker-compose -f config/peernodes.yaml up -d" $?

#############################
#
subject "Create Genesis Block..."
#

# CBody
docker exec cli sh -c "mkdir -p ${DOCKER_CRYPTO}CBodyMSP/msp/admincerts"
docker exec cli sh -c "mkdir -p ${DOCKER_CRYPTO}CBodyMSP/msp/cacerts"
docker exec cli sh -c "mkdir -p ${DOCKER_CRYPTO}CBodyMSP/msp/tlscacerts"
docker exec cli sh -c "mkdir -p ${DOCKER_CRYPTO}CBodyMSP/msp/users"

docker exec cli sh -c "cp ${DOCKER_CRYPTO}CBodyMSP/orderer0.cbody.com/msp/admincerts/cbody.com-admin-cert.pem ${DOCKER_CRYPTO}CBodyMSP/msp/admincerts"
docker exec cli sh -c "cp ${DOCKER_CRYPTO}CBodyMSP/orderer0.cbody.com/assets/ca/cbody.com-ca-cert.pem ${DOCKER_CRYPTO}CBodyMSP/msp/cacerts"
docker exec cli sh -c "cp ${DOCKER_CRYPTO}CBodyMSP/orderer0.cbody.com/assets/tls-ca/tls-ca-cert.pem ${DOCKER_CRYPTO}CBodyMSP/msp/tlscacerts"

print "preparing certs for CBody" $?

# PccH
docker exec cli sh -c "mkdir -p ${DOCKER_CRYPTO}PccHMSP/msp/admincerts"
docker exec cli sh -c "mkdir -p ${DOCKER_CRYPTO}PccHMSP/msp/cacerts"
docker exec cli sh -c "mkdir -p ${DOCKER_CRYPTO}PccHMSP/msp/tlscacerts"
docker exec cli sh -c "mkdir -p ${DOCKER_CRYPTO}PccHMSP/msp/users"

docker exec cli sh -c "cp ${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/msp/admincerts/pcch.net-admin-cert.pem ${DOCKER_CRYPTO}PccHMSP/msp/admincerts"
docker exec cli sh -c "cp ${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/assets/ca/pcch.net-ca-cert.pem ${DOCKER_CRYPTO}PccHMSP/msp/cacerts"
docker exec cli sh -c "cp ${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/assets/tls-ca/tls-ca-cert.pem ${DOCKER_CRYPTO}PccHMSP/msp/tlscacerts"

print "preparing certs for PccH" $?

# WakandaGov
docker exec cli sh -c "mkdir -p ${DOCKER_CRYPTO}WakandaGovMSP/msp/admincerts"
docker exec cli sh -c "mkdir -p ${DOCKER_CRYPTO}WakandaGovMSP/msp/cacerts"
docker exec cli sh -c "mkdir -p ${DOCKER_CRYPTO}WakandaGovMSP/msp/tlscacerts"
docker exec cli sh -c "mkdir -p ${DOCKER_CRYPTO}WakandaGovMSP/msp/users"

docker exec cli sh -c "cp ${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/msp/admincerts/gov.wakanda-admin-cert.pem ${DOCKER_CRYPTO}WakandaGovMSP/msp/admincerts"
docker exec cli sh -c "cp ${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/assets/ca/gov.wakanda-ca-cert.pem ${DOCKER_CRYPTO}WakandaGovMSP/msp/cacerts"
docker exec cli sh -c "cp ${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/assets/tls-ca/tls-ca-cert.pem ${DOCKER_CRYPTO}WakandaGovMSP/msp/tlscacerts"

print "preparing certs for WakandaGov" $?

docker exec -w "/config" -e "FABRIC_CFG_PATH=/config" cli sh -c \
  "configtxgen -profile OrgsOrdererGenesis -outputBlock genesis.block -channelID ordererchannel"
print "preparing genesis.block" $?

docker exec -w "/config" -e "FABRIC_CFG_PATH=/config" cli sh -c \
  "configtxgen -profile OrgsChannel -outputCreateChannelTx channel.tx -channelID genericchannel"
print "preparing channel.tx" $?

docker exec -w "/config" cli sh -c "cp genesis.block ${DOCKER_CRYPTO}CBodyMSP/orderer0.cbody.com"
docker exec -w "/config" cli sh -c "cp genesis.block ${DOCKER_CRYPTO}CBodyMSP/orderer1.cbody.com"
docker exec -w "/config" cli sh -c "cp genesis.block ${DOCKER_CRYPTO}CBodyMSP/orderer2.cbody.com"
docker exec -w "/config" cli sh -c "cp genesis.block ${DOCKER_CRYPTO}CBodyMSP/orderer3.cbody.com"
docker exec -w "/config" cli sh -c "cp genesis.block ${DOCKER_CRYPTO}CBodyMSP/orderer4.cbody.com"
docker exec -w "/config" cli sh -c "rm genesis.block"

docker exec -w "/config" cli sh -c "cp channel.tx ${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/assets"
docker exec -w "/config" cli sh -c "rm channel.tx"

print "creating genesis block" $?

#############################
#
subject "Start Ordering Service Nodes..."
#

docker-compose -f config/orderers.yaml -f config/cadvisor.yaml up -d
print "docker-compose -f config/orderers.yaml up -d" $?

#############################
#
subject "Join channels..."
#

# Prepare admin certs
docker exec cli sh -c "mkdir -p ${DOCKER_CRYPTO}PccHMSP/admin/msp/admincerts"
docker exec cli sh -c "cp ${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/msp/admincerts/pcch.net-admin-cert.pem ${DOCKER_CRYPTO}PccHMSP/admin/msp/admincerts"
docker exec cli sh -c "mkdir -p ${DOCKER_CRYPTO}WakandaGovMSP/admin/msp/admincerts"
docker exec cli sh -c "cp ${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/msp/admincerts/gov.wakanda-admin-cert.pem ${DOCKER_CRYPTO}WakandaGovMSP/admin/msp/admincerts"

# Create channel
docker exec \
  -w "/var/artifacts" \
  -e "CORE_PEER_ADDRESS=peer0.pcch.net:7051" \
  -e "CORE_PEER_LOCALMSPID=PccHMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}PccHMSP/admin/msp" \
  cli peer channel create -c genericchannel -f ${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/assets/channel.tx -o orderer0.cbody.com:7050 \
    --outputBlock genericchannel.block \
    --tls --cafile ${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

print "peer channel create" $?

# PccH peer0 join channel
docker exec -w "/var/artifacts" cli sh -c "cp genericchannel.block ${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/assets"

docker exec \
  -e "CORE_PEER_ADDRESS=peer0.pcch.net:7051" \
  -e "CORE_PEER_LOCALMSPID=PccHMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}PccHMSP/admin/msp" \
  cli peer channel join -b ${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/assets/genericchannel.block

print "join channel for PccH peer0" $?

docker exec cli peer channel list
docker exec cli peer channel getinfo -c genericchannel

# PccH peer1 join channel
docker exec -w "/var/artifacts" cli sh -c "cp genericchannel.block ${DOCKER_CRYPTO}PccHMSP/peer1.pcch.net/assets"

docker exec \
  -e "CORE_PEER_ADDRESS=peer1.pcch.net:7151" \
  -e "CORE_PEER_LOCALMSPID=PccHMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}PccHMSP/peer1.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}PccHMSP/admin/msp" \
  cli peer channel join -b ${DOCKER_CRYPTO}PccHMSP/peer1.pcch.net/assets/genericchannel.block

print "join channel for PccH peer1" $?

docker exec cli peer channel list
docker exec cli peer channel getinfo -c genericchannel

# WakandaGov peer0 join channel
docker exec -w "/var/artifacts" cli sh -c "cp genericchannel.block ${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/assets"

docker exec \
  -e "CORE_PEER_ADDRESS=peer0.gov.wakanda:7251" \
  -e "CORE_PEER_LOCALMSPID=WakandaGovMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}WakandaGovMSP/admin/msp" \
  cli peer channel join -b ${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/assets/genericchannel.block

print "join channel for WakandaGov peer0" $?

docker exec cli peer channel list
docker exec cli peer channel getinfo -c genericchannel

# WakandaGov peer1 join channel
docker exec -w "/var/artifacts" cli sh -c "cp genericchannel.block ${DOCKER_CRYPTO}WakandaGovMSP/peer1.gov.wakanda/assets"

docker exec \
  -e "CORE_PEER_ADDRESS=peer1.gov.wakanda:7351" \
  -e "CORE_PEER_LOCALMSPID=WakandaGovMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}WakandaGovMSP/peer1.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}WakandaGovMSP/admin/msp" \
  cli peer channel join -b ${DOCKER_CRYPTO}WakandaGovMSP/peer1.gov.wakanda/assets/genericchannel.block

print "join channel for WakandaGov peer1" $?

docker exec cli peer channel list
docker exec cli peer channel getinfo -c genericchannel

#############################
#
subject "Update Anchor Peer..."
#

docker exec -w "/config" -e "FABRIC_CFG_PATH=/config" cli sh -c \
  "configtxgen -profile OrgsChannel -outputAnchorPeersUpdate ${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/assets/PccHAnchors.tx -channelID genericchannel -asOrg PccH"
print "preparing PccHAnchors.tx" $?

docker exec \
  -e "CORE_PEER_ADDRESS=peer0.pcch.net:7051" \
  -e "CORE_PEER_LOCALMSPID=PccHMSP" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}PccHMSP/admin/msp" \
  cli peer channel update -c genericchannel -f ${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/assets/PccHAnchors.tx \
    -o orderer0.cbody.com:7050 \
    --tls --cafile ${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem
print "update anchor peer for PccH" $?

docker exec -w "/config" -e "FABRIC_CFG_PATH=/config" cli sh -c \
  "configtxgen -profile OrgsChannel -outputAnchorPeersUpdate ${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/assets/WakandaGovAnchors.tx -channelID genericchannel -asOrg WakandaGov"
print "preparing WakandaGovAnchors.tx" $?

docker exec \
  -e "CORE_PEER_ADDRESS=peer0.gov.wakanda:7251" \
  -e "CORE_PEER_LOCALMSPID=WakandaGovMSP" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}WakandaGovMSP/admin/msp" \
  cli peer channel update -c genericchannel -f ${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/assets/WakandaGovAnchors.tx \
    -o orderer0.cbody.com:7050 \
    --tls --cafile ${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem
print "update anchor peer for WakandaGov" $?

#############################

subject "Fabric network started!"