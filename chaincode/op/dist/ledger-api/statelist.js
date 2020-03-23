"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const lodash_1 = require("lodash");
const _1 = require(".");
class StateList {
    constructor(ctx, name) {
        this.ctx = ctx;
        this.name = name;
    }
    async getQueryResult(attributes, plainObject) {
        const iterator = await this.ctx.stub.getStateByPartialCompositeKey('entities', attributes);
        const result = {};
        while (true) {
            const { value, done } = await iterator.next();
            if (value && value.value.toString()) {
                const commit = JSON.parse(value.value.toString('utf8'));
                result[commit.commitId] = lodash_1.omit(commit, 'key');
            }
            if (done) {
                await iterator.close();
                return plainObject ? result : Buffer.from(JSON.stringify(result));
            }
        }
    }
    async addState(commit) {
        await this.ctx.stub.putState(this.ctx.stub.createCompositeKey(this.name, _1.splitKey(commit.key)), _1.serialize(commit));
    }
    async getState(key) {
        const data = await this.ctx.stub.getState(this.ctx.stub.createCompositeKey(this.name, _1.splitKey(key)));
        if (data.toString()) {
            return JSON.parse(data.toString());
        }
        else
            return Object.assign({});
    }
    async deleteState(commit) {
        await this.ctx.stub.deleteState(this.ctx.stub.createCompositeKey(this.name, _1.splitKey(commit.key)));
    }
    async deleteStateByEnityId(attributes) {
        const iterator = await this.ctx.stub.getStateByPartialCompositeKey('entities', attributes);
        const result = {};
        while (true) {
            const { value, done } = await iterator.next();
            if (value && value.value.toString()) {
                const { key, commitId } = JSON.parse(value.value.toString('utf8'));
                await this.ctx.stub.deleteState(this.ctx.stub.createCompositeKey('entities', _1.splitKey(key)));
                result[commitId] = {};
            }
            else {
                return Buffer.from(JSON.stringify({
                    status: 'SUCCESS',
                    message: 'No state returned for deletion'
                }));
            }
            // else throw new Error('no state returned');
            if (done) {
                await iterator.close();
                return Buffer.from(JSON.stringify({
                    status: 'SUCCESS',
                    message: `${lodash_1.keys(result).length} records deleted`,
                    result
                }));
            }
        }
    }
}
exports.StateList = StateList;
