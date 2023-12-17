//amis 扩展

let amisLib = amisRequire("amis");

amisLib.addRule(
  // 校验名
  "isSameId",
  // 校验函数，values 是表单里所有表单项的值，可用于做联合校验；value 是当前表单项的值
  (values, value) => {
    if (value != values.id) {
      // return true 表示校验通过
      return true;
    }
    // return false 表示校验不通过，会进行错误提示
    return false;
  },
  // 出错时的报错信息
  "输入值不能等于id"
);

//注册自定义组件
amisLib.Renderer({
  test: /(^|\/)my-custom/,
})(CustomComponent);

//注册自定义组件
amisLib.Renderer({
  test: /(^|\/)my-vue-custom/,
})(CustomVueComponent);

//注册自定义组件
amisLib.Renderer({
  test: /(^|\/)my-sse-vue/,
})(CustomSSEComponent);
