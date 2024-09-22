import {
  getFormFields,
  getModelFieldsForAmis,
  getFormViewFields,
  getModelFieldsWithQuick
} from '@scripts/amis/lib';

// yao run scripts.amis.schema.generateEditFormFields admin.user
function generateEditFormFields(modelId, columns) {
  const fields = getFormFields(modelId, 'update', columns);
  const schema = {
    type: 'form',
    name: 'yao-form',
    title: '表单',
    mode: 'horizontal',
    dsType: 'api',
    feat: 'Insert',
    body: fields,
    actions: [
      {
        type: 'button',
        label: '提交',
        onEvent: {
          click: {
            actions: [
              {
                actionType: 'submit',
                componentName: 'yao-form'
              }
            ]
          }
        },
        level: 'primary'
      }
    ],
    resetAfterSubmit: true
  };
  return schema;
}
function getTableViewBodySchema(modelId, tableName) {
  const fields = getModelFieldsForAmis(modelId);

  return {
    columns: fields,
    source: '${' + tableName + '}',
    type: 'table'
  };
}

function getFormViewBodySchema(modelId, columns) {
  const fields = getFormViewFields(modelId, columns);

  return fields;
}

// yao run scripts.amis.schema.formViewFieldsSchema
function formViewFieldsSchema(modelId, columns) {
  const fields = getFormViewFields(modelId, columns);
  const schema = {
    type: 'form',
    name: 'yao-form',
    title: '表单',
    mode: 'horizontal',
    dsType: 'api',
    feat: 'Insert',
    body: fields,
    actions: [
      {
        type: 'button',
        label: '确定',
        onEvent: {
          click: {
            actions: [
              {
                actionType: 'submit',
                componentName: 'yao-form'
              }
            ]
          }
        },
        level: 'primary'
      }
    ],
    resetAfterSubmit: true
  };
  return schema;
}

// yao run scripts.amis.schema.generateViewFields admin.user
function generateViewFields(modelId, columns) {
  const fields = getModelFieldsForAmis(modelId, columns);

  const schema = {
    type: 'page',

    body: [
      {
        columns: fields,
        type: 'table'
      }
    ],
    regions: ['body'],
    title: 'button',
    toolbar: []
  };
  return schema;
}

function generateViewFieldsWithQuick(modelId, columns) {
  const fields = getModelFieldsWithQuick(modelId, columns);
  const fieldsForm = getFormFields(modelId, 'create', columns);
  const schema = {
    type: 'page',

    body: [
      {
        columns: fields,
        type: 'crud',
        headerToolbar: [
          {
            label: '新增',
            type: 'button',
            actionType: 'dialog',
            level: 'primary',
            dialog: {
              title: '新增',
              body: {
                type: 'form',
                api: {
                  method: 'post'
                },
                body: fieldsForm
              }
            }
          },
          'bulkActions'
        ]
      }
    ],
    regions: ['body'],
    title: 'button',
    toolbar: []
  };
  return schema;
}
// 动态的生成数据库表的amis crud的处理页面
//

