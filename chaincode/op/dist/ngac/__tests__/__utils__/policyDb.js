"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const types_1 = require("../../types");
const utils_1 = require("../../utils");
const policies = [
    {
        // Example 1: Only authorized id can create
        // key: `"x509::/O=Dev/OU=client/CN=Admin@example.com::/O=Dev/OU=Dev/CN=rca""allowCreateDocument"`,
        key: `"${utils_1.createId(['Org1MSP', 'Admin@example.com'])}""allowCreateDocument"`,
        policyClass: 'event-creation',
        sid: 'allowCreateDocument',
        allowedEvents: ['DocumentCreated'],
        attributes: {
            uri: `${types_1.NAMESPACE.MODEL}/${types_1.NAMESPACE.ORG}?id=resourceAttrs:${types_1.RESOURCE.CREATOR_MSPID}/${types_1.NAMESPACE.ENTITY}?id=resourceAttrs:${types_1.RESOURCE.ENTITYNAME}`
        },
        condition: {
            hasList: { createDocument: types_1.RESOURCE.CREATOR_ID }
        },
        effect: 'Allow'
    },
    {
        // Example 2: Only creator can update
        key: `"${utils_1.createId(['Org1MSP', 'Admin@example.com'])}""allowUpdateUsername"`,
        policyClass: 'event-creation',
        sid: 'allowUpdateUsername',
        allowedEvents: ['UsernameUpdated', 'UserTypeUpdated'],
        attributes: {
            uri: `${types_1.NAMESPACE.MODEL}/${types_1.NAMESPACE.ORG}?id=resourceAttrs:${types_1.RESOURCE.CREATOR_MSPID}/${types_1.NAMESPACE.ENTITY}?id=resourceAttrs:${types_1.RESOURCE.ENTITYNAME}/${types_1.NAMESPACE.ENTITYID}?id=resourceAttrs:${types_1.RESOURCE.ENTITYID}`
        },
        condition: {
            hasList: { updateUsername: types_1.CONTEXT.INVOKER_ID },
            stringEquals: {
                [types_1.CONTEXT.INVOKER_ID]: types_1.RESOURCE.CREATOR_ID
            }
        },
        effect: 'Allow'
    },
    {
        // Example 3: Only same mspid can update
        key: `"${utils_1.createId(['Org1MSP', 'Admin@example.com'])}""allowUpdateTitle"`,
        policyClass: 'event-creation',
        sid: 'allowUpdateTitle',
        allowedEvents: ['TitleUpdated', 'Title2Updated'],
        attributes: {
            uri: `${types_1.NAMESPACE.MODEL}/${types_1.NAMESPACE.ORG}?id=resourceAttrs:${types_1.RESOURCE.CREATOR_MSPID}/${types_1.NAMESPACE.ENTITY}?id=resourceAttrs:${types_1.RESOURCE.ENTITYNAME}/${types_1.NAMESPACE.ENTITYID}?id=resourceAttrs:${types_1.RESOURCE.ENTITYID}`
        },
        condition: {
            hasList: { updateTitle: types_1.CONTEXT.INVOKER_ID },
            stringEquals: {
                [types_1.CONTEXT.INVOKER_MSPID]: types_1.RESOURCE.CREATOR_MSPID
            }
        },
        effect: 'Allow'
    },
    {
        key: `"${utils_1.createId(['Org1MSP', 'Admin@example.com'])}""allowCreateTrade"`,
        policyClass: 'event-creation',
        sid: 'allowCreateTrade',
        allowedEvents: ['TradeCreated'],
        attributes: {
            uri: `${types_1.NAMESPACE.MODEL}/${types_1.NAMESPACE.ORG}?id=resourceAttrs:${types_1.RESOURCE.CREATOR_MSPID}/${types_1.NAMESPACE.ENTITY}?id=resourceAttrs:${types_1.RESOURCE.ENTITYNAME}`
        },
        condition: {
            hasList: { createTrade: types_1.RESOURCE.CREATOR_ID }
        },
        effect: 'Allow'
    }
];
const TEST_ID = `"${utils_1.createId(['Org1MSP', 'Admin@example.com'])}"`;
const TEST_POLICY = `"${utils_1.createId(['Org1MSP', 'Admin@example.com'])}""allowCreateDocument"`;
const TEST_POLICY2 = `"${utils_1.createId(['Org1MSP', 'Admin@example.com'])}""allowCreateTrade"`;
exports.policyDb = {
    [TEST_ID]: Promise.resolve(policies),
    [TEST_POLICY]: Promise.resolve(policies.filter(({ sid }) => sid === 'allowCreateDocument').pop()),
    [TEST_POLICY2]: Promise.resolve(policies.filter(({ sid }) => sid === 'allowCreateTrade').pop()),
    '"wrong id + valid policy"': Promise.resolve(policies)
};
