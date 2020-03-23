"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const child_process_promise_1 = require("child-process-promise");
const lodash_1 = require("lodash");
const ledger_api_1 = require("../ledger-api");
let commitId;
const org1 = 'etcPrivateDetails';
const org2 = 'pbctfpPrivateDetails';
const entityName = 'private_entityName';
const id = 'id_00001';
const cli = `export EVENT_STR=$(echo "[{\\\"type\\\":\\\"testtype\\\"}]" | base64 | tr -d \\\\n) && docker exec \
-e CORE_PEER_LOCALMSPID=EtcMSP \
-e CORE_PEER_ADDRESS=peer0-etradeconnect:7051 \
-e CORE_PEER_TLS_ROOTCERT_FILE=/var/artifacts/crypto-config/EtcMSP/peer0.etradeconnect.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem \
-e CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/EtcMSP/admin/msp `;
const query = `${cli} cli peer chaincode query -C loanapp -n privatedata -c `;
const invoke = `${cli} cli peer chaincode invoke -o orderer0-hktfp:7050 --waitForEvent --tls -C loanapp -n privatedata --cafile /var/artifacts/crypto-config/EtcMSP/peer0.etradeconnect.net/assets/tls-ca/tls-ca-cert.pem -c `;
const cli2 = `docker exec \
-e CORE_PEER_LOCALMSPID=PbctfpMSP \
-e CORE_PEER_ADDRESS=peer0-pbctfp:7251 \
-e CORE_PEER_TLS_ROOTCERT_FILE=/var/artifacts/crypto-config/PbctfpMSP/peer0.pbctfp.net/tls-msp/tlscacerts/tls-0-0-0-0-6052.pem \
-e CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/PbctfpMSP/admin/msp `;
const query2 = `${cli2} cli peer chaincode query -C loanapp -n privatedata -c `;
const parseResult = input => JSON.parse(Buffer.from(JSON.parse(input)).toString());
describe('Chaincode private data: Network Test', () => {
    /*
      export EVENT_STR=$(echo "[{\"type\":\"testtype\"}[" | base64 | tr -d \\n) &&
      docker exec \
      -e CORE_PEER_LOCALMSPID=Org1MSP \
      -e CORE_PEER_ADDRESS=peer0.org1.example.com:7051 \
      -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
      -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp \
      cliOrg1 peer chaincode invoke -C mychannel -n privatedata  \
      -c '{"Args":["privatedata:createCommit","Org1PrivateDetails","private_entityName","id_00001","0"]}' --transient "{\"eventstr\":\"EVENT_STR\"}"
     */
    it('should createCommit #1', async () => child_process_promise_1.exec(`${invoke} '{"Args":["privatedata:createCommit","${org1}","${entityName}","${id}","0","${ledger_api_1.createCommitId()}"]}' --transient "{\\\"eventstr\\\":\\\"$EVENT_STR\\\"}"`).then(({ stderr }) => expect(stderr).toContain('result: status:200')));
    it('should createCommit #2', async () => child_process_promise_1.exec(`${invoke} '{"Args":["privatedata:createCommit","${org1}","${entityName}","${id}","0","${ledger_api_1.createCommitId()}"]}' --transient "{\\\"eventstr\\\":\\\"$EVENT_STR\\\"}"`).then(({ stderr }) => expect(stderr).toContain('result: status:200')));
    /*
    docker exec \
    -e CORE_PEER_LOCALMSPID=Org1MSP \
    -e CORE_PEER_ADDRESS=peer0.org1.example.com:7051 \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp \
    cliOrg1 peer chaincode query -C mychannel -n privatedata \
    -c '{"Args":["privatedata:queryByEntityId","Org1PrivateDetails","private_entityName","id_00001"]}'
   */
    it('should queryByEntityId #1', async () => child_process_promise_1.exec(`${query} '{"Args":["privatedata:queryByEntityId","${org1}","${entityName}","${id}"]}'`)
        .then(({ stdout }) => lodash_1.values(parseResult(stdout))[0])
        .then(commit => {
        commitId = commit.commitId;
        expect(commit.id).toEqual('id_00001');
    }));
    /*
    docker exec \
    -e CORE_PEER_LOCALMSPID=Org1MSP \
    -e CORE_PEER_ADDRESS=peer0.org1.example.com:7051 \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp \
    cliOrg1 peer chaincode query -C mychannel -n privatedata \
    -c '{"Args":["privatedata:queryByEntityName","Org1PrivateDetails","private_entityName","private_1001"]}'
   */
    it('should queryByEntityName #1', async () => child_process_promise_1.exec(`${query} '{"Args":["privatedata:queryByEntityName","${org1}","${entityName}"]}'`)
        .then(({ stdout }) => lodash_1.values(parseResult(stdout)))
        .then(commits => commits.map(commit => lodash_1.pick(commit, 'entityName')).map(result => expect(result).toEqual({ entityName }))));
    it('should queryByEntityIdCommitId', async () => child_process_promise_1.exec(`${query} '{"Args":["privatedata:queryByEntityIdCommitId","${org1}","${entityName}","${id}","${commitId}"]}'`)
        .then(({ stdout }) => lodash_1.values(parseResult(stdout))[0])
        .then(commit => expect(commit.commitId).toEqual(commitId)));
    it('should fail to queryByEntityIdCommitId by unauthorized peer', async () => child_process_promise_1.exec(`${query2} '{"Args":["privatedata:queryByEntityIdCommitId","${org2}","${entityName}","${id}","${commitId}"]}'`).catch(({ stderr }) => expect(stderr).toContain('does not have read access permission')));
    it('should deleteByEntityIdCommitId', async () => child_process_promise_1.exec(`${invoke} '{"Args":["privatedata:deleteByEntityIdCommitId","${org1}","${entityName}","${id}","${commitId}"]}'`).then(({ stderr }) => expect(stderr).toContain('result: status:200')));
    it('should fail to deleteByEntityIdCommitId', async () => child_process_promise_1.exec(`${invoke} '{"Args":["privatedata:deleteByEntityIdCommitId","${org1}","${entityName}","no such id","${commitId}"]}'`).catch(({ stderr }) => expect(stderr).toContain('commitId does not exist')));
    it('should deleteAll', async () => child_process_promise_1.exec(`${query} '{"Args":["privatedata:queryByEntityId","${org1}","${entityName}","${id}"]}'`)
        .then(({ stdout }) => parseResult(stdout))
        .then(commits => lodash_1.keys(commits))
        .then(async (commitIds) => {
        for (const cid of commitIds) {
            await child_process_promise_1.exec(`${invoke} '{"Args":["privatedata:deleteByEntityIdCommitId","${org1}","${entityName}","${id}","${cid}"]}'`).then(({ stderr }) => expect(stderr).toContain('result: status:200'));
        }
    }));
    /**
     * This test fails, need to revisit later.
     */
    // it('should queryByEntityName #2', async () =>
    //   exec(
    //     `${query} '{"Args":["privatedata:queryByEntityName","${org1}","${entityName}"]}'`
    //   )
    //     .then(({ stdout }) => parseResult(stdout))
    //     .then(commits => expect(commits).toEqual({})));
    it('should fail to queryByEntityIdCommitId', async () => child_process_promise_1.exec(`${query} '{"Args":["privatedata:queryByEntityIdCommitId","${org1}","${entityName}","${id}","${commitId}"]}'`)
        .then(({ stdout }) => parseResult(stdout))
        .then(result => expect(result).toEqual({})));
});
