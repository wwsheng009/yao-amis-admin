import { Exception } from '@yao/yao';

/**
 * Dyform Loader: load
 * @param {*} id
 * @param {*} source
 * @returns
 */
export function Load(id, source: string) {
  const dsl = source || {};
  dsl['id'] = id;
  return dsl;
}

/**
 * Dyform Loader: reload
 * @param {*} id
 * @param {*} source
 * @param {*} dsl
 * @returns
 */
export function Reload(id: number, source: string, dsl) {
  const newDSL = source || {};
  newDSL['id'] = id;
  // newDSL["tests.reload"] = typeof dsl === "object";
  return newDSL;
}

/**
 * Dyform Loader: unload
 * @param {*} id
 */
export function Unload(id: number) {
  if (id == undefined || id == null) {
    throw new Exception('id is required');
  }
}

// ** Dyform Process ***
// ========================================

/**
 * widgets.dyform.Setting
 */
export function Setting(id: number, dsl) {
  dsl = dsl || {};
  // dsl["tests.id"] = id;
  return dsl;
}

// export function LoadModel() {
//   var model_dsl = {
//     columns: [
//       { comment: "ID", label: "ID", name: "id", primary: true, type: "ID" },
//       {
//         comment: "项目id",
//         label: "项目id",
//         name: "project_id",
//         nullable: true,
//         type: "integer",
//       },
//       {
//         comment: "审核状态:待审核,已通过,已驳回",
//         label: "审核状态",
//         name: "audit_status",
//         nullable: true,
//         type: "string",
//       },
//     ],
//     indexes: [],
//     name: "instance_4",
//     option: { soft_deletes: true, timestamps: true },
//     relations: {},
//     table: { name: "instance_4" },
//     values: [],
//   };

//   Process(
//     "models.dyform.test.Load",
//     "dyform.test.mod.yao",
//     JSON.stringify(model_dsl)
//   );

//   Process("models.dyform.test.Migrate");
//   Process("models.dyform.test.Create", {
//     id: 1,
//     project_id: 1,
//     audit_status: "待审核",
//   });

//   return Process("models.dyform.test.Find", 1, {});
// }
