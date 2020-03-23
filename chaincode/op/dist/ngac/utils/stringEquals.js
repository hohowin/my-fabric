"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.stringEquals = ({ sid, contextAttrs, requirement, condition, debug = false }) => !condition.stringEquals
    ? [{ sid, assertion: true, message: 'No stringEquals condition defined' }]
    : Object.entries(condition.stringEquals)
        .map(([contextKey, resourceKey]) => {
        const left = contextAttrs.find(({ key }) => key === contextKey);
        const right = requirement.find(({ key }) => key === resourceKey);
        if (debug) {
            console.log(`Left:${left} -- Right${right}`);
        }
        return left && right ? left.value === right.value : false;
    })
        .map(assertion => ({ sid, assertion }));
