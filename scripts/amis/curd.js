const {
  getFilterFormFields,
  getFormFields,
  getFormViewFields,
  getTableFieldsWithQuick,
  excelMapping,
} = Require("amis.lib");

//直接生成一个数据库表对应的amis crud单一页面的配置源码
//有两个用途：对格式不高的，可以直接在页面中引用生成的模板
//对格式有要求的，使用studio命令生成页面后再修改

// yao run scripts.amis.curd.curdTemplate demo.table
function curdTemplate(tabName, columns) {
  let filterForm = getFilterFormFields(tabName, columns);

  let curdColumns = [...getTableFieldsWithQuick(tabName, columns)];
  let newForm = getFormFields(tabName, columns, ["id"]);
  //批量导入数据
  let batchNewForm = [
    {
      name: "excel",
      type: "input-excel",
    },
    {
      columns: [...curdColumns.filter((col) => col.quickEdit !== false)],
      copyable: true,
      editable: true,
      name: "excel",
      removable: true,
      showIndex: true,
      type: "input-table",
      addable: true,
    },
  ];

  const updateForm = getFormFields(tabName, columns);
  const viewForm = getFormViewFields(tabName, columns);

  return returnData(
    tabName,
    filterForm,
    curdColumns,
    newForm,
    batchNewForm,
    updateForm,
    viewForm,
    columns
  );
}
function returnData(
  tableName,
  filterForm,
  curdColumns,
  newForm,
  batchNewForm,
  updateForm,
  viewForm,
  columns
) {
  const template = {
    body: [
      {
        filter: {
          silentPolling: false,
          title: "",
          trimValues: true,
          type: "",
          actions: [
            {
              label: "清空",
              level: "default",
              type: "button",
              actionType: "clear-and-submit",
            },
            {
              label: "重置",
              level: "default",
              type: "button",
              actionType: "reset-and-submit",
            },
            {
              label: "搜索",
              level: "primary",
              type: "button",
              actionType: "submit",
            },
          ],
          body: filterForm,
          mode: "inline",
          name: "list",
        },
        filterDefaultVisible: false,
        keepItemSelectionOnPageChange: true,
        perPage: 10,
        primaryField: "id",
        api: {
          method: "post",
          url:
            `/api/v1/system/model/${tableName}` +
            "/search?page=${page}&perPage=${perPage}&orderBy=${orderBy}&orderDir=${orderDir}",
          data: {
            "&": "$$",
          },
        },
        autoFillHeight: true,
        columns: [
          ...curdColumns,
          {
            type: "operation",
            label: "操作",
            width: 100,
            buttons: [
              {
                type: "button",
                icon: "fa fa-eye",
                actionType: "dialog",
                tooltip: "查看",
                dialog: {
                  title: "查看",
                  size: "lg",
                  body: {
                    type: "form",
                    body: viewForm,
                  },
                },
              },
              {
                icon: "fa fa-pencil",
                tooltip: "更新",
                type: "button",
                actionType: "dialog",
                dialog: {
                  title: "更新",
                  type: "dialog",
                  size: "lg",
                  body: {
                    api: `post:/api/v1/system/model/${tableName}/update/$id`,
                    body: updateForm,
                    name: "update",
                    silentPolling: false,
                    trimValues: true,
                    type: "form",
                  },
                },
              },
              {
                api: `delete:/api/v1/system/model/${tableName}/delete/$id`,
                confirmText: "你确定要删除行${id}?",
                icon: "fa fa-times text-danger",
                tooltip: "删除",
                type: "button",
                actionType: "ajax",
              },
            ],
          },
        ],
        filterTogglable: true,
        headerToolbar: [
          {
            // align: "right",
            type: "columns-toggler",
          },
          "filter-toggler",
          "reload",
          "bulkActions",
          {
            align: "right",
            type: "drag-toggler",
          },
          // {
          //   align: "right",
          //   type: "pagination",
          // },
          // {
          //   align: "right",
          //   className: "v-middle",
          //   tpl: "显示${total}条结果中的${items|count}条",
          //   type: "tpl",
          // },
          {
            type: "button",
            align: "right",
            actionType: "dialog",
            dialog: {
              body: {
                api: `post:/api/v1/system/model/${tableName}/create`,
                body: newForm,
                name: "create",
                silentPolling: false,
                type: "form",
              },
              size: "lg",
              title: "新增",
              type: "dialog",
            },
            icon: "fa fa-plus pull-left",
            label: "新增",
            level: "primary",
          },
          {
            type: "button",
            actionType: "dialog",
            dialog: {
              size: "full",
              title: "批量新增",
              type: "dialog",
              body: {
                body: batchNewForm,
                mode: "normal",
                silentPolling: false,
                type: "form",
                api: {
                  data: {
                    batch: {
                      "&": {
                        $excel: excelMapping(tableName, columns),
                      },
                    },
                  },
                  method: "post",
                  url: `/api/v1/system/model/${tableName}/batch_create`,
                },
              },
            },
            icon: "fa fa-plus pull-left",
            label: "批量新增",
            level: "primary",
          },
        ],
        type: "crud",
        itemActions: [],
        bulkActions: [
          {
            actionType: "ajax",
            api:
              `delete:/api/v1/system/model/${tableName}` + "/delete/${ids|raw}",
            confirmText: "你确定要批量删除选中行吗?",
            label: "批量删除",
            type: "button",
          },
        ],
        footerToolbar: [
          "statistics",
          "switch-per-page",
          "pagination",
          "load-more",
          "export-csv",
          "export-excel",
        ],
        quickSaveItemApi:
          `post:/api/v1/system/model/${tableName}` + "/update/${id}",
        syncLocation: false,
      },
    ],
    type: "page",
  };

  return template;
}
