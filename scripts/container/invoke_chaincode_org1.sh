
export CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/pcch.net/admin/msp
export CORE_PEER_ADDRESS=peer0.pcch.net:7051
export ORDERER_URL=orderer0.cbody.com:7050
export CHANNEL=genericchannel
export CA_FILE=/var/artifacts/crypto-config/pcch.net/peer0/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem

# Invoke event store
peer chaincode invoke -o ${ORDERER_URL} -C ${CHANNEL} -n eventstore --waitForEvent \
    -c '{"Args":["createCommit", "dev_entity", "ent_dev_1001", "0","[{\"type\":\"mon\"}]"]}' \
    --tls --cafile ${CA_FILE}

# Query event store
peer chaincode invoke -o ${ORDERER_URL} -C ${CHANNEL} -n eventstore --waitForEvent \
    -c '{"Args":["eventstore:queryByEntityName","dev_entity"]}' \
    --tls --cafile ${CA_FILE}

# Invoke private data
export COMMIT=$(echo -n "{\"eventString\":\"[]\"}" | base64 | tr -d \\n)
peer chaincode invoke -o ${ORDERER_URL} -C ${CHANNEL} -n privatedata --waitForEvent \
    -c '{"Args":["privatedata:createCommit","PccHPrivateDetails","private_entityName","private_1001","0"]}' \
    --transient "{\"eventstr\":\"$COMMIT\"}" \
    --tls --cafile ${CA_FILE}

# Query private data
peer chaincode invoke -o ${ORDERER_URL} -C ${CHANNEL} -n privatedata --waitForEvent \
    -c '{"Args":["privatedata:queryByEntityName","PccHPrivateDetails","private_entityName"]}' \
    --tls --cafile ${CA_FILE}
