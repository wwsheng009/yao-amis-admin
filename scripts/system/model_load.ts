import { AmisModel, ModelId } from '@yao/types';
import { Exception, Process } from '@yaoapps/client';
import { FileNameConvert, IsSqlite } from './lib';
import { YaoModel } from '@yaoapps/types';
import { convertAmisColToYaoCol } from './model_convert';

/**
 * 把模型定义加载到模型缓存中。
 * Yao中的模型定义可以保存在文件中，也可以放在别的地方，最终是加载到Yao的应用缓存中
 * @param {object} modelDsl 模型定义
 * @param {boolean} migrate 更新数据库
 * @param {boolean} force 强制更新
 * @returns
 */
export function loadModeltoMemory(
  modelDsl: YaoModel.ModelDSL,
  migrate?: boolean,
  force?: boolean
) {
  if (!Array.isArray(modelDsl.columns) || !modelDsl.columns?.length) {
    return;
  }

  const modelYao = deepCopyObject(modelDsl) as AmisModel;
  modelYao.columns.forEach((col, ix) => {
    modelYao.columns[ix] = convertAmisColToYaoCol(col);
  });
  if (modelYao.table?.name && modelYao.ID && modelYao.columns?.length) {
    let fname = `${modelYao.ID}.mod.json`;
    fname = FileNameConvert(fname);

    // console.log("modelYao", modelYao);
    let err = Process(
      `models.${modelYao.ID}.load`,
      fname,
      JSON.stringify(modelYao)
    );
    if (!err && migrate) {
      err = migrateModel(modelYao.ID, force);
    }
    checkAndloadDefaultTableForm(modelYao.ID);
    return err;
  } else {
    throw new Exception('模型定义不完整，缺少必要信息');
  }
}
export function deepCopyObject<T>(obj: T): T {
  return JSON.parse(JSON.stringify(obj));
}
export function migrateModel(modelId: string, forceIn?: boolean) {
  let force = forceIn;
  if (IsSqlite()) {
    force = true;
  }
  if (force == null) {
    force = false;
  }

  // console.log("migrate force:", force);

  if (modelId.toLowerCase().startsWith('ddic.model') && force) {
    return;
    // throw new Exception(`不能删除系统模型:${modelId}`);
  }
  const err = Process(`models.${modelId}.migrate`, force);
  // console.log("migrate err:", err);
  if (err?.Message && err?.Number) {
    if (IsSqlite()) {
      const sqlStateString = bytesToString(err.SQLState);

      throw new Exception(
        `Message:${err.Message},Number:${err.Number},SQLState:${sqlStateString}`,
        500
      );
    } else {
      throw new Exception(`Message:${err.Message},Number:${err.Number}`, 500);
    }
  }

  return err;
}
function bytesToString(bytes: number[]) {
  let string = '';
  for (let i = 0; i < bytes.length; i++) {
    string += String.fromCharCode(bytes[i]);
  }
  return string;
}

/**
 * load default form and table config
 * @param modelId model id
 */
export function checkAndloadDefaultTableForm(modelId: string) {
  if (Process('yao.form.exists', modelId)) {
    if (checkIsDefaultForm(modelId)) {
      loadDefaultFormForModel(modelId);
    }
  } else {
    loadDefaultFormForModel(modelId);
  }
  if (Process('yao.table.exists', modelId)) {
    if (checkIsDefaultTable(modelId)) {
      loadDefaultTableFromModel(modelId);
    }
  } else {
    loadDefaultTableFromModel(modelId);
  }
}

function checkIsDefaultForm(modelId: ModelId) {
  const jsonObj = Process('yao.form.read', modelId);
  if (!checkJsonAttributes(jsonObj)) {
    return false;
  }
  const f1 = getDefaultFormTemplate(modelId);
  if (JSON.stringify(f1.action) == JSON.stringify(jsonObj.action)) {
    return true;
  }
  return false;
}
function checkIsDefaultTable(modelId: ModelId) {
  const jsonObj = Process('yao.table.read', modelId);

  if (!checkJsonAttributes(jsonObj)) {
    return false;
  }
  const f1 = getDefaultTableTemplate(modelId);
  if (JSON.stringify(f1.action) == JSON.stringify(jsonObj.action)) {
    return true;
  }
  return false;
}
function checkJsonAttributes(jsonObj) {
  // Get the keys of the JSON object
  const keys = Object.keys(jsonObj);

  // Check if the only keys are 'name' and 'action'
  const validKeys = ['name', 'action'];

  // Ensure the object has exactly 2 keys and that they match 'name' and 'action'
  return keys.length === 2 && keys.every((key) => validKeys.includes(key));
}

function loadDefaultFormForModel(modelId: ModelId) {
  // console.log('loadDefaultFormForModel', modelId);

  // console.log(JSON.stringify(formTemplate));
  Process(
    'yao.form.load',
    modelId,
    '',
    JSON.stringify(getDefaultFormTemplate(modelId))
  );
}
function getDefaultTableTemplate(modelId: ModelId) {
  return {
    name: modelId,
    action: {
      bind: {
        model: modelId,
        option: {
          withs: {},
          form: modelId
        }
      }
    }
  };
}
/**
 * load the form first.
 * @param modelId model id
 */
function loadDefaultTableFromModel(modelId: ModelId) {
  Process(
    'yao.table.load',
    modelId,
    '',
    JSON.stringify(getDefaultTableTemplate(modelId))
  );
}

function getDefaultFormTemplate(modelId: ModelId) {
  return {
    name: modelId,
    action: {
      bind: {
        model: modelId,
        option: {
          withs: {}
        }
      }
    }
  };
}
