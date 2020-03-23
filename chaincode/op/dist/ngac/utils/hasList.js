"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const lodash_1 = require("lodash");
const allowOrDeny = { Allow: true, Deny: false };
exports.hasList = ({ sid, effect, resourceAttrs, requirement, condition, debug = false }) => !condition.hasList
    ? [{ sid, assertion: true, message: 'No hasList condition defined' }]
    : Object.entries(condition.hasList).map(([actionToDo, authorizedAttribute]) => {
        const requiredAttribute = requirement.find(({ key }) => key === actionToDo);
        const assertion = resourceAttrs.reduce((prev, { type, key, value }) => {
            if (!requiredAttribute)
                return false;
            const result = prev ||
                (key !== authorizedAttribute
                    ? false
                    : type === '1'
                        ? lodash_1.includes(requiredAttribute.value, value)
                        : !!lodash_1.intersection(requiredAttribute.value, value).length);
            if (debug)
                console.log(`Target-attr=${key}/${value} vs Authorized-attr=${authorizedAttribute}  -> fulfilling ${JSON.stringify(requiredAttribute)} -> result=${result}`);
            return result;
        }, false);
        return assertion
            ? {
                sid,
                assertion: allowOrDeny[effect]
            }
            : {
                sid,
                assertion: !allowOrDeny[effect]
            };
    });
