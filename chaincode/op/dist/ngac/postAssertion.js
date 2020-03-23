"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const ngacRepo_1 = require("./ngacRepo");
exports.postAssertion = async (assertions, resource, context) => assertions.length > 0
    ? !assertions.map(({ assertion }) => assertion).reduce((prev, curr) => prev && curr, true)
        ? null
        : await ngacRepo_1.ngacRepo(context).addResourceAttr(resource)
    : true;
