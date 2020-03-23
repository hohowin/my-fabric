"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const lodash_1 = require("lodash");
const ngacRepo_1 = require("./ngacRepo");
const types_1 = require("./types");
const utils_1 = require("./utils");
const evaluateURI = (uri, target) => {
    const getAttr = query => {
        const [paramKey, paramValue] = query.split('=')[1].split(':');
        const attribute = lodash_1.find(target[paramKey], ({ key }) => key === paramValue);
        return !attribute ? null : attribute.value;
    };
    const [namespace, orgPart, entityPart, entityIdPart] = uri.split('/');
    const [orgname, orgQuery] = orgPart.split('?');
    const organization = orgname === types_1.NAMESPACE.ORG ? getAttr(orgQuery) : orgname;
    const [entityname, entityQuery] = entityPart.split('?');
    const entity = entityname === types_1.NAMESPACE.ENTITY ? getAttr(entityQuery) : entityname;
    if (!organization) {
        console.error('Null organization');
        return null;
    }
    if (!entity) {
        console.error('Null entityName');
        return null;
    }
    if (entityIdPart) {
        const [id, entityidQuery] = entityIdPart.split('?');
        const entityId = id === types_1.NAMESPACE.ENTITYID ? getAttr(entityidQuery) : id;
        return `${namespace}/${organization}/${entity}/${entityId}`;
    }
    else
        return `${namespace}/${organization}/${entity}`;
};
const allowOrDeny = { Allow: true, Deny: false };
exports.policyDecisionEngine = (policies, context) => ({
    request: async ({ eventTypes, target }) => new Promise(resolve => {
        const promises = lodash_1.filter(policies, ({ allowedEvents }) => !!lodash_1.intersection(allowedEvents, eventTypes).length).map(async ({ attributes: { uri }, sid, effect, condition }) => {
            const parsedURI = evaluateURI(uri, target);
            if (!parsedURI)
                return {
                    sid,
                    assertion: !allowOrDeny[effect],
                    message: `Resource URI fail to parse`
                };
            if (!condition)
                return {
                    sid,
                    assertion: true,
                    message: 'No condition defined'
                };
            const requirement = await ngacRepo_1.ngacRepo(context).getResourceAttrByURI(parsedURI);
            if (lodash_1.isEqual(requirement, []))
                return {
                    sid,
                    assertion: false,
                    message: `Cannot find resource attributes`
                };
            const debug = context.clientIdentity.getX509Certificate().subject.commonName.startsWith('faker');
            const hasListAssertion = utils_1.hasList({
                sid,
                effect,
                condition,
                requirement,
                resourceAttrs: target.resourceAttrs,
                debug
            });
            const stringEqualsAssertion = utils_1.stringEquals({
                sid,
                effect,
                debug,
                requirement,
                condition,
                contextAttrs: target.contextAttrs
            });
            return [...hasListAssertion, ...stringEqualsAssertion].reduce((prev, { assertion }) => ({
                sid,
                assertion: prev.assertion && assertion
            }), { sid, assertion: true });
        });
        return lodash_1.isEqual(promises, [])
            ? resolve([{ sid: 'system', assertion: false, message: 'No policy found' }])
            : Promise.all(promises).then(allAssertion => resolve(allAssertion));
    })
});
