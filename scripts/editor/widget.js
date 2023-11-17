//yao run scripts.editor.getPages
function getPages() {
  const amisdsl = Process("models.system.amis.get", null);
  let result = {};
  amisdsl.forEach((line) => {
    const page = line.source;
    if (page.type && page.type !== "app") {
      result[line.file] = page;
    }
  });
  return result;
}

// scripts.editor.getPage "404.json"
function getPage(file) {
  const [amisdsl] = Process("models.system.amis.get", {
    // https://wwsheng009.github.io/yao-docs/YaoDSL/Query/QueryDsl.html
    // 在flow Query或是js Query中才使用query qsl语法
    // wheres: [{ ":file": "文件", "=": file }],

    // https://wwsheng009.github.io/yao-docs/YaoDSL/Query/QueryParam%E8%AF%AD%E6%B3%95.html
    // 在models处理器传参数时需要使用queryParam语法
    wheres: [{ column: "file", value: file }],
    limit: 1,
  });
  return amisdsl.source || {};
}

function savePage(file, payload) {
  if (!file.endsWith(".json")) {
    return;
  }
  if (!payload.type) {
    //empty page
    return;
  }
  Process("widget.save", "amis", file, payload);
}
//删除页面
function deletePage(file) {
  Process("widget.remove", "amis", file);
}