// yao run scripts.amis.schema.curdListPage
function curdListPage(table, columns) {
  const fields = getModelFieldsForAmis(table, columns);
  const schema = {
    type: 'page',
    title: '列表',
    remark: null,
    name: 'page-demo',
    toolbar: [
      {
        type: 'button',
        actionType: 'link',
        link: `/crud/${table}/new`,
        label: '新增',
        primary: true
      }
    ],
    body: [
      {
        type: 'crud',
        name: `${table}`,
        syncLocation: false,
        api: {
          method: 'get',
          url:
            '/api/v1/system/model/' +
            table +
            '/search?page=${page}&perPage=${perPage}&keywords=${keywords}'
        },
        filter: {
          title: '',
          mode: 'inline',
          wrapWithPanel: false,
          submitText: '',
          controls: [
            {
              type: 'text',
              name: 'keywords',
              placeholder: '通过关键字搜索',
              addOn: {
                label: '搜索',
                type: 'submit',
                className: 'btn-success'
              },
              clearable: true
            }
          ],
          className: 'm-b-sm'
        },
        bulkActions: [
          {
            label: '批量修改',
            type: 'button',
            actionType: 'dialog',
            level: 'primary',
            dialog: {
              title: '批量编辑',
              name: 'sample-bulk-edit',
              body: {
                type: 'form',
                api: 'post:/api/v1/system/model/' + table + '/bulkUpdate/$ids',
                controls: [
                  {
                    type: 'text',
                    name: 'engine',
                    label: 'Engine'
                  }
                ]
              }
            }
          },
          {
            label: '批量删除',
            type: 'button',
            level: 'danger',
            actionType: 'ajax',
            api: 'delete:/api/v1/system/model/' + table + '/delete/$ids',
            confirmText: '确定要批量删除?'
          }
        ],
        columns: [
          ...fields,
          {
            type: 'operation',
            label: '操作',
            width: '',
            buttons: [
              {
                type: 'button-group',
                buttons: [
                  {
                    type: 'button',
                    icon: 'fa fa-eye',
                    // label: "查看",
                    // level: "primary",
                    actionType: 'link',
                    link: `/crud/${table}` + '/view/${id}'
                  },
                  {
                    type: 'button',
                    icon: 'fa fa-pencil',
                    // label: "修改",
                    // level: "info",
                    actionType: 'link',
                    link: `/crud/${table}` + '/edit/${id}'
                  },
                  {
                    type: 'button',
                    icon: 'fa fa-times text-danger',
                    // label: "删除",
                    // level: "danger",
                    actionType: 'ajax',
                    confirmText: '您确认要删除?',
                    api: 'post:/api/v1/system/model/' + table + '/delete/$id'
                  }
                ]
              }
            ],
            placeholder: '-',
            fixed: 'right'
          }
        ],
        affixHeader: true,
        columnsTogglable: 'auto',
        placeholder: '暂无数据',
        tableClassName: 'table-db table-striped',
        headerClassName: 'crud-table-header',
        footerClassName: 'crud-table-footer',
        toolbarClassName: 'crud-table-toolbar',
        combineNum: 0,
        bodyClassName: 'panel-default'
      }
    ]
  };
  return schema;
  // return Process("scripts.return.RSuccess", schema, "数据已成功导入");
}

// yao run scripts.amis.schema.curdNewPage
function curdNewPage(table, columns) {
  const fields = getFormFields(table, 'create', columns);
  const schema = {
    type: 'page',
    title: '新增',
    remark: null,
    toolbar: [
      {
        type: 'button',
        actionType: 'link',
        link: `/crud/${table}/list`,
        label: '返回列表'
      }
    ],
    body: [
      {
        title: '',
        type: 'form',
        redirect: `/crud/${table}/list`,
        mode: 'horizontal',
        name: 'sample-edit-form',
        api: '/api/v1/system/model/' + table + '/create',
        controls: [...fields]
      }
    ]
  };
  return schema;
  // return Process("scripts.return.RSuccess", schema, "数据已成功导入");
}
// 查看页面
function curdViewPage(table) {
  const fields = getFormViewFields(table);
  // fields.map((field) => (field.static = true));
  // fields.map((field) => (field.disabled = true));

  const schema = {
    type: 'page',
    title: '查看详情 ${params.id}',
    remark: null,
    toolbar: [
      {
        type: 'button',
        actionType: 'link',
        link: `/crud/${table}/list`,
        label: '返回列表'
      }
    ],
    body: [
      {
        type: 'form',
        mode: 'horizontal',
        initApi: '/api/v1/system/model/' + table + '/find/${params.id}',
        controls: [...fields]
      }
    ]
  };
  return schema;
  // return Process("scripts.return.RSuccess", schema, "数据已成功导入");
}
// 编辑页面
function curdEditPage(table, columns) {
  const fields = getFormFields(table, 'update', columns);
  const schema = {
    type: 'page',
    title: '修改 ${id}',
    remark: null,
    toolbar: [
      {
        type: 'button',
        actionType: 'link',
        link: `/crud/${table}/list`,
        label: '返回列表'
      }
    ],
    body: [
      {
        type: 'form',
        mode: 'horizontal',
        initApi: '/api/v1/system/model/' + table + '/find/${params.id}',
        api: '/api/v1/system/model/' + table + '/update/$id',
        redirect: `/crud/${table}/list`,
        controls: [...fields]
      }
    ]
  };
  return schema;
  // return Process("scripts.return.RSuccess", schema, "数据已成功导入");
}
