import { DotName, UnderscoreName, SlashName } from '@scripts/system/lib';
import { AmisViewComponent } from '@yao/types';
import { Exception, FS, Process, ssWrite } from '@yao/yao';
import { YaoForm, YaoModel, YaoTable } from '@yaoapps/types';

interface AiModelColumn {
  label: string;
  name: string;
  type: string;
  length?: number;
  index?: boolean;
  nullable?: boolean;
  Searchable?: boolean;
  Component?: {
    table?: {
      view?: string;
      edit?: string;
    };
    form?: {
      view?: string;
      edit?: string;
    };
  };
}
interface AiModel {
  name: string;
  table: {
    name: string;
  };
  columns: AiModelColumn[];
}
/**
 * Template module
 */
const Template = {
  data: {
    name: 'Pet',
    table: { name: 'pet' },
    columns: [
      { label: 'ID', name: 'id', type: 'ID' },
      {
        label: 'Name',
        name: 'name',
        type: 'string',
        length: 256,
        index: true,
        nullable: true,
        Searchable: true,
        Component: {
          table: { view: 'Text', edit: 'Input' },
          form: { view: 'Text', edit: 'Input' }
        }
      }
    ]
  } as AiModel,
  explain: `
      - The above content is the JSON template.
      - The JSON template is used to generate the module.
      - The field "name" is a module name.
      - The field "table" is a table, the table "name" is used to generate the table in database.
      - The field "columns" is a array, each element is a column of table.
      - The field "label" is a column label, the label is used to display in table and form.
      - The field "name" is a column name, the name is used to generate the column in database.
      - The field "type" is a column type, the type is used to generate the column in database. Should be one of "string", "text", "integer", "date", "datetime", "ID".
      - The field "length" is a column length, the length is used to generate the column in database.
      - The field "index" is a column index, the index is used to generate the column in database.
      - The field "nullable" is a column nullable, the nullable is used to generate the column in database.
      - The field "Searchable" is a column Searchable, the Searchable is used to generate the column in database.
      - The field "Component" is a column Component, the Component is used to generate the column in database.
      - The field "form" is description of the Form interface display.
      - The field "table" is description of the Table interface display.
      - The field "view" is a column view, the view is used to generate the column in database. Should be one of "Text", "Tag".
      - The field "edit" is a column edit, the edit is used to generate the column in database. should be one of "Input", "Select".
    `
};

/**
 * Command neo.module.create
 * Prepare Hook: Before
 * @param {*} context
 * @param {*} messages
 */
export function CreateBefore(context, messages) {
  return { template: Template.data, explain: Template.explain };
}

/**
 * Command neo.module.create
 * Prepare Hook: After
 * @param {*} content
 */
export function CreateAfter(content: string) {
  // console.log("DataAfter:", content);
  const response = JSON.parse(content) as AiModel;
  const columns = response.columns || [];
  // console.log(columns);

  if (columns.length > 0) {
    // Print data preview
    ssWrite(`\r\n| label | name | type | Searchable | Table | Form |\n`);
    ssWrite(`| ----- | ---- | ---- | ---------- | ----- | ---- |\n`);
    columns.forEach((item) => {
      // console.log(item);
      const component = item.Component || {};
      const table = component.table || {};
      const form = component.form || {};
      const message = `| ${item.label} |  ${item.name} |  ${item.type} | ${
        item.Searchable || ''
      } | ${table.view || ''} ${table.edit || ''} | ${form.edit || ''} |\n`;
      ssWrite(message);
    });
    ssWrite(`  \n\n`);
    return { data: response };
  }

  // console.log(content);
  throw new Exception('Error: data is empty.', 500);
}

/**
 * Run the command
 * @param {*} payload
 */
function Create(payload: AiModel) {
  validate(payload);
  saveModel(payload);
  saveTable(payload);
  saveForm(payload);

  // Reload
  const id = payload.table.name;
  const ex = load(id);
  if (ex) {
    // console.log(ex, ex.message);
    throw new Exception(ex.message, 500);
  }

  // model migrage
  // ex = migrateModel(id);
  // if (ex) {
  //   console.log(ex, ex.message);
  //   // throw new Exception(ex.message, 500);
  // }

  return {
    path: `/x/Table//${id}`,
    name: id
  };
}

