import { AmisModel } from '@yao/types';
import { Process, FS } from '@yao/yao';
import { DotName, SlashName } from './lib';
import { amisModelToYaoModel } from './model_convert';
import { YaoModel } from '@yaoapps/types';

/**
 * Save the model dsl to local file
 * @param {object} modelDsl
 * @returns
 */
export function saveModelToFile(modelDsl: AmisModel) {
  // 控制是否需要保存到本地
  const saveFlag = Process('utils.env.Get', 'SAVE_MODEL_FILE_TO_LOCAL');
  if (saveFlag !== 'true') {
    return;
  }

  // hacked,don't do this in production envirement
  // __yao_data = { ROOT: true };
  let model_id = modelDsl.ID;
  if (!model_id) {
    model_id = DotName(modelDsl.table?.name);
  }
  if (!model_id) {
    console.log(`模型不完整，不保存成文件！`);
    return;
  }
  const model = amisModelToYaoModel(modelDsl);

  const dsl = new FS('system');
  model_id = SlashName(model_id);
  dsl.WriteFile(`/dev/models/${model_id}.mod.yao`, JSON.stringify(model));
  // __yao_data = { ROOT: false };

  //   saveModelToDSLFile(model_id, model);
}

// save to the dsl folder for development
export function saveModelToDSLFile(
  modelId: string,
  modelDsl: YaoModel.ModelDSL
) {
  const yaoEnv = Process('utils.env.Get', 'YAO_ENV');
  if (yaoEnv !== 'development') {
    return;
  }
  // hacked,don't do this in production envirement
  //@ts-ignore
  __yao_data = { ROOT: true };
  const dsl = new FS('dsl');

  dsl.WriteFile(`/models/${modelId}.mod.yao`, JSON.stringify(modelDsl));
  //@ts-ignore
  __yao_data = { ROOT: false };
}
/**
 * 删除本地模型定义文件
 * @param {string} modelId model id
 * @returns
 */
export function deleteModelLocalFile(modelId: string) {
  const yaoEnv = Process('utils.env.Get', 'YAO_ENV');
  if (yaoEnv !== 'development') {
    return;
  }
  const saveFlag = Process('utils.env.Get', 'SAVE_MODEL_FILE_TO_LOCAL');
  if (saveFlag !== 'true') {
    return;
  }
  // __yao_data = { ROOT: true };
  const dsl = new FS('system');
  const model_id = SlashName(modelId);
  const fname = `/dev/models/${model_id}.mod.yao`;
  if (dsl.Exists(fname)) {
    dsl.Remove(fname);
  }
  // __yao_data = { ROOT: false };
}
