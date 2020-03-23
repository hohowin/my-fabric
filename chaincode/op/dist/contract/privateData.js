"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const bcrypt_1 = require("bcrypt");
const fabric_contract_api_1 = require("fabric-contract-api");
const lodash_1 = require("lodash");
const ledger_api_1 = require("../ledger-api");
class MyContext extends fabric_contract_api_1.Context {
    constructor() {
        super();
        this.stateList = new ledger_api_1.PrivateStateList(this, 'entities');
    }
}
class PrivateData extends fabric_contract_api_1.Contract {
    constructor(context = new fabric_contract_api_1.Context()) {
        super('privatedata');
        this.context = context;
    }
    createContext() {
        return new MyContext();
    }
    async instantiate(context) {
        console.info('=========== START : Initialize PrivateData =========');
        console.info('============= END : Initialize PrivateData ===========');
    }
    async createCommit(context, collection, entityName, id, version, commitId) {
        if (!id || !version || !entityName || !commitId || !collection)
            throw new Error('createCommit: null argument: id, version, entityName, collection');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        const transientMap = context.stub.getTransient();
        if (!transientMap)
            throw new Error('Error getting transient');
        // @ts-ignore
        const byteBuffer = transientMap.get('eventstr');
        const eventStr = Buffer.from(byteBuffer.toArrayBuffer()).toString();
        const events = JSON.parse(eventStr);
        const commit = ledger_api_1.createInstance({
            id,
            version,
            entityName,
            events,
            commitId
        });
        console.info(`CommitId created: ${commit.commitId}`);
        await context.stateList.addState(collection, commit);
        commit.hash = bcrypt_1.hash(events, 12);
        return Buffer.from(JSON.stringify(ledger_api_1.toRecord(lodash_1.omit(commit, 'key', 'events'))));
    }
    async queryByEntityName(context, collection, entityName) {
        if (!entityName)
            throw new Error('queryPrivateDataByEntityName problem: null argument');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        return await context.stateList.getQueryResult(collection, [JSON.stringify(entityName)]);
    }
    async queryByEntityId(context, collection, entityName, id) {
        if (!id || !entityName || !collection)
            throw new Error('queryPrivateDataByEntityId problem: null argument');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        return await context.stateList.getQueryResult(collection, [JSON.stringify(entityName), JSON.stringify(id)]);
    }
    async queryByEntityIdCommitId(context, collection, entityName, id, commitId) {
        if (!id || !entityName || !commitId)
            throw new Error('getPrivateData problem: null argument');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        const key = ledger_api_1.makeKey([entityName, id, commitId]);
        const commit = await context.stateList.getState(collection, key);
        const result = {};
        if (commit && commit.commitId)
            result[commit.commitId] = lodash_1.omit(commit, 'key');
        return Buffer.from(JSON.stringify(result));
    }
    async deleteByEntityIdCommitId(context, collection, entityName, id, commitId) {
        if (!id || !entityName || !commitId || !collection)
            throw new Error('deletePrivateDataByEntityIdCommitId problem: null argument');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        const key = ledger_api_1.makeKey([entityName, id, commitId]);
        const commit = await context.stateList.getState(collection, key);
        if (commit && commit.key) {
            await context.stateList.deleteState(collection, commit);
            return Buffer.from(JSON.stringify({
                status: 'SUCCESS',
                message: `Commit ${commit.commitId} is deleted`
            }));
        }
        else
            return Buffer.from(JSON.stringify({
                status: 'SUCCESS',
                message: 'commitId does not exist'
            }));
    }
}
exports.PrivateData = PrivateData;
