"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const createId_1 = require("./createId");
const makeKey_1 = require("./makeKey");
exports.createPolicy = ({ context, policyClass = 'default', sid, allowedEvents, uri, condition, effect = 'Allow' }) => {
    const x509id = createId_1.createId([
        context.clientIdentity.getMSPID(),
        context.clientIdentity.getX509Certificate().subject.commonName
    ]);
    const key = makeKey_1.makeKey([x509id, sid]);
    if (!x509id || !sid || !uri || !context || !allowedEvents || !allowedEvents.length) {
        return null;
    }
    const basePolicy = {
        key,
        policyClass,
        sid,
        allowedEvents,
        attributes: {
            uri
        },
        effect
    };
    if (condition)
        basePolicy.condition = condition;
    return basePolicy;
};
