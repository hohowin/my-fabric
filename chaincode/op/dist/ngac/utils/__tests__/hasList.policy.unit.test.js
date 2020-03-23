"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const hasList_1 = require("../hasList");
const samples_1 = require("./__utils__/samples");
const sid = 'test-statement';
const effect = 'Allow';
const resourceAttrs = samples_1.target;
describe('Policy Decision Engine Tests', () => {
    it('should pass #1', () => expect(hasList_1.hasList({
        sid,
        effect,
        requirement: samples_1.requirement,
        resourceAttrs,
        condition: {
            hasList: { updateDoc: 'creator_id' }
        }
    })).toEqual([{ sid: 'test-statement', assertion: true }]));
    it('should pass #2', () => expect(hasList_1.hasList({
        sid,
        effect,
        requirement: samples_1.requirement,
        resourceAttrs,
        condition: {
            hasList: { updateDoc: 'invoker_id' }
        }
    })).toEqual([{ sid: 'test-statement', assertion: true }]));
    it('should pass #3', () => {
        const attributes = [];
        attributes.push(...samples_1.requirement);
        attributes.push({
            type: 'N',
            key: 'teammember',
            value: ['Org2MSP::svs_org2_pe_test6115']
        });
        expect(hasList_1.hasList({
            sid,
            effect,
            requirement: samples_1.requirement,
            resourceAttrs: attributes,
            condition: {
                hasList: { updateDoc: 'teammember' }
            },
            debug: false
        })).toEqual([{ sid: 'test-statement', assertion: true }]);
    });
    it('should fail #1', () => expect(hasList_1.hasList({
        sid,
        effect,
        requirement: samples_1.requirement,
        resourceAttrs,
        condition: {
            hasList: { updateDoc: 'no_such_identifier' }
        }
    })).toEqual([{ sid: 'test-statement', assertion: false }]));
});
