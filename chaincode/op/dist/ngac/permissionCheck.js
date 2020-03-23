"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const lodash_1 = require("lodash");
const ngacRepo_1 = require("./ngacRepo");
const policyDecisionEngine_1 = require("./policyDecisionEngine");
const postAssertion_1 = require("./postAssertion");
const types_1 = require("./types");
const utils_1 = require("./utils");
var FCN;
(function (FCN) {
    FCN["CREATE_COMMIT"] = "createCommit";
    FCN["QUERY_BY_ENTITYID"] = "queryByEntityId";
    FCN["QUERY_BY_ENTITYID_COMMITID"] = "queryByEntityIdCommitId";
    FCN["DELETE_BY_ENTITYID_COMMITID"] = "deleteByEntityIdCommitId";
    FCN["DELETE_BY_ENTITYID"] = "deleteByEntityId";
    FCN["ADD_MSP_ATTR"] = "addMSPAttr";
    FCN["ADD_RESORUCE_ATTR"] = "addResourceAttr";
    FCN["ADD_POLICY"] = "addPolicy";
    FCN["DELETE_MSP_ATTR_BY_MSPID"] = "deleteMSPAttrByMSPID";
    FCN["DELETE_POLICY_BY_ID"] = "deletePolicyById";
    FCN["DELETE_POLICY_BY_ID_SID"] = "deletePolicyByIdSid";
    FCN["DELETE_RESOURCE_ATTR_BY_URI"] = "deleteReourceAttrByURI";
    FCN["UPSERT_RESOURCE_ATTR"] = "upsertResourceAttr";
    FCN["GET_MSP_ATTR_BY_MSPID"] = "getMSPAttrByMSPID";
    FCN["GET_POLICY_BY_ID"] = "getPolicyById";
    FCN["GET_POLICY_BY_ID_SID"] = "getPolicyByIdSid";
    FCN["GET_RESOURCE_ATTR_BY_URI"] = "getResourceAttrByURI";
})(FCN || (FCN = {}));
const noPolicyRequired = Promise.resolve([{ sid: 'system', message: 'No policy required', assertion: true }]);
exports.permissionCheck = async ({ context, policyClass }) => {
    const { stub, clientIdentity } = context;
    const { fcn, params } = stub.getFunctionAndParameters();
    const type = '1';
    const attr = (key, value, immutable = true) => (value ? { type, key, value, immutable } : null);
    const mspAttrs = await ngacRepo_1.ngacRepo(context).getMSPAttrByMSPID(clientIdentity.getMSPID());
    let resourceAttrs = [];
    const cn = clientIdentity.getX509Certificate().subject.commonName;
    const mspid = clientIdentity.getMSPID();
    const id = utils_1.createId([mspid, cn]);
    return {
        [FCN.CREATE_COMMIT]: async () => {
            const [entityName, entityId, version, evenStr] = params;
            resourceAttrs = [
                attr(types_1.CONTEXT.INVOKER_ID, id),
                attr(types_1.CONTEXT.INVOKER_MSPID, mspid),
                attr(types_1.CONTEXT.SUBJECT_CN, cn)
            ].filter(item => !!item);
            if (version === '0') {
                [
                    attr(types_1.RESOURCE.VERSION, version, false),
                    attr(types_1.RESOURCE.ENTITYNAME, entityName),
                    attr(types_1.RESOURCE.ENTITYID, entityId),
                    attr(types_1.RESOURCE.CREATOR_MSPID, mspid),
                    attr(types_1.RESOURCE.CREATOR_CN, cn),
                    attr(types_1.RESOURCE.CREATOR_ID, id)
                ]
                    .filter(item => !!item)
                    .forEach(item => resourceAttrs.push(item));
            }
            else {
                const uri = `${types_1.NAMESPACE.MODEL}/${mspid}/${entityName}/${entityId}`;
                const attrs = await ngacRepo_1.ngacRepo(context).getResourceAttrByURI(uri);
                if (lodash_1.isEqual(attrs, [])) {
                    return [{ sid: 'system', assertion: false, message: 'No resource found' }];
                }
                else
                    attrs.forEach(item => resourceAttrs.push(item));
            }
            const eventsJson = JSON.parse(evenStr);
            const eventTypes = eventsJson.map(({ type }) => type);
            const policies = await ngacRepo_1.ngacRepo(context).getPolicyById(id);
            const target = utils_1.createResource({
                context,
                entityName,
                entityId,
                resourceAttrs,
                mspAttrs
            });
            return lodash_1.isEqual(policies, [])
                ? [{ sid: 'system', assertion: false, message: 'No policy found' }]
                : policyDecisionEngine_1.policyDecisionEngine(policies, context)
                    .request({ eventTypes, target })
                    .then(async (assertions) => {
                    await postAssertion_1.postAssertion(assertions, target, context);
                    return assertions;
                });
        },
        [FCN.QUERY_BY_ENTITYID]: () => noPolicyRequired,
        [FCN.QUERY_BY_ENTITYID_COMMITID]: () => noPolicyRequired,
        [FCN.DELETE_BY_ENTITYID]: () => noPolicyRequired,
        [FCN.DELETE_BY_ENTITYID_COMMITID]: () => noPolicyRequired,
        [FCN.ADD_MSP_ATTR]: () => noPolicyRequired,
        [FCN.ADD_RESORUCE_ATTR]: () => noPolicyRequired,
        [FCN.ADD_POLICY]: () => noPolicyRequired,
        [FCN.DELETE_POLICY_BY_ID]: () => noPolicyRequired,
        [FCN.DELETE_POLICY_BY_ID_SID]: () => noPolicyRequired,
        [FCN.DELETE_RESOURCE_ATTR_BY_URI]: () => noPolicyRequired,
        [FCN.DELETE_MSP_ATTR_BY_MSPID]: () => noPolicyRequired,
        [FCN.GET_POLICY_BY_ID]: () => noPolicyRequired,
        [FCN.GET_POLICY_BY_ID_SID]: () => noPolicyRequired,
        [FCN.GET_RESOURCE_ATTR_BY_URI]: () => noPolicyRequired,
        [FCN.GET_MSP_ATTR_BY_MSPID]: () => noPolicyRequired,
        [FCN.UPSERT_RESOURCE_ATTR]: () => noPolicyRequired
    }[fcn]();
};
