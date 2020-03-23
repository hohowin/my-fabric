"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const types_1 = require("../../types");
const utils_1 = require("../../utils");
exports.resourceAttributeDb = {
    '"model""Org1MSP""dev_ngac_example1"': Promise.resolve([
        {
            type: 'N',
            key: 'createDocument',
            value: [`${utils_1.createId(['Org1MSP', 'Admin@example.com'])}`, `${utils_1.createId(['Org1MSP', 'User1@example.com'])}`]
        }
    ]),
    '"model""Org1MSP""dev_ngac_example2""ngac_unit_02"': Promise.resolve([
        {
            type: 'N',
            key: 'updateUsername',
            value: [`${utils_1.createId(['Org1MSP', 'Admin@example.com'])}`, `${utils_1.createId(['Org1MSP', 'User1@example.com'])}`]
        },
        {
            type: '1',
            key: `${types_1.RESOURCE.ENTITYID}`,
            value: 'ngac_unit_02'
        },
        {
            type: '1',
            key: `${types_1.RESOURCE.CREATOR_MSPID}`,
            value: 'Org1MSP'
        },
        {
            type: '1',
            key: `${types_1.RESOURCE.CREATOR_ID}`,
            value: `${utils_1.createId(['Org1MSP', 'Admin@example.com'])}`
        },
        {
            type: '1',
            key: `${types_1.RESOURCE.ENTITYNAME}`,
            value: 'dev_ngac_example2'
        }
    ]),
    '"model""Org1MSP""dev_ngac_example3""ngac_unit_03"': Promise.resolve([
        {
            type: 'N',
            key: 'updateTitle',
            value: [`${utils_1.createId(['Org1MSP', 'Admin@example.com'])}`, `${utils_1.createId(['Org1MSP', 'User1@example.com'])}`]
        },
        {
            type: '1',
            key: `${types_1.RESOURCE.ENTITYID}`,
            value: 'ngac_unit_03'
        },
        {
            type: '1',
            key: `${types_1.RESOURCE.CREATOR_MSPID}`,
            value: 'Org1MSP'
        },
        {
            type: '1',
            key: `${types_1.RESOURCE.CREATOR_ID}`,
            value: `${utils_1.createId(['Org1MSP', 'Admin@example.com'])}`
        },
        {
            type: '1',
            key: `${types_1.RESOURCE.ENTITYNAME}`,
            value: 'dev_ngac_example3'
        }
    ]),
    '"model""Org2MSP""dev_ngac_example3""ngac_unit_03"': Promise.resolve([
        {
            type: 'N',
            key: 'updateTitle',
            value: [`${utils_1.createId(['Org1MSP', 'Admin@example.com'])}`, `${utils_1.createId(['Org1MSP', 'User1@example.com'])}`]
        },
        {
            type: '1',
            key: `${types_1.RESOURCE.ENTITYID}`,
            value: 'ngac_unit_03'
        },
        {
            type: '1',
            key: `${types_1.RESOURCE.CREATOR_MSPID}`,
            value: 'Org2MSP'
        },
        {
            type: '1',
            key: `${types_1.RESOURCE.CREATOR_ID}`,
            value: `${utils_1.createId(['Org1MSP', 'Admin@example.com'])}`
        },
        {
            type: '1',
            key: `${types_1.RESOURCE.ENTITYNAME}`,
            value: 'dev_ngac_example3'
        }
    ])
};
