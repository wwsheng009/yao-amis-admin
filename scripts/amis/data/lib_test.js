function mergeQueryObject(querysIn, payload) {
  // console.log(`types of querysIn${typeof querysIn}`);
  // console.log(`types of payload${typeof payload}`);

  let querys = querysIn;
  if (querysIn == null || payload == null) {
    return querysIn;
  }
  if (typeof querysIn !== "object") {
    return querysIn;
  }
  if (payload != null && typeof payload === "object") {
    for (const key in payload) {
      if (Object.hasOwnProperty.call(payload, key)) {
        const element = payload[key];
        let values = querys[key];
        if (Array.isArray(values)) {
          if (!values.some((x) => x == element)) {
            //使用弱比较，'1'应该等于1
            querys[key].push(element);
          }
        } else {
          querys[key] = [element];
        }
      }
    }
  }

  return querys;
}

//yao run scripts.amis.data.test.testMerage
function testMerage() {
  const querys = {
    orderBy: [""],
    orderDir: [""],
    page: ["1"],
    perPage: ["10"],
  };
  const payload = {
    name: "*请求",
    page: 1,
    perPage: 10,
  };

  const data = mergeQueryObject(querys, payload);
  console.log(data);
  return data;
}
// testMerage();

function FilterArrayWithQuery(list, querysIn) {
  if (!Array.isArray(list) || list.length == 0) {
    return list;
  }
  let querys = querysIn;

  let first = list[0];

  if (!typeof first === "object") {
    return list;
  }

  let AndMode = true;
  if (typeof querys === "object") {
    delete querys["page"];
    delete querys["pageSize"];
    delete querys["orderDir"];
    delete querys["orderBy"];
    let keyword = "";
    if (Array.isArray(querys["keywords"]) && querys["keywords"].length) {
      keyword = querys["keywords"][0];
    }

    if (keyword != "" && !first["keywords"]) {
      for (const key in first) {
        if (Object.hasOwnProperty.call(first, key)) {
          querys[key] = [keyword];
        }
      }
      AndMode = false;
    }
  }

  for (const key in querys) {
    if (!Object.hasOwnProperty.call(first, key)) {
      delete querys[key];
    }
  }

  const arr = list.filter((item) => {
    for (let key in querys) {
      let value = querys[key] + "";
      if (Array.isArray(querys[key]) && querys[key].length) {
        value = querys[key][0] + "";
      }
      if (value === undefined) continue;
      if (value.includes("*")) {
        const pattern = new RegExp(`^${value.replace(/\*/g, ".*")}`, "i");
        if (AndMode) {
          if (!pattern.test(item[key])) return false;
        } else {
          if (pattern.test(item[key])) return true;
        }
      } else {
        if (AndMode) {
          if (item[key] + "" != value) return false;
        } else {
          if (item[key] + "" == value) return true;
        }
      }
    }
    if (AndMode) {
      return true;
    } else {
      return false;
    }
  });
  return arr;
}

function test1() {
  const data = [
    {
      cached: true,
      created: true,
      label: "用户表",
      model: "admin.user",
      name: "admin_user",
      saved: false,
    },
    {
      cached: false,
      created: true,
      label: "ddic_form",
      name: "ddic_form",
      saved: false,
    },
    {
      cached: false,
      created: true,
      label: "ddic_form_action",
      name: "ddic_form_action",
      saved: false,
    },
    {
      cached: false,
      created: true,
      label: "ddic_form_field",
      name: "ddic_form_field",
      saved: false,
    },
    {
      cached: true,
      created: true,
      label: "业务模型",
      model: "ddic.model",
      name: "ddic_model",
      saved: false,
    },
    {
      cached: true,
      created: true,
      label: "模型字段列表",
      model: "ddic.model.column",
      name: "ddic_model_column",
      saved: false,
    },
    {
      cached: true,
      created: true,
      label: "模型数据类型",
      model: "ddic.model.column.type",
      name: "ddic_model_column_type",
      saved: false,
    },
    {
      cached: true,
      created: true,
      label: "数据元素",
      model: "ddic.model.element",
      name: "ddic_model_element",
      saved: false,
    },
    {
      cached: false,
      created: true,
      label: "ddic_table",
      name: "ddic_table",
      saved: false,
    },
    {
      cached: false,
      created: true,
      label: "ddic_table_action",
      name: "ddic_table_action",
      saved: false,
    },
    {
      cached: false,
      created: true,
      label: "ddic_table_field",
      name: "ddic_table_field",
      saved: false,
    },
    {
      cached: false,
      created: true,
      label: "ddic_table_filter",
      name: "ddic_table_filter",
      saved: false,
    },
    {
      cached: false,
      created: true,
      label: "demo_book",
      name: "demo_book",
      saved: false,
    },
    {
      cached: true,
      created: true,
      label: "demo_excel",
      model: "demo.excel",
      name: "demo_excel",
      saved: false,
    },
    {
      cached: false,
      created: true,
      label: "demo_mobile",
      name: "demo_mobile",
      saved: false,
    },
    {
      cached: true,
      created: true,
      label: "演示表",
      model: "demo.table",
      model_name: "demo.table",
      name: "demo_table",
      saved: true,
    },
    {
      cached: true,
      created: true,
      label: "dsl_amis",
      model: "system.amis",
      name: "dsl_amis",
      saved: false,
    },
    {
      cached: false,
      created: true,
      label: "phone_config",
      model: "phone.config",
      model_name: "phone.config",
      name: "phone_config",
      saved: true,
    },
    {
      cached: true,
      created: true,
      label: "system_api",
      model: "system.api",
      name: "system_api",
      saved: false,
    },
    {
      cached: true,
      created: true,
      label: "system_dept",
      model: "system.dept",
      name: "system_dept",
      saved: false,
    },
    {
      cached: true,
      created: true,
      label: "用户的编辑器文件",
      model: "system.file",
      name: "system_file",
      saved: false,
    },
    {
      cached: true,
      created: true,
      label: "system_font",
      model: "system.font",
      name: "system_font",
      saved: false,
    },
    {
      cached: true,
      created: true,
      label: "菜单表",
      model: "system.menu",
      name: "system_menu",
      saved: false,
    },
    {
      cached: true,
      created: true,
      label: "system_role",
      model: "system.auth.role",
      name: "system_role",
      saved: false,
    },
    {
      cached: false,
      created: true,
      label: "water_bottle",
      name: "water_bottle",
      saved: false,
    },
    {
      cached: false,
      created: true,
      label: "yao_neo_conversation",
      name: "yao_neo_conversation",
      saved: false,
    },
  ];
  const query = {
    // cached: [false],
    // saved: [false],
    // label: ["ddic_form_*"],
    keywords: ["ddic_form_*"],
    // keywords: [""],
  };

  let data1 = FilterArrayWithQuery(data, query);
  console.log(data1);
}
// test1();

function testGet(data, pageIn, pageSizeIn, querysIn, payload) {
  const querys = { page: [1], perPage: [10] };
  function getArrayItem(key) {
    if (typeof querys !== "object") {
      return;
    }
    if (Array.isArray(querys[key]) && querys[key].length) {
      return querys[key][0];
    } else {
      return querys[key];
    }
  }
  let page = pageIn;
  let pageSize = pageSizeIn;
  if (page == null) {
    page = getArrayItem("page");
  }
  if (pageSize == null) {
    pageSize = getArrayItem("perPage");
  }
}
testGet();
