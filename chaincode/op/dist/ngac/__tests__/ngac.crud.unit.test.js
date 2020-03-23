"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const ngacRepo_1 = require("../ngacRepo");
const types_1 = require("../types");
const utils_1 = require("../utils");
const createMSPResource_1 = require("../utils/createMSPResource");
const __utils__1 = require("./__utils__");
jest.mock('../ledger-api/statelist');
const context = {
    clientIdentity: {
        getMSPID: jest.fn(),
        getID: jest.fn(),
        getX509Certificate: jest.fn()
    },
    resourceAttributeDb: __utils__1.resourceAttributeDb,
    mspAttributeDb: __utils__1.mspAttributeDb,
    policyDb: __utils__1.policyDb
};
const x509id = utils_1.createId(['Org1MSP', 'Admin@example.com']);
// 'x509::/O=Dev/OU=client/CN=Admin@example.com::/O=Dev/OU=Dev/CN=rca';
const sid = 'allowCreateDocument';
const mspid = 'Org1MSP';
const uri = 'model/Org1MSP/dev_ngac_example1';
context.clientIdentity.getMSPID.mockImplementation(() => 'Org1MSP');
context.clientIdentity.getX509Certificate.mockImplementation(() => ({
    subject: { commonName: 'Admin@example.com' },
    issuer: { commonName: 'rca-org1' }
}));
describe('NgacRepo CRUD Tests', () => {
    beforeEach(() => {
        context.clientIdentity.getID.mockImplementation(() => x509id);
    });
    it('should getPolicyById by x509id', async () => ngacRepo_1.ngacRepo(context)
        .getPolicyById(x509id)
        .then(policies => policies.forEach(({ policyClass }) => expect(policyClass).toBe('event-creation'))));
    it('should fail getPolicyById: wrong x509id', async () => ngacRepo_1.ngacRepo(context)
        .getPolicyById('incorrect x509id')
        .then(policies => expect(policies).toEqual([])));
    it('should getPolicyByIdSid, by x509id, statement id', async () => ngacRepo_1.ngacRepo(context)
        .getPolicyByIdSid(x509id, sid)
        .then(({ sid }) => expect(sid).toBe('allowCreateDocument')));
    it('should fail getPolicyByIdSid: wrong x509id', async () => ngacRepo_1.ngacRepo(context)
        .getPolicyByIdSid('incorrect x509id', sid)
        .then(policy => expect(policy).toEqual([])));
    it('should fail getPolicyByIdSid: wrong sid', async () => ngacRepo_1.ngacRepo(context)
        .getPolicyByIdSid(x509id, 'incorrect sid')
        .then(policy => expect(policy).toEqual([])));
    it('should getMSPAttrByMSPID, by mspid', async () => ngacRepo_1.ngacRepo(context)
        .getMSPAttrByMSPID(mspid)
        .then(attributes => expect(attributes).toEqual([{ type: '1', key: 'mspid', value: 'Org1MSP' }])));
    it('should fail getMSPAttrByMSPID: wrong mspid', async () => ngacRepo_1.ngacRepo(context)
        .getMSPAttrByMSPID('incorrect mspid')
        .then(attributes => expect(attributes).toEqual([])));
    it('should getResourceAttrByURI', async () => ngacRepo_1.ngacRepo(context)
        .getResourceAttrByURI(uri)
        .then(attributes => expect(attributes[0].key).toEqual('createDocument')));
    it('should fail getResourceAttrByURI: wrong uri', async () => ngacRepo_1.ngacRepo(context)
        .getResourceAttrGroupByURI('incorrect-uri')
        .then(attributes => expect(attributes).toEqual([])));
    it('should addPolicy', async () => {
        const policy = utils_1.createPolicy({
            context,
            policyClass: 'unit-test',
            sid: 'allowCreateTrade',
            allowedEvents: ['TradeCreated'],
            uri: `${types_1.NAMESPACE.MODEL}/Org0MSP/trade/trade_unit_01`
        });
        let policyAdded;
        await ngacRepo_1.ngacRepo(context)
            .addPolicy(policy)
            .then(policy => {
            policyAdded = policy;
            expect(policy).toMatchSnapshot();
        });
        await ngacRepo_1.ngacRepo(context)
            .getPolicyByIdSid(x509id, policy.sid)
            .then(({ sid }) => expect(sid).toEqual(policyAdded.sid));
    });
    it('should deletePolicyByIdSid', async () => {
        await ngacRepo_1.ngacRepo(context)
            .deletePolicyByIdSid(x509id, 'allowCreateTrade')
            .then(keyDeleted => expect(keyDeleted).toBe(`"${x509id}""allowCreateTrade"`));
        await ngacRepo_1.ngacRepo(context)
            .getPolicyByIdSid(x509id, 'allowCreateTrade')
            .then(policy => expect(policy).toEqual([]));
    });
    it('should deletePolicyById', async () => {
        // const id01 = 'id-deletePolicyById';
        context.clientIdentity.getMSPID.mockImplementation(() => 'Org0MSP');
        const policy1 = utils_1.createPolicy({
            context,
            policyClass: 'unit-test',
            sid: 'allowCreateLoan',
            allowedEvents: ['LoanCreated'],
            uri: `${types_1.NAMESPACE.MODEL}/Org0MSP/loan/loan_unit_01`
        });
        const policy2 = utils_1.createPolicy({
            context,
            policyClass: 'unit-test',
            sid: 'allowSignature',
            allowedEvents: ['Signed'],
            uri: `${types_1.NAMESPACE.MODEL}/Org0MSP/loan/loan_unit_01`
        });
        let policy1Added;
        let policy2Added;
        await ngacRepo_1.ngacRepo(context)
            .addPolicy(policy1)
            .then(policy => (policy1Added = policy));
        await ngacRepo_1.ngacRepo(context)
            .addPolicy(policy2)
            .then(policy => (policy2Added = policy));
        const id = utils_1.createId(['Org0MSP', 'Admin@example.com']);
        await ngacRepo_1.ngacRepo(context)
            .deletePolicyById(id)
            .then(keysDeleted => keysDeleted.forEach(key => expect(key.startsWith(`"${id}"`)).toBe(true)));
    });
    it('should addMSPAttr', async () => {
        const mspId = 'Org0MSP';
        const mspAttrs = [{ type: '1', key: 'mspid', value: 'Org0MSP' }];
        const mspResource = createMSPResource_1.createMSPResource({ context, mspId, mspAttrs });
        let mspAttrAdded;
        await ngacRepo_1.ngacRepo(context)
            .addMSPAttr(mspResource)
            .then(attrs => {
            mspAttrAdded = attrs;
            expect(attrs).toEqual(mspAttrs);
        });
        await ngacRepo_1.ngacRepo(context)
            .getMSPAttrByMSPID('Org0MSP')
            .then(attrs => expect(attrs).toEqual(mspAttrs));
    });
    it('should deleteMSPAttrByMSPID', async () => {
        await ngacRepo_1.ngacRepo(context)
            .deleteMSPAttrByMSPID('Org0MSP')
            .then(result => expect(result).toEqual('"Org0MSP"'));
        await ngacRepo_1.ngacRepo(context)
            .getMSPAttrByMSPID('Org0MSP')
            .then(attrs => expect(attrs).toEqual([]));
    });
    it('should addResourceAttr', async () => {
        context.clientIdentity.getMSPID.mockImplementation(() => 'Org1MSP');
        const entityName = 'Trade';
        const entityId = 'unit_test_1010';
        const resourceAttrs = [{ type: '1', key: 'owner', value: 'me' }];
        const resource = utils_1.createResource({
            context,
            entityId,
            entityName,
            resourceAttrs
        });
        await ngacRepo_1.ngacRepo(context)
            .addResourceAttr(resource)
            .then(attrs => expect(attrs).toEqual(resourceAttrs));
        await ngacRepo_1.ngacRepo(context)
            .getResourceAttrGroupByURI(resource.uri)
            .then(attrs => expect(attrs).toEqual(resourceAttrs));
    });
    it('should deleteReourceAttrByURI', async () => {
        const uri = `model/Org1MSP/Trade/unit_test_1010`;
        await ngacRepo_1.ngacRepo(context)
            .deleteReourceAttrByURI(uri)
            .then(key => expect(key).toEqual('"model""Org1MSP""Trade""unit_test_1010"'));
        await ngacRepo_1.ngacRepo(context)
            .getResourceAttrGroupByURI(uri)
            .then(attrs => expect(attrs).toEqual([]));
    });
});
