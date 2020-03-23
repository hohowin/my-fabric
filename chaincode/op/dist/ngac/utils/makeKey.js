"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.makeKey = (keyParts) => keyParts.map(part => JSON.stringify(part)).join('~');
exports.splitKey = (key) => key.split('~');
