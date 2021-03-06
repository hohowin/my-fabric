"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const lodash_1 = require("lodash");
const ledger_api_1 = require("../ledger-api");
const __1 = require("..");
const ctx = {
    stub: {
        createCompositeKey: jest.fn(),
        deleteState: jest.fn(),
        getState: jest.fn(),
        putState: jest.fn(),
        setEvent: jest.fn(),
        getStateByPartialCompositeKey: jest.fn()
    },
    clientIdentity: { getID: jest.fn() }
};
const context = {
    stateList: new ledger_api_1.StateList(ctx, 'entities'),
    ...ctx
};
ctx.stub.createCompositeKey.mockResolvedValue('entities"en""entId""2019"');
ctx.stub.putState.mockResolvedValue(Buffer.from(''));
ctx.stub.setEvent.mockImplementation((name, args) => console.log(`Event sent: ${name}: ${args}`));
ctx.clientIdentity.getID.mockImplementation(() => 'Org1MSP');
const cc = new __1.EventStore(context);
const entityName = 'cc_test';
const id = 'cc_01';
const entityId = id;
const version = '0';
const events = [{ type: 'mon', payload: { name: 'jun' } }];
const eventStr = JSON.stringify(events);
const commitId = '123';
const committedAt = '2019';
const value = JSON.stringify({
    key: '123',
    commitId,
    committedAt,
    version,
    entityName,
    id,
    entityId,
    events
});
ctx.stub.getStateByPartialCompositeKey.mockResolvedValue({
    next: () => ({ value: { value }, done: true }),
    close: () => null
});
ctx.stub.getState.mockResolvedValue(value);
describe('Chaincode Tests', () => {
    it('should instantiate', async () => cc
        .instantiate(context)
        .then((response) => JSON.parse(response))
        .then(json => json
        .map(({ id, entityName, version, events }) => ({
        id,
        entityName,
        version,
        events
    }))
        .map(commit => expect(commit).toMatchSnapshot())));
    it('should createCommit', async () => cc
        .createCommit(context, entityName, id, version, eventStr, commitId)
        .then((response) => lodash_1.values(JSON.parse(response))[0])
        .then(({ id, entityName, version, entityId }) => ({
        id,
        entityName,
        version,
        entityId,
        events
    }))
        .then(commit => expect(commit).toMatchSnapshot()));
    it('should queryByEntityName', async () => cc
        .queryByEntityName(context, entityName)
        .then((response) => JSON.parse(response))
        .then(response => expect(response).toMatchSnapshot()));
    it('should queryByEntityId', async () => cc
        .queryByEntityId(context, entityName, id)
        .then((response) => JSON.parse(response))
        .then(response => expect(response).toMatchSnapshot()));
    it('should queryByEntityIdCommitId', async () => cc
        .queryByEntityIdCommitId(context, entityName, id, commitId)
        .then((response) => JSON.parse(response))
        .then(response => expect(response).toMatchSnapshot()));
    it('should deleteByEntityIdCommitId', async () => cc
        .deleteByEntityIdCommitId(context, entityName, id, commitId)
        .then((response) => JSON.parse(response))
        .then(({ status }) => expect(status).toBe('SUCCESS')));
    it('should deleteByEntityId', async () => cc
        .deleteByEntityId(context, entityName, id)
        .then((response) => JSON.parse(response))
        .then(({ status }) => expect(status).toBe('SUCCESS')));
});
