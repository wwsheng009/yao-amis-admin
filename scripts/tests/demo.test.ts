import { Process } from '@yaoapps/client';

describe('Sum function', () => {
  test('yao test', () => {
    expect(Process('utils.env.Get', 'YAO_SESSION_FILE')).toBe('db/.session');
  });
});
