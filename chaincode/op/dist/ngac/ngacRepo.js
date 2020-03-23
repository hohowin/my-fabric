"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const lodash_1 = require("lodash");
const statelist_1 = __importDefault(require("./ledger-api/statelist"));
const types_1 = require("./types");
const utils_1 = require("./utils");
exports.ngacRepo = context => ({
    addMSPAttr: async (resource) => resource ? statelist_1.default(types_1.NAMESPACE.MSP_ATTRIBUTE, context).addState(resource.key, resource.mspAttrs) : null,
    addResourceAttr: async (resource) => resource
        ? statelist_1.default(types_1.NAMESPACE.RESOURCE_ATTRIBUTE, context).addState(resource.key, resource.resourceAttrs)
        : null,
    upsertResourceAttr: async (resource) => {
        if (!resource)
            return null;
        const attributes = await statelist_1.default(types_1.NAMESPACE.RESOURCE_ATTRIBUTE, context).getState(resource.key);
        const newAttrs = {};
        resource.resourceAttrs.forEach(attr => (newAttrs[attr.key] = attr));
        const existingAttrs = {};
        attributes.forEach(attr => (existingAttrs[attr.key] = attr));
        const resultAttrs = lodash_1.values(lodash_1.assign({}, existingAttrs, newAttrs));
        return resultAttrs
            ? statelist_1.default(types_1.NAMESPACE.RESOURCE_ATTRIBUTE, context).addState(resource.key, resultAttrs.map(attr => {
                if (attr.key === 'version') {
                    let version = parseInt(attr.value, 10);
                    return {
                        type: '1',
                        key: 'version',
                        value: `${++version}`,
                        immutable: false
                    };
                }
                return attr;
            }))
            : null;
    },
    addPolicy: async (policy) => (policy ? statelist_1.default(types_1.NAMESPACE.POLICY, context).addState(policy.key, policy) : null),
    deleteMSPAttrByMSPID: async (mspid) => mspid ? statelist_1.default(types_1.NAMESPACE.MSP_ATTRIBUTE, context).deleteStateByKey(utils_1.makeKey([mspid])) : null,
    deletePolicyById: async (id) => id ? statelist_1.default(types_1.NAMESPACE.POLICY, context).deleteStatesByKeyRange([JSON.stringify(id)]) : null,
    deletePolicyByIdSid: async (id, sid) => id && sid ? statelist_1.default(types_1.NAMESPACE.POLICY, context).deleteStateByKey(utils_1.makeKey([id, sid])) : null,
    deleteReourceAttrByURI: async (uri) => uri ? statelist_1.default(types_1.NAMESPACE.RESOURCE_ATTRIBUTE, context).deleteStateByKey(utils_1.makeKey(uri.split('/'))) : null,
    getMSPAttrByMSPID: async (mspid) => mspid ? statelist_1.default(types_1.NAMESPACE.MSP_ATTRIBUTE, context).getState(utils_1.makeKey([mspid])) : null,
    getPolicyById: async (id) => (id ? statelist_1.default(types_1.NAMESPACE.POLICY, context).getQueryResult([JSON.stringify(id)]) : null),
    getPolicyByIdSid: async (id, sid) => id && sid ? statelist_1.default(types_1.NAMESPACE.POLICY, context).getState(utils_1.makeKey([id, sid])) : null,
    getResourceAttrGroupByURI: async (uri) => uri
        ? statelist_1.default(types_1.NAMESPACE.RESOURCE_ATTRIBUTE, context).getQueryResult(uri.split('/').map(part => JSON.stringify(part)))
        : null,
    getResourceAttrByURI: async (uri) => uri ? statelist_1.default(types_1.NAMESPACE.RESOURCE_ATTRIBUTE, context).getState(utils_1.makeKey(uri.split('/'))) : null
});
