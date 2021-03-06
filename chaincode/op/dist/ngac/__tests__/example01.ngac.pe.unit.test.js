"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const ngacRepo_1 = require("../ngacRepo");
const permissionCheck_1 = require("../permissionCheck");
const utils_1 = require("../utils");
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
describe('Example 1: PolicyEngine Tests', () => {
    beforeEach(() => {
        context.clientIdentity.getMSPID.mockImplementation(() => 'Org1MSP');
        context.clientIdentity.getX509Certificate.mockImplementation(() => ({
            subject: { commonName: 'Admin@example.com' },
            issuer: { commonName: 'rca-org1' }
        }));
        entityName = 'dev_ngac_example1';
        entityId = 'ngac_unit_01';
        version = '0';
        eventStr = JSON.stringify([{ type: 'DocumentCreated' }]);
        id = utils_1.createId(['Org1MSP', 'Admin@example.com']);
        context.stub.getFunctionAndParameters.mockImplementation(() => ({
            fcn: 'createCommit',
            params: [entityName, entityId, version, eventStr]
        }));
        context.clientIdentity.getID.mockImplementation(() => id);
    });
    // policy found and asserted
    it('1a: should createDocument', async () => {
        await permissionCheck_1.permissionCheck({ context }).then(assertions => expect(assertions).toEqual([{ sid: 'allowCreateDocument', assertion: true }]));
        await ngacRepo_1.ngacRepo(context)
            .getResourceAttrGroupByURI('model/Org1MSP/dev_ngac_example1/ngac_unit_01')
            .then(attr => expect(attr).toMatchSnapshot());
    });
    // policy not found at all
    it('1b: should fail updateDocument, which is not allowedEvents', async () => {
        context.stub.getFunctionAndParameters.mockImplementationOnce(() => ({
            fcn: 'createCommit',
            params: [entityName, entityId, version, JSON.stringify([{ type: 'DocumentUpdated' }])]
        }));
        return permissionCheck_1.permissionCheck({ context }).then(assertions => expect(assertions).toEqual([{ sid: 'system', assertion: false, message: 'No policy found' }]));
    });
    // policy found, but assert false
    it('1c: should fail createDocument with wrong ID', async () => {
        context.clientIdentity.getX509Certificate.mockImplementation(() => ({
            subject: { commonName: 'wrong@example.com' },
            issuer: { commonName: 'rca-org1' }
        }));
        return permissionCheck_1.permissionCheck({ context }).then(assertions => expect(assertions).toEqual([{ sid: 'system', message: 'No policy found', assertion: false }]));
    });
    // Policy found, but missing resource attributes cannot proceed assertion
    it('1e: should fail getResourceAttr', async () => {
        context.stub.getFunctionAndParameters.mockImplementationOnce(() => ({
            fcn: 'createCommit',
            params: ['non-existing entityName', entityId, version, eventStr]
        }));
        return permissionCheck_1.permissionCheck({ context }).then(assertions => expect(assertions).toEqual([
            {
                sid: 'allowCreateDocument',
                assertion: false,
                message: 'Cannot find resource attributes'
            }
        ]));
    });
    // The Invoker's mspid is Org2MSP, cannot find the policy
    it('1f: should fail createDocument with wrong mspid', async () => {
        context.clientIdentity.getMSPID.mockImplementation(() => 'Org2MSP');
        return permissionCheck_1.permissionCheck({ context }).then(assertions => expect(assertions).toEqual([
            {
                sid: 'system',
                assertion: false,
                message: 'No policy found'
            }
        ]));
    });
});
