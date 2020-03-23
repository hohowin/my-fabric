"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
const fabric_contract_api_1 = require("fabric-contract-api");
const lodash_1 = require("lodash");
const ledger_api_1 = require("../ledger-api");
const ngac_1 = require("../ngac");
const createMSPResource_1 = require("../ngac/utils/createMSPResource");
const myContext_1 = require("./myContext");
class EventStore extends fabric_contract_api_1.Contract {
    constructor(context = new fabric_contract_api_1.Context()) {
        super('eventstore');
        this.context = context;
    }
    createContext() {
        return new myContext_1.MyContext();
    }
    async instantiate(context) {
        console.info('=== START : Initialize eventstore ===');
        const commits = [];
        commits.push(ledger_api_1.createInstance({
            id: 'ent_dev_1001',
            entityName: 'dev_entity',
            version: '0',
            events: [{ type: 'User Created', payload: { name: 'April' } }],
            commitId: '12345a'
        }));
        commits.push(ledger_api_1.createInstance({
            id: 'ent_dev_1001',
            entityName: 'dev_entity',
            version: '0',
            events: [{ type: 'User Created', payload: { name: 'May' } }],
            commitId: '12345b'
        }));
        for (const commit of commits) {
            await context.stateList.addState(commit);
        }
        console.info('=== END : Initialize eventstore ===');
        /*
        console.info('=== START : Initialize ngac ===');
    
        await ngacRepo(context).addPolicy(
          createPolicy({
            context,
            policyClass: 'int-test',
            sid: 'allowCreateTest',
            allowedEvents: ['TestCreated'],
            uri: `${NAMESPACE.MODEL}/Org1MSP/test/test_0001`
          })
        );
    
        await ngacRepo(context).addMSPAttr(
          createMSPResource({
            mspId: 'Org1MSP',
            mspAttrs: [{ type: '1', key: 'mspid', value: 'Org1MSP' }],
            context
          })
        );
    
        await ngacRepo(context).addResourceAttr(
          createResource({
            context,
            entityName: 'ngactest',
            resourceAttrs: [
              {
                type: '1',
                key: 'createTest',
                value: makeKey([
                  context.clientIdentity.getMSPID(),
                  context.clientIdentity.getX509Certificate().subject.commonName
                ])
              }
            ]
          })
        );
        console.info('=== END : Initialize ngac ===');
        */
        return Buffer.from(JSON.stringify(commits));
    }
    /*
    async beforeTransaction(context) {
      const mspId = context.clientIdentity.getMSPID();
      if (mspId !== 'Org1MSP') {
        console.info(
          `👀 is checking permission for: ${
            context.clientIdentity.getX509Certificate().subject.commonName
          }`
        );
        await permissionCheck({ context })
          .then(assertions => {
            if (assertions === []) {
              console.info(
                '⁉️ Permission request does not have any active policy.'
              );
              return true;
            }
            // Current strategy design: all corresponding policy statement must assert true;
            assertions.forEach(({ sid, assertion, message }) => {
              console.info(`♨️ Policy "${sid}" asserts: ${assertion}`);
              if (!assertion)
                throw new Error(
                  `🚫 Policy "${sid}" assertion fails: ${message || 'no info.'}.`
                );
            });
            return true;
          })
          .catch(error => {
            console.error(error);
            // Todo: below is BUG. should not throw it
            throw error;
          });
      }
    }
  */
    async createCommit(context, entityName, id, version, eventStr, commitId) {
        if (!id || !entityName || !eventStr || !commitId || version === undefined)
            throw new Error('createCommit problem: null argument');
        const events = JSON.parse(eventStr);
        const commit = ledger_api_1.createInstance({
            id,
            version,
            entityName,
            events,
            commitId
        });
        await context.stateList.addState(commit);
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        const evt = lodash_1.omit(commit, 'key');
        evt.entityId = evt.id;
        context.stub.setEvent('createCommit', Buffer.from(JSON.stringify(evt)));
        return Buffer.from(JSON.stringify(ledger_api_1.toRecord(lodash_1.omit(commit, 'key', 'events'))));
    }
    async queryByEntityName(context, entityName) {
        if (!entityName)
            throw new Error('queryByEntityName problem: null argument');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        return context.stateList.getQueryResult([JSON.stringify(entityName)]);
    }
    async queryByEntityId(context, entityName, id) {
        if (!id || !entityName)
            throw new Error('queryByEntityId problem: null argument');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        return context.stateList.getQueryResult([JSON.stringify(entityName), JSON.stringify(id)]);
    }
    async queryByEntityIdCommitId(context, entityName, id, commitId) {
        if (!id || !entityName || !commitId)
            throw new Error('queryByEntityIdCommitId problem: null argument');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        const key = ledger_api_1.makeKey([entityName, id, commitId]);
        const commit = await context.stateList.getState(key);
        const result = {};
        if (commit && commit.commitId)
            result[commit.commitId] = lodash_1.omit(commit, 'key');
        return Buffer.from(JSON.stringify(result));
    }
    async deleteByEntityIdCommitId(context, entityName, id, commitId) {
        if (!id || !entityName || !commitId)
            throw new Error('deleteEntityByCommitId problem: null argument');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        const key = ledger_api_1.makeKey([entityName, id, commitId]);
        const commit = await context.stateList.getState(key);
        if (commit && commit.key) {
            await context.stateList.deleteState(commit).catch(err => {
                throw new Error(err);
            });
            return getSuccessMessage(`Commit ${commit.commitId} is deleted`);
        }
        else
            return getSuccessMessage('commitId does not exist');
    }
    async deleteByEntityId(context, entityName, id) {
        if (!id || !entityName)
            throw new Error('deleteByEntityId problem: null argument');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        return context.stateList.deleteStateByEnityId([JSON.stringify(entityName), JSON.stringify(id)]);
    }
    // NGAC calls
    async addPolicy(context, policyClass, sid, uri, eventsStr, conditionStr) {
        if (!policyClass || !sid || !uri || !eventsStr)
            throw new Error('addPolicy problem: null argument');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        const allowedEvents = JSON.parse(eventsStr);
        const condition = conditionStr ? JSON.parse(conditionStr) : null;
        const policy = await ngac_1.ngacRepo(context).addPolicy(ngac_1.createPolicy({
            context,
            policyClass,
            sid,
            allowedEvents,
            uri,
            condition
        }));
        return policy ? Buffer.from(JSON.stringify(policy)) : getErrorMessage('addPolicy');
    }
    async addMSPAttr(context, mspId, mspAttrsStr) {
        if (!mspId || !mspAttrsStr)
            throw new Error('addMSPAttr problem: null argument');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        const mspAttrs = JSON.parse(mspAttrsStr);
        const attributes = await ngac_1.ngacRepo(context).addMSPAttr(createMSPResource_1.createMSPResource({ context, mspId, mspAttrs }));
        return attributes ? Buffer.from(JSON.stringify(attributes)) : getErrorMessage('addMSPAttr');
    }
    async addResourceAttr(context, entityName, entityId, resourceAttrsStr) {
        if (!entityName || !resourceAttrsStr)
            throw new Error('addResourceAttr problem: null argument');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        const resourceAttrs = JSON.parse(resourceAttrsStr);
        const attributes = await ngac_1.ngacRepo(context).addResourceAttr(ngac_1.createResource({ context, entityName, entityId, resourceAttrs }));
        return attributes ? Buffer.from(JSON.stringify(attributes)) : getErrorMessage('addResourceAttr');
    }
    async deleteMSPAttrByMSPID(context, mspId) {
        if (!mspId)
            throw new Error('deleteMSPAttrByMSPID problem: null argument');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        const msp = await ngac_1.ngacRepo(context).deleteMSPAttrByMSPID(mspId);
        return msp ? getSuccessMessage(`${mspId} is successfully deleted`) : getErrorMessage('deleteMSPAttrByMSPID');
    }
    async deletePolicyById(context, id) {
        if (!id)
            throw new Error('deletePolicyById problem: null argument');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        const policies = await ngac_1.ngacRepo(context).deletePolicyById(id);
        return policies
            ? getSuccessMessage(`${policies.length} record(s) is deleted`)
            : getErrorMessage('deletePolicyById');
    }
    async deletePolicyByIdSid(context, id, sid) {
        if (!id || !sid)
            throw new Error('deletePolicyByIdSid problem: null argument');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        const keyDeleted = await ngac_1.ngacRepo(context).deletePolicyByIdSid(id, sid);
        return keyDeleted ? getSuccessMessage(`${keyDeleted} is deleted`) : getErrorMessage('deletePolicyByIdSid');
    }
    async deleteReourceAttrByURI(context, uri) {
        if (!uri)
            throw new Error('deleteReourceAttrByURI problem: null argument');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        const keyDeleted = await ngac_1.ngacRepo(context).deleteReourceAttrByURI(uri);
        return keyDeleted ? getSuccessMessage(`${keyDeleted} is deleted`) : getErrorMessage('deleteReourceAttrByURI');
    }
    async upsertResourceAttr(context, entityName, entityId, resourceAttrsStr) {
        if (!entityId || !entityName || !resourceAttrsStr)
            throw new Error('addResourceAttr problem: null argument');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        const resourceAttrs = JSON.parse(resourceAttrsStr);
        const attributes = await ngac_1.ngacRepo(context).upsertResourceAttr(ngac_1.createResource({ context, entityId, entityName, resourceAttrs }));
        return attributes ? Buffer.from(JSON.stringify(attributes)) : getErrorMessage('upsertResourceAttr');
    }
    async getMSPAttrByMSPID(context, mspid) {
        if (!mspid)
            throw new Error('getMSPAttrByMSPID problem: null argument');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        const attributes = await ngac_1.ngacRepo(context).getMSPAttrByMSPID(mspid);
        return attributes ? Buffer.from(JSON.stringify(attributes)) : getErrorMessage('getMSPAttrByMSPID');
    }
    async getPolicyById(context, id) {
        if (!id)
            throw new Error('getPolicyById problem: null argument');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        const policies = await ngac_1.ngacRepo(context).getPolicyById(id);
        return policies ? Buffer.from(JSON.stringify(policies)) : getErrorMessage('getPolicyById');
    }
    async getPolicyByIdSid(context, id, sid) {
        if (!id || !sid)
            throw new Error('getPolicyByIdSid problem: null argument');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        const policies = await ngac_1.ngacRepo(context).getPolicyByIdSid(id, sid);
        return policies ? Buffer.from(JSON.stringify(policies)) : getErrorMessage('getPolicyByIdSid');
    }
    async getResourceAttrByURI(context, uri) {
        if (!uri)
            throw new Error('getResourceAttrByURI problem: null argument');
        console.info(`Submitter: ${context.clientIdentity.getID()}`);
        const attributes = await ngac_1.ngacRepo(context).getResourceAttrByURI(uri);
        return attributes ? Buffer.from(JSON.stringify(attributes)) : getErrorMessage('getResourceAttrByURI');
    }
}
__decorate([
    fabric_contract_api_1.Transaction(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [myContext_1.MyContext]),
    __metadata("design:returntype", Promise)
], EventStore.prototype, "instantiate", null);
__decorate([
    fabric_contract_api_1.Transaction(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [myContext_1.MyContext, String, String, String, String, String]),
    __metadata("design:returntype", Promise)
], EventStore.prototype, "createCommit", null);
__decorate([
    fabric_contract_api_1.Transaction(false),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [myContext_1.MyContext, String]),
    __metadata("design:returntype", Promise)
], EventStore.prototype, "queryByEntityName", null);
__decorate([
    fabric_contract_api_1.Transaction(false),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [myContext_1.MyContext, String, String]),
    __metadata("design:returntype", Promise)
], EventStore.prototype, "queryByEntityId", null);
__decorate([
    fabric_contract_api_1.Transaction(false),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [myContext_1.MyContext, String, String, String]),
    __metadata("design:returntype", Promise)
], EventStore.prototype, "queryByEntityIdCommitId", null);
__decorate([
    fabric_contract_api_1.Transaction(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [myContext_1.MyContext, String, String, String]),
    __metadata("design:returntype", Promise)
], EventStore.prototype, "deleteByEntityIdCommitId", null);
__decorate([
    fabric_contract_api_1.Transaction(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [myContext_1.MyContext, String, String]),
    __metadata("design:returntype", Promise)
], EventStore.prototype, "deleteByEntityId", null);
__decorate([
    fabric_contract_api_1.Transaction(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [myContext_1.MyContext, String, String, String, String, String]),
    __metadata("design:returntype", Promise)
], EventStore.prototype, "addPolicy", null);
__decorate([
    fabric_contract_api_1.Transaction(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [myContext_1.MyContext, String, String]),
    __metadata("design:returntype", Promise)
], EventStore.prototype, "addMSPAttr", null);
__decorate([
    fabric_contract_api_1.Transaction(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [myContext_1.MyContext, String, String, String]),
    __metadata("design:returntype", Promise)
], EventStore.prototype, "addResourceAttr", null);
__decorate([
    fabric_contract_api_1.Transaction(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [myContext_1.MyContext, String]),
    __metadata("design:returntype", Promise)
], EventStore.prototype, "deleteMSPAttrByMSPID", null);
__decorate([
    fabric_contract_api_1.Transaction(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [myContext_1.MyContext, String]),
    __metadata("design:returntype", Promise)
], EventStore.prototype, "deletePolicyById", null);
__decorate([
    fabric_contract_api_1.Transaction(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [myContext_1.MyContext, String, String]),
    __metadata("design:returntype", Promise)
], EventStore.prototype, "deletePolicyByIdSid", null);
__decorate([
    fabric_contract_api_1.Transaction(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [myContext_1.MyContext, String]),
    __metadata("design:returntype", Promise)
], EventStore.prototype, "deleteReourceAttrByURI", null);
__decorate([
    fabric_contract_api_1.Transaction(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [myContext_1.MyContext, String, String, String]),
    __metadata("design:returntype", Promise)
], EventStore.prototype, "upsertResourceAttr", null);
__decorate([
    fabric_contract_api_1.Transaction(false),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [myContext_1.MyContext, String]),
    __metadata("design:returntype", Promise)
], EventStore.prototype, "getMSPAttrByMSPID", null);
__decorate([
    fabric_contract_api_1.Transaction(false),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [myContext_1.MyContext, String]),
    __metadata("design:returntype", Promise)
], EventStore.prototype, "getPolicyById", null);
__decorate([
    fabric_contract_api_1.Transaction(false),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [myContext_1.MyContext, String, String]),
    __metadata("design:returntype", Promise)
], EventStore.prototype, "getPolicyByIdSid", null);
__decorate([
    fabric_contract_api_1.Transaction(false),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [myContext_1.MyContext, String]),
    __metadata("design:returntype", Promise)
], EventStore.prototype, "getResourceAttrByURI", null);
exports.EventStore = EventStore;
const getErrorMessage = method => Buffer.from(JSON.stringify({
    status: 'ERROR',
    message: `${method} fails`
}));
const getSuccessMessage = message => Buffer.from(JSON.stringify({
    status: 'SUCCESS',
    message
}));
