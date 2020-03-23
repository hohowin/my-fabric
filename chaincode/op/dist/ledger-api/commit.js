"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const index_1 = require("./index");
class Commit {
    constructor({ id, entityName, commitId, version, committedAt, entityId, events }) {
        this.key = index_1.makeKey([entityName, id, commitId]);
        this.id = id;
        this.entityName = entityName;
        this.version = version;
        this.commitId = commitId;
        this.committedAt = committedAt;
        this.entityId = entityId;
        this.events = events;
    }
}
exports.Commit = Commit;
