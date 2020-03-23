"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const lodash_1 = require("lodash");
const commit_1 = require("./commit");
exports.splitKey = (key) => key.split('~');
exports.makeKey = (keyParts) => keyParts.map(part => JSON.stringify(part)).join('~');
exports.serialize = object => Buffer.from(JSON.stringify(object));
exports.toRecord = (commit) => lodash_1.assign({}, { [commit.commitId]: commit });
exports.createCommitId = () => `${new Date(Date.now()).toISOString().replace(/[^0-9]/g, '')}`;
exports.createInstance = ({ id, entityName, version, events, commitId }) => {
    const now = Date.now();
    const committedAt = now.toString();
    return new commit_1.Commit({
        id,
        entityName,
        commitId,
        committedAt,
        version: parseInt(version, 10),
        events,
        entityId: id
    });
};
