"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const lodash_1 = require("lodash");
const _1 = require(".");
class PrivateStateList {
    constructor(ctx, name) {
        this.ctx = ctx;
        this.name = name;
    }
    async getQueryResult(collection, attributes) {
        // todo: this is workaround to known bug FAB-14216. This will not work after the bug is fixexd in V2.
        const iterator = await this.ctx.stub
            .getPrivateDataByPartialCompositeKey(collection, 'entities', attributes)
            .then((data) => data.iterator);
        const result = {};
        while (true) {
            const { value, done } = await iterator.next();
            if (value && value.value.toString()) {
                const commit = JSON.parse(value.value.toString('utf8'));
                result[commit.commitId] = lodash_1.omit(commit, 'key');
            }
            if (done) {
                await iterator.close();
                return Buffer.from(JSON.stringify(result));
            }
        }
    }
    async addState(collection, commit) {
        await this.ctx.stub.putPrivateData(collection, this.ctx.stub.createCompositeKey(this.name, _1.splitKey(commit.key)), _1.serialize(commit));
    }
    async getState(collection, key) {
        const data = await this.ctx.stub.getPrivateData(collection, this.ctx.stub.createCompositeKey(this.name, _1.splitKey(key)));
        if (data.toString()) {
            return JSON.parse(data.toString());
        }
        else
            return Object.assign({});
    }
    async deleteState(collection, { key }) {
        await this.ctx.stub.deletePrivateData(collection, this.ctx.stub.createCompositeKey(this.name, _1.splitKey(key)));
    }
}
exports.PrivateStateList = PrivateStateList;
