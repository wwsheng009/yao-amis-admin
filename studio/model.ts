import { AmisModel, ModelId } from '@yao/types';
import { FS } from '@yao/yao';

import { SlashName, FileNameConvert } from '@scripts/system/lib';
import { exportAmisModelToYao } from '@scripts/system/model';
/**
 * yao studio run model.GenerateModelFile
 * @param modelid model id
 */
export function GenerateModelFile(modelid: ModelId) {
  const m = exportAmisModelToYao(modelid);
  return saveModelToFile(m.source);
}

export function saveModelToFile(model: AmisModel) {
  const modelName = SlashName(model.name);
  const filename = `/models/${modelName}.mod.json`;

  const fs = new FS('dsl');
  const nfilename = FileNameConvert(filename);
  if (!fs.Exists(nfilename)) {
    const folder = nfilename.split('/').slice(0, -1).join('/');
    if (!fs.Exists(folder)) {
      fs.MkdirAll(folder);
    }
  }
  const res = fs.WriteFile(filename, JSON.stringify(model));
  if (res && res.code && res.message) {
    console.log(`创建模型文件失败【${res.code},${res.message}】：${filename}`);
  } else {
    console.log(`创建模型文件成功：${filename}`);
  }
}
