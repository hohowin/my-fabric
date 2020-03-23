"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const ngacRepo_1 = require("../ngacRepo");
const permissionCheck_1 = require("../permissionCheck");
const types_1 = require("../types");
const utils_1 = require("../utils");
const createMSPResource_1 = require("../utils/createMSPResource");
const __utils__1 = require("./__utils__");
jest.mock('../ledger-api/statelist');
const context = {
    stub: {
        getFunctionAndParameters: jest.fn()
    },
    clientIdentity: {
        getMSPID: jest.fn(),
        getID: jest.fn(),
        getX509Certificate: jest.fn()
    },
    resourceAttributeDb: __utils__1.resourceAttributeDb,
    mspAttributeDb: __utils__1.mspAttributeDb,
    policyDb: __utils__1.policyDb
};
let entityName;
let entityId;
let version;
let eventStr;
let id;
context.clientIdentity.getMSPID.mockImplementation(() => 'Org3MSP');
context.clientIdentity.getX509Certificate.mockImplementation(() => ({
    subject: { commonName: 'Tester01@example.com' },
    issuer: { commonName: 'rca-org3' }
}));
describe('Example 1: PolicyEngine/CRUD Tests', () => {
    beforeEach(() => {
        entityName = 'dev_subject';
        entityId = 'subject_01';
        version = '0';
        id = 'x509::/O=Dev/OU=client/CN=Tester01@example.com';
        context.clientIdentity.getID.mockImplementation(() => id);
    });
    it('should create Org3MSP attribute', async () => {
        const mspId = 'Org3MSP';
        const mspAttrs = [
            { type: '1', key: 'mspid', value: 'Org3MSP' },
            { type: '1', key: 'env', value: 'test' }
        ];
        const mspResource = createMSPResource_1.createMSPResource({ context, mspId, mspAttrs });
        await ngacRepo_1.ngacRepo(context)
            .addMSPAttr(mspResource)
            .then(attrs => expect(attrs).toEqual(mspAttrs));
    });
    it('should create entityName attribute', async () => {
        const resourceAttrs = [
            { type: '1', key: 'entityNameOwner', value: 'tester' },
            {
                type: 'N',
                key: 'createSubject',
                value: [utils_1.createId(['Org3MSP', 'Tester01@example.com'])]
            }
        ];
        await ngacRepo_1.ngacRepo(context)
            .addResourceAttr(utils_1.createResource({
            context,
            entityName,
            resourceAttrs
        }))
            .then(attrs => expect(attrs).toEqual(resourceAttrs));
    });
    it('should create policy', async () => {
        const policy = utils_1.createPolicy({
            context,
            policyClass: 'consolidated-test',
            sid: 'allowCreateSubject',
            allowedEvents: ['SubjectCreated'],
            uri: `${types_1.NAMESPACE.MODEL}/${types_1.NAMESPACE.ORG}?id=resourceAttrs:${types_1.RESOURCE.CREATOR_MSPID}/${types_1.NAMESPACE.ENTITY}?id=resourceAttrs:${types_1.RESOURCE.ENTITYNAME}`,
            condition: {
                hasList: { createSubject: `${types_1.RESOURCE.CREATOR_ID}` }
            },
            effect: 'Allow'
        });
        await ngacRepo_1.ngacRepo(context)
            .addPolicy(policy)
            .then(policy => expect(policy).toMatchSnapshot());
    });
    it('should createSubject', async () => {
        eventStr = JSON.stringify([{ type: 'SubjectCreated' }]);
        context.stub.getFunctionAndParameters.mockImplementation(() => ({
            fcn: 'createCommit',
            params: [entityName, entityId, version, eventStr]
        }));
        return permissionCheck_1.permissionCheck({ context }).then(assertions => expect(assertions).toEqual([{ sid: 'allowCreateSubject', assertion: true }]));
    });
    // note that the mocked implementation is based on unit test;
    // it invokes permissionCheck directly, and skip the EventStore Contract
    // it can use version = '0'. The corresponding integration test cannot
    // repeat the same logic, coz re-create version '0' will fail.
    it('should fail createNothing', async () => {
        eventStr = JSON.stringify([{ type: 'NothingCreated' }]);
        context.stub.getFunctionAndParameters.mockImplementation(() => ({
            fcn: 'createCommit',
            params: [entityName, entityId, version, eventStr]
        }));
        return permissionCheck_1.permissionCheck({ context }).then(assertions => expect(assertions).toEqual([{ sid: 'system', assertion: false, message: 'No policy found' }]));
    });
    it('should create policy #2 with both hasList and strictEquals', async () => {
        const policy = utils_1.createPolicy({
            context,
            policyClass: 'consolidated-test',
            sid: 'allowUpdateSubject',
            allowedEvents: ['SubjectUpdated'],
            uri: `${types_1.NAMESPACE.MODEL}/${types_1.NAMESPACE.ORG}?id=resourceAttrs:${types_1.RESOURCE.CREATOR_MSPID}/${types_1.NAMESPACE.ENTITY}?id=resourceAttrs:${types_1.RESOURCE.ENTITYNAME}/${types_1.NAMESPACE.ENTITYID}?id=resourceAttrs:${types_1.RESOURCE.ENTITYID}`,
            condition: {
                hasList: { updateSubject: types_1.RESOURCE.CREATOR_ID },
                stringEquals: { [types_1.CONTEXT.INVOKER_MSPID]: types_1.RESOURCE.CREATOR_MSPID }
            },
            effect: 'Allow'
        });
        await ngacRepo_1.ngacRepo(context)
            .addPolicy(policy)
            .then(({ sid }) => expect(sid).toEqual(policy.sid));
    });
    it('should add resourceAttribute of updateSubject', async () => {
        const resourceAttrs = [
            {
                type: 'N',
                key: 'updateSubject',
                value: [utils_1.createId(['Org3MSP', 'Tester01@example.com'])]
            }
        ];
        await ngacRepo_1.ngacRepo(context)
            .upsertResourceAttr(utils_1.createResource({
            context,
            entityName,
            entityId,
            resourceAttrs
        }))
            .then(attributes => attributes.filter(({ key }) => key === 'updateSubject'))
            .then(attribute => expect(attribute).toEqual([
            {
                type: 'N',
                key: 'updateSubject',
                value: [utils_1.createId(['Org3MSP', 'Tester01@example.com'])]
            }
        ]));
    });
    it('should updateSubject', async () => {
        version = '1';
        eventStr = JSON.stringify([{ type: 'SubjectUpdated' }]);
        context.stub.getFunctionAndParameters.mockImplementation(() => ({
            fcn: 'createCommit',
            params: [entityName, entityId, version, eventStr]
        }));
        return permissionCheck_1.permissionCheck({ context }).then(assertions => expect(assertions).toEqual([{ sid: 'allowUpdateSubject', assertion: true }]));
    });
});
