import globals from "globals";
import pluginJs from "@eslint/js";
import tseslint from "typescript-eslint";
import stylistic from "@stylistic/eslint-plugin";
// import eslintPluginPrettierRecommended from "eslint-plugin-prettier/recommended";

export default [
  {
    ignores: ["node_modules", "dist", "public"],
  },

  /** js推荐配置 */
  pluginJs.configs.recommended,
  /** ts推荐配置 */
  ...tseslint.configs.recommended,
  stylistic.configs.customize({
    indent: 2,
    quotes: "double",
    semi: true,
    jsx: false,
    braceStyle: "1tbs",
    arrowParens: "always",
  }),
  /**
   * javascript 规则
   */
  {
    files: ["**/*.{js,mjs,cjs}"],
    rules: {
      "no-console": "error",
    },
  },
  { languageOptions: { globals: globals.browser } },
  /**
   * typescript 规则
   */
  {
    files: ["**/*.{ts}"],
    rules: {},
  },
  /**
   * prettier 配置
   * 会合并根目录下的prettier.config.js 文件
   * @see https://prettier.io/docs/en/options
   */
  // eslintPluginPrettierRecommended,
];
