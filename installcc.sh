#!/bin/bash

##############
# Environments
##############

export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export NC='\033[0m'
export DOCKER_CRYPTO=/var/artifacts/crypto-config/

##############
# Functions
##############

print() {
  MESSAGE=$1
  CODE=$2

  if [ $2 -ne 0 ] ; then
    printf "${RED}[`date +"%Y-%m-%d %H:%M:%S"`] ${MESSAGE} failed${NC}\n"
    exit -1
  fi
  printf "${GREEN}[`date +"%Y-%m-%d %H:%M:%S"`] Complete ${MESSAGE}${NC}\n\n"
  sleep 1
}

subject() {
    printf "${YELLOW}"
    echo ''
    echo '####'
    echo '#### ' $1
#    echo '#### '[`date +"%Y-%m-%d %H:%M:%S"`]
    echo '####'
    echo ''
    printf "${NC}"
}

#############################
#         Install           #
#############################
#
subject "Build Chaincode..."
#

cd chaincode/fabcar
yarn install
yarn build
print "build fabcar" $?

cd ../op
yarn install
yarn build
print "build op" $?

#############################
#
subject "Install Chaincode..."
#

# Install chaincode
docker exec \
  -e "CORE_PEER_ADDRESS=peer0.pcch.net:7051" \
  -e "CORE_PEER_LOCALMSPID=PccHMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}PccHMSP/admin/msp" \
  cli peer chaincode install -n eventstore -v 1.0 -p /opt/gopath/src/github.com/hyperledger/fabric/chaincode/op -l node \
    --tls --cafile ${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

print "install eventstore on PccH peer0" $?

docker exec \
  -e "CORE_PEER_ADDRESS=peer0.pcch.net:7051" \
  -e "CORE_PEER_LOCALMSPID=PccHMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}PccHMSP/admin/msp" \
  cli peer chaincode install -n privatedata -v 1.0 -p /opt/gopath/src/github.com/hyperledger/fabric/chaincode/op -l node \
    --tls --cafile ${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

print "install privatedata on PccH peer0" $?

docker exec \
  -e "CORE_PEER_ADDRESS=peer0.pcch.net:7051" \
  -e "CORE_PEER_LOCALMSPID=PccHMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}PccHMSP/admin/msp" \
  cli peer chaincode list --installed

print "list chaincode on PccH peer0" $?

docker exec \
  -e "CORE_PEER_ADDRESS=peer1.pcch.net:7151" \
  -e "CORE_PEER_LOCALMSPID=PccHMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}PccHMSP/peer1.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}PccHMSP/admin/msp" \
  cli peer chaincode install -n eventstore -v 1.0 -p /opt/gopath/src/github.com/hyperledger/fabric/chaincode/op -l node \
    --tls --cafile ${DOCKER_CRYPTO}PccHMSP/peer1.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

print "install eventstore on PccH peer1" $?

docker exec \
  -e "CORE_PEER_ADDRESS=peer1.pcch.net:7151" \
  -e "CORE_PEER_LOCALMSPID=PccHMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}PccHMSP/peer1.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}PccHMSP/admin/msp" \
  cli peer chaincode install -n privatedata -v 1.0 -p /opt/gopath/src/github.com/hyperledger/fabric/chaincode/op -l node \
    --tls --cafile ${DOCKER_CRYPTO}PccHMSP/peer1.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

print "install privatedata on PccH peer1" $?

docker exec \
  -e "CORE_PEER_ADDRESS=peer1.pcch.net:7151" \
  -e "CORE_PEER_LOCALMSPID=PccHMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}PccHMSP/peer1.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}PccHMSP/admin/msp" \
  cli peer chaincode list --installed

print "list chaincode on PccH peer1" $?

docker exec \
  -e "CORE_PEER_ADDRESS=peer0.gov.wakanda:7251" \
  -e "CORE_PEER_LOCALMSPID=WakandaGovMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}WakandaGovMSP/admin/msp" \
  cli peer chaincode install -n eventstore -v 1.0 -p /opt/gopath/src/github.com/hyperledger/fabric/chaincode/op -l node \
    --tls --cafile ${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

print "install eventstore on WakandaGov peer0" $?

docker exec \
  -e "CORE_PEER_ADDRESS=peer0.gov.wakanda:7251" \
  -e "CORE_PEER_LOCALMSPID=WakandaGovMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}WakandaGovMSP/admin/msp" \
  cli peer chaincode install -n privatedata -v 1.0 -p /opt/gopath/src/github.com/hyperledger/fabric/chaincode/op -l node \
    --tls --cafile ${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

print "install privatedata on WakandaGov peer0" $?

docker exec \
  -e "CORE_PEER_ADDRESS=peer0.gov.wakanda:7251" \
  -e "CORE_PEER_LOCALMSPID=WakandaGovMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}WakandaGovMSP/admin/msp" \
  cli peer chaincode list --installed

print "list chaincode on WakandaGov peer0" $?

docker exec \
  -e "CORE_PEER_ADDRESS=peer1.gov.wakanda:7351" \
  -e "CORE_PEER_LOCALMSPID=WakandaGovMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}WakandaGovMSP/peer1.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}WakandaGovMSP/admin/msp" \
  cli peer chaincode install -n eventstore -v 1.0 -p /opt/gopath/src/github.com/hyperledger/fabric/chaincode/op -l node \
    --tls --cafile ${DOCKER_CRYPTO}WakandaGovMSP/peer1.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

print "install eventstore on WakandaGov peer1" $?

docker exec \
  -e "CORE_PEER_ADDRESS=peer1.gov.wakanda:7351" \
  -e "CORE_PEER_LOCALMSPID=WakandaGovMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}WakandaGovMSP/peer1.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}WakandaGovMSP/admin/msp" \
  cli peer chaincode install -n privatedata -v 1.0 -p /opt/gopath/src/github.com/hyperledger/fabric/chaincode/op -l node \
    --tls --cafile ${DOCKER_CRYPTO}WakandaGovMSP/peer1.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

print "install privatedata on WakandaGov peer1" $?

docker exec \
  -e "CORE_PEER_ADDRESS=peer1.gov.wakanda:7351" \
  -e "CORE_PEER_LOCALMSPID=WakandaGovMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}WakandaGovMSP/peer1.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}WakandaGovMSP/admin/msp" \
  cli peer chaincode list --installed

print "list chaincode on WakandaGov peer1" $?


#############################
#        Instantiate        #
#############################
#
subject "Instantiate Chaincode..."
#

docker exec \
  -e "CORE_PEER_ADDRESS=peer0.pcch.net:7051" \
  -e "CORE_PEER_LOCALMSPID=PccHMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}PccHMSP/admin/msp" \
  cli peer chaincode instantiate \
    -o orderer0.cbody.com:7050 \
    -C genericchannel -n eventstore -v 1.0 -l node \
    -c '{"Args":["eventstore:instantiate"]}' -P "OR ('PccHMSP.member' ,'WakandaGovMSP.member')" \
    --tls --cafile ${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem 

print "instantiate eventstore" $?
sleep 2

docker exec \
  -e "CORE_PEER_ADDRESS=peer0.pcch.net:7051" \
  -e "CORE_PEER_LOCALMSPID=PccHMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}PccHMSP/admin/msp" \
  cli peer chaincode instantiate \
    -o orderer0.cbody.com:7050 \
    -C genericchannel -n privatedata -v 1.0 -l node \
    -c '{"Args":["privatedata:instantiate"]}' -P "OR ('PccHMSP.member' ,'WakandaGovMSP.member')" \
    --tls --cafile ${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem --collections-config /opt/gopath/src/github.com/hyperledger/fabric/chaincode/op/collections.json

print "instantiate privatedata" $?
sleep 2


#############################
#          Invoke           #
#############################
#
subject "Invoke Chaincode..."
#

# Invoke event store
docker exec \
  -e "CORE_PEER_ADDRESS=peer0.pcch.net:7051" \
  -e "CORE_PEER_LOCALMSPID=PccHMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}PccHMSP/admin/msp" \
  cli peer chaincode invoke \
    -o orderer0.cbody.com:7050 \
    -C genericchannel -n eventstore --waitForEvent \
    -c '{"Args":["createCommit", "dev_entity", "ent_dev_org1", "0","[{\"type\":\"mon\"}]", "ent_dev_org1"]}' \
    --tls --cafile ${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

print "invoke event store on PccH peer0" $?

# Query event store
docker exec \
  -e "CORE_PEER_ADDRESS=peer0.pcch.net:7051" \
  -e "CORE_PEER_LOCALMSPID=PccHMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}PccHMSP/admin/msp" \
  cli peer chaincode invoke \
    -o orderer0.cbody.com:7050 \
    -C genericchannel -n eventstore --waitForEvent \
    -c '{"Args":["eventstore:queryByEntityName","dev_entity"]}' \
    --tls --cafile ${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

print "query event store on PccH peer0" $?

# Invoke private data
export COMMIT=$(echo -n "{\"eventString\":\"[]\"}" | base64 | tr -d \\n);

docker exec \
  -e "CORE_PEER_ADDRESS=peer0.pcch.net:7051" \
  -e "CORE_PEER_LOCALMSPID=PccHMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}PccHMSP/admin/msp" \
  cli peer chaincode invoke \
    -o orderer0.cbody.com:7050 \
    -C genericchannel -n privatedata --waitForEvent \
    -c '{"Args":["privatedata:createCommit","PccHPrivateDetails","private_entityName","private_org1","0","private_org1"]}' \
    --transient "{\"eventstr\":\"$COMMIT\"}" \
    --tls --cafile ${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

 print "invoke private data on PccH peer0" $?

# Query private data
docker exec \
  -e "CORE_PEER_ADDRESS=peer0.pcch.net:7051" \
  -e "CORE_PEER_LOCALMSPID=PccHMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}PccHMSP/admin/msp" \
  cli peer chaincode invoke \
    -o orderer0.cbody.com:7050 \
    -C genericchannel -n privatedata --waitForEvent \
    -c '{"Args":["privatedata:queryByEntityName","PccHPrivateDetails","private_entityName"]}' \
    --tls --cafile ${DOCKER_CRYPTO}PccHMSP/peer0.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

print "query private data on PccH peer0" $?
sleep 3

# Invoke event store
docker exec \
  -e "CORE_PEER_ADDRESS=peer1.pcch.net:7151" \
  -e "CORE_PEER_LOCALMSPID=PccHMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}PccHMSP/peer1.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}PccHMSP/admin/msp" \
  cli peer chaincode invoke \
    -o orderer0.cbody.com:7050 \
    -C genericchannel -n eventstore --waitForEvent \
    -c '{"Args":["createCommit", "dev_entity", "ent_dev_org1", "0","[{\"type\":\"mon\"}]", "ent_dev_org1"]}' \
    --tls --cafile ${DOCKER_CRYPTO}PccHMSP/peer1.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

print "invoke event store on PccH peer1" $?

# Query event store
docker exec \
  -e "CORE_PEER_ADDRESS=peer1.pcch.net:7151" \
  -e "CORE_PEER_LOCALMSPID=PccHMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}PccHMSP/peer1.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}PccHMSP/admin/msp" \
  cli peer chaincode invoke \
    -o orderer0.cbody.com:7050 \
    -C genericchannel -n eventstore --waitForEvent \
    -c '{"Args":["eventstore:queryByEntityName","dev_entity"]}' \
    --tls --cafile ${DOCKER_CRYPTO}PccHMSP/peer1.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

print "query event store on PccH peer1" $?

# Invoke private data
export COMMIT=$(echo -n "{\"eventString\":\"[]\"}" | base64 | tr -d \\n);

docker exec \
  -e "CORE_PEER_ADDRESS=peer1.pcch.net:7151" \
  -e "CORE_PEER_LOCALMSPID=PccHMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}PccHMSP/peer1.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}PccHMSP/admin/msp" \
  cli peer chaincode invoke \
    -o orderer0.cbody.com:7050 \
    -C genericchannel -n privatedata --waitForEvent \
    -c '{"Args":["privatedata:createCommit","PccHPrivateDetails","private_entityName","private_org1","0","private_org1"]}' \
    --transient "{\"eventstr\":\"$COMMIT\"}" \
    --tls --cafile ${DOCKER_CRYPTO}PccHMSP/peer1.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

 print "invoke private data on PccH peer1" $?

# Query private data
docker exec \
  -e "CORE_PEER_ADDRESS=peer1.pcch.net:7151" \
  -e "CORE_PEER_LOCALMSPID=PccHMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}PccHMSP/peer1.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}PccHMSP/admin/msp" \
  cli peer chaincode invoke \
    -o orderer0.cbody.com:7050 \
    -C genericchannel -n privatedata --waitForEvent \
    -c '{"Args":["privatedata:queryByEntityName","PccHPrivateDetails","private_entityName"]}' \
    --tls --cafile ${DOCKER_CRYPTO}PccHMSP/peer1.pcch.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

print "query private data on PccH peer1" $?
sleep 3

# Invoke event store
docker exec \
  -e "CORE_PEER_ADDRESS=peer0.gov.wakanda:7251" \
  -e "CORE_PEER_LOCALMSPID=WakandaGovMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}WakandaGovMSP/admin/msp" \
  cli peer chaincode invoke \
    -o orderer0.cbody.com:7050 \
    -C genericchannel -n eventstore --waitForEvent \
    -c '{"Args":["createCommit", "dev_entity", "ent_dev_org2", "0","[{\"type\":\"mon\"}]", "ent_dev_org2"]}' \
    --tls --cafile ${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

print "invoke event store on WakandaGov peer0" $?

# Query event store
docker exec \
  -e "CORE_PEER_ADDRESS=peer0.gov.wakanda:7251" \
  -e "CORE_PEER_LOCALMSPID=WakandaGovMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}WakandaGovMSP/admin/msp" \
  cli peer chaincode invoke \
    -o orderer0.cbody.com:7050 \
    -C genericchannel -n eventstore --waitForEvent \
    -c '{"Args":["eventstore:queryByEntityName","dev_entity"]}' \
    --tls --cafile ${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

print "query event store on WakandaGov peer0" $?

# Invoke private data
export COMMIT=$(echo -n "{\"eventString\":\"[]\"}" | base64 | tr -d \\n);

docker exec \
  -e "CORE_PEER_ADDRESS=peer0.gov.wakanda:7251" \
  -e "CORE_PEER_LOCALMSPID=WakandaGovMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}WakandaGovMSP/admin/msp" \
  cli peer chaincode invoke \
    -o orderer0.cbody.com:7050 \
    -C genericchannel -n privatedata --waitForEvent \
    -c '{"Args":["privatedata:createCommit","WakandaGovPrivateDetails","private_entityName","private_org2","0","private_org2"]}' \
    --transient "{\"eventstr\":\"$COMMIT\"}" \
    --tls --cafile ${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

 print "invoke private data on WakandaGov peer0" $?

# Query private data
docker exec \
  -e "CORE_PEER_ADDRESS=peer0.gov.wakanda:7251" \
  -e "CORE_PEER_LOCALMSPID=WakandaGovMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}WakandaGovMSP/admin/msp" \
  cli peer chaincode invoke \
    -o orderer0.cbody.com:7050 \
    -C genericchannel -n privatedata --waitForEvent \
    -c '{"Args":["privatedata:queryByEntityName","WakandaGovPrivateDetails","private_entityName"]}' \
    --tls --cafile ${DOCKER_CRYPTO}WakandaGovMSP/peer0.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

print "query private data on WakandaGov peer0" $?
sleep 3

# Invoke event store
docker exec \
  -e "CORE_PEER_ADDRESS=peer1.gov.wakanda:7351" \
  -e "CORE_PEER_LOCALMSPID=WakandaGovMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}WakandaGovMSP/peer1.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}WakandaGovMSP/admin/msp" \
  cli peer chaincode invoke \
    -o orderer0.cbody.com:7050 \
    -C genericchannel -n eventstore --waitForEvent \
    -c '{"Args":["createCommit", "dev_entity", "ent_dev_org2", "0","[{\"type\":\"mon\"}]", "ent_dev_org2"]}' \
    --tls --cafile ${DOCKER_CRYPTO}WakandaGovMSP/peer1.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

print "invoke event store on WakandaGov peer1" $?

# Query event store
docker exec \
  -e "CORE_PEER_ADDRESS=peer1.gov.wakanda:7351" \
  -e "CORE_PEER_LOCALMSPID=WakandaGovMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}WakandaGovMSP/peer1.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}WakandaGovMSP/admin/msp" \
  cli peer chaincode invoke \
    -o orderer0.cbody.com:7050 \
    -C genericchannel -n eventstore --waitForEvent \
    -c '{"Args":["eventstore:queryByEntityName","dev_entity"]}' \
    --tls --cafile ${DOCKER_CRYPTO}WakandaGovMSP/peer1.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

print "query event store on WakandaGov peer1" $?

# Invoke private data
export COMMIT=$(echo -n "{\"eventString\":\"[]\"}" | base64 | tr -d \\n);

docker exec \
  -e "CORE_PEER_ADDRESS=peer1.gov.wakanda:7351" \
  -e "CORE_PEER_LOCALMSPID=WakandaGovMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}WakandaGovMSP/peer1.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}WakandaGovMSP/admin/msp" \
  cli peer chaincode invoke \
    -o orderer0.cbody.com:7050 \
    -C genericchannel -n privatedata --waitForEvent \
    -c '{"Args":["privatedata:createCommit","WakandaGovPrivateDetails","private_entityName","private_org2","0","private_org2"]}' \
    --transient "{\"eventstr\":\"$COMMIT\"}" \
    --tls --cafile ${DOCKER_CRYPTO}WakandaGovMSP/peer1.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

 print "invoke private data on WakandaGov peer1" $?

# Query private data
docker exec \
  -e "CORE_PEER_ADDRESS=peer1.gov.wakanda:7351" \
  -e "CORE_PEER_LOCALMSPID=WakandaGovMSP" \
  -e "CORE_PEER_TLS_ROOTCERT_FILE=${DOCKER_CRYPTO}WakandaGovMSP/peer1.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem" \
  -e "CORE_PEER_MSPCONFIGPATH=${DOCKER_CRYPTO}WakandaGovMSP/admin/msp" \
  cli peer chaincode invoke \
    -o orderer0.cbody.com:7050 \
    -C genericchannel -n privatedata --waitForEvent \
    -c '{"Args":["privatedata:queryByEntityName","WakandaGovPrivateDetails","private_entityName"]}' \
    --tls --cafile ${DOCKER_CRYPTO}WakandaGovMSP/peer1.gov.wakanda/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

print "query private data on WakandaGov peer1" $?
sleep 3


#############################

subject "Install CC Completed!"