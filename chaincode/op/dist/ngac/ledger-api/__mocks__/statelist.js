"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const lodash_1 = require("lodash");
const types_1 = require("../../types");
const utils_1 = require("../../utils");
const noResult = Promise.resolve([]);
const createKey = (keyparts) => keyparts.reduce((pre, cur) => pre + cur, '');
const deleteRecord = (db, key) => {
    const length = lodash_1.keys(db).length;
    delete db[key];
    return length === lodash_1.keys(db).length ? null : key;
};
const deleteRecords = (db, keyparts) => lodash_1.keys(db)
    .filter(key => key.startsWith(keyparts[0]))
    .map(key => {
    delete db[key];
    return key;
});
const stateList = (namespace, { mspAttributeDb: mspDb, resourceAttributeDb: resDb, policyDb }) => ({
    getQueryResult: async (keyparts) => ({
        [types_1.NAMESPACE.RESOURCE_ATTRIBUTE]: () => resDb[createKey(keyparts)] || noResult,
        [types_1.NAMESPACE.POLICY]: () => 
        // to overcome the limitation of KV database, need to imitate policy root, in JSON object.
        // below statement returns policy root. Note that policy root only exist in mocking Policy Db.
        // in real hyperledger, it does not exist.
        policyDb[keyparts[0]] ||
            // return policies array
            Promise.all(Object.entries(policyDb)
                .filter(([key, value]) => key.startsWith(keyparts[0]))
                .map(([key, value]) => value)) ||
            noResult
    }[namespace]()),
    getState: async (inputkey) => ({
        [types_1.NAMESPACE.MSP_ATTRIBUTE]: key => mspDb[key] || noResult,
        [types_1.NAMESPACE.RESOURCE_ATTRIBUTE]: key => resDb[key] || noResult,
        [types_1.NAMESPACE.POLICY]: key => policyDb[key] || noResult
    }[namespace](createKey(utils_1.splitKey(inputkey)))),
    addState: async (inputkey, item) => ({
        [types_1.NAMESPACE.RESOURCE_ATTRIBUTE]: key => (resDb[key] = Promise.resolve(item)),
        [types_1.NAMESPACE.MSP_ATTRIBUTE]: key => (mspDb[key] = Promise.resolve(item)),
        [types_1.NAMESPACE.POLICY]: key => (policyDb[key] = Promise.resolve(item))
    }[namespace](createKey(utils_1.splitKey(inputkey)))),
    deleteStateByKey: async (inputkey) => ({
        [types_1.NAMESPACE.MSP_ATTRIBUTE]: key => deleteRecord(mspDb, key),
        [types_1.NAMESPACE.RESOURCE_ATTRIBUTE]: key => deleteRecord(resDb, key),
        [types_1.NAMESPACE.POLICY]: key => deleteRecord(policyDb, key)
    }[namespace](createKey(utils_1.splitKey(inputkey)))),
    deleteStatesByKeyRange: async (keyparts) => ({
        // [NS.RESOURCE_ATTRIBUTE]: () => deleteRecords(resDb, keyparts),
        [types_1.NAMESPACE.POLICY]: () => deleteRecords(policyDb, keyparts)
    }[namespace]())
});
exports.default = stateList;
