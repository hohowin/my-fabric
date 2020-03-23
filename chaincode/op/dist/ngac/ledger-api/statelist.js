"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
const serialize = object => Buffer.from(JSON.stringify(object));
const stateList = (namespace, { stub }) => ({
    getQueryResult: async (keyparts) => {
        const iterator = await stub.getStateByPartialCompositeKey(namespace, keyparts);
        const result = [];
        while (true) {
            const { value, done } = await iterator.next();
            if (value && value.value.toString()) {
                const json = JSON.parse(value.value.toString('utf8'));
                result.push(json);
            }
            if (done) {
                await iterator.close();
                return result;
            }
        }
    },
    addState: async (key, item) => {
        await stub.putState(stub.createCompositeKey(namespace, utils_1.splitKey(key)), serialize(item));
        return item;
    },
    getState: async (key) => {
        const data = await stub.getState(stub.createCompositeKey(namespace, utils_1.splitKey(key)));
        return data.toString() ? JSON.parse(data.toString()) : {};
    },
    deleteStateByKey: async (inputkey) => {
        const key = stub.createCompositeKey(namespace, utils_1.splitKey(inputkey));
        await stub.deleteState(key);
        return key;
    },
    deleteStatesByKeyRange: async (keyparts) => {
        const iterator = await stub.getStateByPartialCompositeKey(namespace, keyparts);
        const result = [];
        while (true) {
            const { value, done } = await iterator.next();
            if (value && value.value.toString()) {
                const item = JSON.parse(value.value.toString('utf8'));
                await stub.deleteState(stub.createCompositeKey(namespace, utils_1.splitKey(item.key)));
                result.push(item.key);
            }
            else
                return [];
            if (done) {
                await iterator.close();
                return result;
            }
        }
    }
});
exports.default = stateList;
