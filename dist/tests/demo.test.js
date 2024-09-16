"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const yao_1 = require("../__types/yao");
describe('Sum function', () => {
    test('yao test', () => {
        expect((0, yao_1.Process)("utils.env.Get", "YAO_SESSION_FILE")).toBe("db/.session");
    });
});
//# sourceMappingURL=demo.test.js.map