/**
 * Validate the payload
 * @param {*} data
 */
function validate(data: YaoModel.ModelDSL) {
  if (!data) {
    throw new Exception('Error: data is empty.', 500);
  }
  const model_id = data.table?.name.toLowerCase();

  ['admin', 'ddic', 'system'].forEach((x) => {
    if (model_id.startsWith(x)) {
      throw new Exception('不能覆盖系统文件夹', 500);
    }
  });
  let need_prefix = false;
  if (model_id.split('.').length === 1) {
    need_prefix = true;
  }
  if (!model_id.includes('.')) {
    need_prefix = true;
  }
  if (need_prefix) {
    data.table.name = 'demo.' + data.table.name;
  }

  data.table.name = DotName(data.table.name);
  // @Todo: Validate the data structure
  // ...
}

function saveModel(data: AiModel) {
  // let model_id = data.table?.name;
  const option = { timestamps: true, soft_deletes: true };

  const table = { ...data.table };
  table.name = UnderscoreName(table.name);
  const model = {
    name: data.name,
    table: table,
    columns: [],
    option: option
  };

  data.columns.forEach((item) => {
    model.columns.push({
      name: item.name,
      label: item.label,
      type: item.type,
      length: item.length,
      index: item.index,
      nullable: item.nullable
    });
  });

  Process('scripts.system.model.ImportFromNeo', model);
  // return id;

  // const dsl = new FS('app');
  // model_id = SlashName(model_id);
  // dsl.WriteFile(`/models/${model_id}.mod.yao`, JSON.stringify(model));
}

function saveTable(data: AiModel) {
  const id = data.table.name;
  const filterActions = [
    {
      title: `New ${data.name}`,
      icon: 'icon-plus',
      action: [
        {
          name: 'OpenModal',
          type: 'Common.openModal',
          payload: { width: 900, Form: { type: 'edit', model: id } }
        }
      ]
    }
  ];

  const operation = {
    actions: [
      {
        title: 'View',
        icon: 'icon-eye',
        disabled: { bind: '{{id}}', value: ['1', '2'] },
        action: [
          {
            name: 'OpenModal',
            type: 'Common.openModal',
            payload: { width: 640, Form: { type: 'view', model: id } }
          }
        ]
      },
      {
        title: 'Edit',
        icon: 'icon-edit-2',
        action: [
          {
            name: 'OpenModal',
            type: 'Common.openModal',
            payload: { width: '50vw', Form: { type: 'edit', model: id } }
          }
        ]
      },
      {
        title: 'Delete',
        icon: 'icon-trash-2',
        action: [
          {
            name: 'Confirm',
            type: 'Common.confirm',
            payload: {
              title: 'Confirm',
              desc: 'Please confirm to delete this record.'
            }
          },
          { name: 'Delete', type: 'Table.delete', payload: {} }
        ],
        style: 'danger'
      }
    ]
  };

  const table = {
    name: data.name,
    action: { bind: { model: id, option: {} } },
    layout: {
      primary: 'id',
      header: { preset: {} },
      filter: { columns: [], actions: filterActions },
      table: { columns: [], operation: operation, props: {} }
    },
    fields: { filter: {}, table: {} }
  } as YaoTable.TableDSL;

  // data foreach
  data.columns.forEach((item) => {
    if (!item.Component || !item.Component.table) {
      return;
    }

    const component = item.Component.table;

    // table columns
    table.layout.table.columns.push({ name: item.label });
    table.fields.table[item.label] = TableComponent(item, component);
    // {
    //   bind: item.name,
    //   view: { type: component.view, props: {} },
    //   edit: { type: component.edit, props: { placeholder: item.label } },
    // };

    // table filter
    if (!item.Searchable) {
      return;
    }
    const op = item.type == 'string' ? 'match' : 'eq';
    table.layout.filter.columns.push({ name: item.label, width: 4 });
    table.fields.filter[item.label] = {
      bind: `where.${item.name}.${op}`,
      edit: { type: 'Input', props: { placeholder: item.label } }
    };
  });

  const dsl = new FS('app');

  dsl.WriteFile(`/tables/${SlashName(id)}.tab.yao`, JSON.stringify(table));
}

