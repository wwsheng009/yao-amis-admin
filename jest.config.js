/** @type {import('ts-jest').JestConfigWithTsJest} **/
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node', // 可选择其他环境，如jsdom for browser-like tests
  roots: ['<rootDir>/scripts'], // 指定查找源码的根目录
  extensionsToTreatAsEsm: ['.ts', '.tsx'], // 处理为ESM模块的扩展名
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json', 'node'],
  transform: { 
    '^.+\\.(ts|tsx)$': 'ts-jest' // 配置ts-jest转译器
  },
  coverageDirectory: '<rootDir>/coverage', // 覆盖率报告存放位置
  collectCoverageFrom: ['**/*.{ts,tsx}', '!**/*.d.ts'] // 指定覆盖率收集规则
};