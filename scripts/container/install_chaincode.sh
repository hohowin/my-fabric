#!/bin/sh
## install_chaincode.sh [org] [peer] [chaincode path] [name] [version] [port] [admin cert path] [peer cert path]
## Example: ./install_chaincode.sh org1 peer1 op eventstore 1.0 7051 org1/admin org1/peer0
if [ $# -ne 8 ]
then
    echo [`date +"%Y-%m-%d %H:%M:%S"`] "Usage: install_chaincode.sh [org] [peer] [chaincode path] [name] [version] [port] [admin cert path] [peer cert path]" \
         "(e.g. : ./install_chaincode.sh org1 peer1 op eventstore 1.0 7051 org1/admin org1/peer0)"
    exit 1
fi

org="$1"
peer="$2"
path="$3"
name="$4"
version="$5"
port="$6"
adm_crt_path="$7"
peer_crt_path="$8"

export CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/${adm_crt_path}/msp
export CORE_PEER_ADDRESS=${peer}.${org}:${port}

# Install Chaincode
peer chaincode install -n ${name} -v ${version} -p /opt/gopath/src/github.com/hyperledger/fabric/chaincode/${path} -l node \
    --tls --cafile /var/artifacts/crypto-config/${peer_crt_path}/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

peer chaincode list --installed