function TableComponent(
  item: AiModelColumn,
  component: { view?: string; edit?: string }
) {
  const default_component = {
    bind: item.name,
    view: { type: component.view, props: {} },
    edit: { type: component.edit, props: { placeholder: item.label } }
  } as AmisViewComponent;
  switch (item.type) {
    case 'string':
      return default_component;
    case 'datetime':
      default_component['edit']['type'] = 'DatePicker';
      return default_component;
    case 'date':
      default_component['edit']['type'] = 'DatePicker';
      return default_component;
    case 'integer':
      default_component['edit']['props']['type'] = 'number';
      return default_component;
    case 'boolean':
      default_component['view']['type'] = 'Switch';
      default_component['view']['props'] = {
        checkedValue: 1,
        unCheckedValue: 0,
        checkedChildren: 'open',
        unCheckedChildren: 'close'
      };
      default_component['edit']['type'] = 'RadioGroup';
      default_component['edit']['props'] = {
        options: [
          {
            value: 1,
            label: 'open'
          },
          {
            value: 0,
            label: 'close'
          }
        ]
      };
      return default_component;
    default:
      return default_component;
  }
}

function saveForm(data: AiModel) {
  const id = data.table.name;
  const actions = [
    {
      title: 'Save',
      icon: 'icon-check',
      style: 'primary',
      showWhenAdd: true,
      action: [
        { name: 'Submit', type: 'Form.submit', payload: {} },
        { name: 'Back', type: 'Common.closeModal', payload: {} }
      ]
    },
    {
      title: 'Delete',
      icon: 'icon-trash-2',
      style: 'danger',
      divideLine: true,
      action: [
        {
          name: 'Confirm',
          type: 'Common.confirm',
          payload: {
            title: 'Confirm',
            desc: 'Please confirm to delete this record.'
          }
        },
        { name: 'Delete', type: 'Form.delete', payload: {} },
        { name: 'Back', type: 'Common.closeModal', payload: {} }
      ]
    },
    {
      title: 'Back',
      icon: 'icon-arrow-left',
      showWhenAdd: true,
      showWhenView: true,
      action: [{ name: 'CloseModal', type: 'Common.closeModal', payload: {} }]
    }
  ];

  const form = {
    name: data.name,
    action: { bind: { model: id, option: {} } },
    layout: {
      primary: 'id',
      actions: actions,
      form: { props: {}, sections: [{ columns: [] }] }
    },
    fields: { form: {} }
  } as YaoForm.FormDSL;

  // data foreach
  data.columns.forEach((item) => {
    if (!item.Component || !item.Component.form) {
      return;
    }

    const component = item.Component.form;

    // form columns
    form.layout.form.sections[0].columns.push({ name: item.label, width: 12 });
    form.fields.form[item.label] = TableComponent(item, component);
    //  {
    //   bind: item.name,
    //   edit: { type: component.edit, props: { placeholder: item.label } },
    // };
  });

  const dsl = new FS('app');
  dsl.WriteFile(`/forms/${SlashName(id)}.form.yao`, JSON.stringify(form));
}

/**
 * Reload
 * @param {*} id
 */
function load(idIn: string) {
  const id = SlashName(idIn);
  let err = Process(`models.${idIn}.Load`, `/models/${id}.mod.yao`);
  if (err) {
    return err;
  }

  err = Process(`yao.table.Load`, `/tables/${id}.tab.yao`);
  if (err) {
    return err;
  }

  err = Process(`yao.form.Load`, `/forms/${id}.form.yao`);
  if (err) {
    return err;
  }
}

/**
 * Migrate model
 * @param {*} id
 */
export function migrateModel(id: string) {
  return Process(`models.${id}.migrate`);
}
