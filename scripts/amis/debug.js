function dumpSession() {
  const sess = Process("session.dump");
  const session_id = Process("session.id");
  let data = {
    session_dump: sess,
    session_id: session_id,
    session_data: Process("session.dump", session_id),
  };
  return {
    type: "page",
    label: "调试",
    url: "1",
    id: "u:a31a067ebc81",
    data: {
      token: "Bearer ${cookie:token}",
    },
    body: [
      {
        type: "editor",
        label: "服务器当前会话内容",
        name: "editor",
        id: "u:d2bb81d48562",
        language: "json",
        value: data,
      },
      {
        type: "input-text",
        label: "访问API Token",
        static: "true",
        name: "token",
      },
    ],
  };
}

function demoPage() {
  return {
    body: [
      {
        type: "table-view",
        trs: [
          {
            tds: [
              {
                body: {
                  type: "tpl",
                  wrapperComponent: "",
                  tpl: "版本信息",
                  id: "u:74dd6e4d527a",
                },
                $$row: 0,
                $$col: 0,
                id: "u:50ff0a9a2116",
                rowspan: 2,
              },
              {
                body: [
                  {
                    id: "u:2db4f57c010f",
                    messages: {},
                    api: {
                      url: "/api/v1/system/util/version",
                      method: "get",
                    },
                    type: "service",
                    body: [
                      {
                        type: "tpl",
                        tpl: "Yao:${version}",
                        wrapperComponent: "",
                        inline: false,
                        id: "u:e9f327deab5d",
                      },
                    ],
                  },
                ],
                $$row: 1,
                $$col: 1,
                id: "u:9ad4fd615879",
                rowspan: "",
              },
            ],
            id: "u:2d687416ee69",
            height: 43.79999923706055,
          },
          {
            tds: [
              {
                rowspan: "",
                body: {
                  type: "tpl",
                  wrapperComponent: "",
                  tpl: "Amis 3.5.2",
                  id: "u:00d630214f61",
                },
                $$row: 1,
                $$col: 1,
                id: "u:dd1c452fef83",
              },
            ],
            id: "u:11484e5b55a2",
          },
          {
            tds: [
              {
                body: {
                  type: "tpl",
                  wrapperComponent: "",
                  tpl: "Yao",
                  id: "u:63cb7262ac92",
                },
                id: "u:169d2bb9cd02",
                $$row: 3,
                $$col: 0,
              },
              {
                body: [
                  {
                    type: "link",
                    href: "https://yaoapps.com/",
                  },
                ],
              },
            ],
            id: "u:096f81a7c86e",
            height: 43.79999923706055,
          },
          {
            tds: [
              {
                body: {
                  type: "tpl",
                  wrapperComponent: "",
                  tpl: "源代码",
                  id: "u:63cb7262ac92",
                },
                $$row: 2,
                $$col: 0,
                id: "u:169d2bb9cd02",
              },
              {
                body: [
                  {
                    type: "link",
                    id: "u:7cca71e675dd",
                    href: "https://github.com/wwsheng009/yao-amis-admin",
                  },
                ],
                $$row: 3,
                $$col: 1,
                id: "u:bca3a5c105ed",
              },
            ],
            id: "u:096f81a7c86e",
            height: 43.79999923706055,
          },

          {
            tds: [
              {
                body: {
                  type: "tpl",
                  wrapperComponent: "",
                  tpl: "文档",
                  id: "u:63cb7262ac92",
                },
                id: "u:169d2bb9cd02",
                $$row: 3,
                $$col: 0,
              },
              {
                body: [
                  {
                    type: "link",
                    id: "u:7cca71e675dd",
                    href: "https://wwsheng009.github.io/yao-docs/Amis/",
                  },
                ],
                id: "u:bca3a5c105ed",
              },
            ],
            id: "u:096f81a7c86e",
            height: 43.79999923706055,
          },
        ],
        id: "u:aca5c0db6c8d",
      },
    ],
    id: "u:949972723646",
    pullRefresh: {
      disabled: true,
    },
    regions: ["body", "header"],
    subTitle:
      "yao-amis-admin 是一个基于Yao,Amis的后台解决方案，目标是为中大型项目开发,提供现成的开箱解决方案及丰富的示例,原则上不会限制任何代码用于商用。",
    type: "page",
    title: "关于",
  };
}
