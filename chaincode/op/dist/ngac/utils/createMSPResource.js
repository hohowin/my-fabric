"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const types_1 = require("../types");
const createId_1 = require("./createId");
exports.createMSPResource = ({ context, mspId, mspAttrs }) => {
    if (!mspId || !context || !mspAttrs) {
        return null;
    }
    const cid = context.clientIdentity;
    const contextAttrs = [];
    // todo: replace with optional chaining to avoid TypeError: cannot read property of undefined
    // const invoker_id = cid.getID();
    const invoker_id = createId_1.createId([cid.getMSPID(), cid.getX509Certificate().subject.commonName]);
    const invoker_mspid = cid.getMSPID();
    const subject_cn = cid.getX509Certificate().subject.commonName;
    const subject_orgname = cid.getX509Certificate().subject.organizationName;
    const subject_ouname = cid.getX509Certificate().subject.organizationalUnitName;
    const issuer_cn = cid.getX509Certificate().issuer.commonName;
    const issuer_orgname = cid.getX509Certificate().issuer.organizationName;
    const attr = (key, value) => (value ? { type: '1', key, value } : null);
    contextAttrs.push(...[
        attr(types_1.CONTEXT.INVOKER_MSPID, invoker_mspid),
        attr(types_1.CONTEXT.INVOKER_ID, invoker_id),
        attr(types_1.CONTEXT.SUBJECT_CN, subject_cn),
        attr(types_1.CONTEXT.SUBJECT_ORGNAME, subject_orgname),
        attr(types_1.CONTEXT.SUBJECT_OUNAME, subject_ouname),
        attr(types_1.CONTEXT.ISSUER_CN, issuer_cn),
        attr(types_1.CONTEXT.ISSUER_ORGNAME, issuer_orgname)
    ].filter(item => !!item));
    return {
        key: JSON.stringify(mspId),
        uri: `msp/${mspId}`,
        contextAttrs,
        mspAttrs: mspAttrs || []
    };
};
