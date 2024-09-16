import {Exception,Process} from '../__types/yao';

describe('Sum function', () => {
    test('yao test', () => {
      expect(Process("utils.env.Get","YAO_SESSION_FILE")).toBe("db/.session");
    });
  });