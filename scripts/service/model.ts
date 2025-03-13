/**
 * 实用函数，调用amis-admin的远程服务，生成模型的类型定义
 */

import { FindCachedModelById } from '@scripts/service/data';
import { FS, http, Process } from '@yaoapps/client';
import { YaoModel } from '@yaoapps/types';

/**
 * Yao缓存中的模型定义
 */
export interface CachedModel extends YaoModel.ModelDSL {
  ID?: string;
  DSL?: string;
}

export interface CachedModelTree {
  children?: { data?: CachedModel }[];
  data?: CachedModel;
}

export function getCachedModelIDList(): string[] {
  return Process('model.list').map((m) => m.id);
}
/**
 * use the yao-amis-admin service to generate the code
 *
 * 发起YAO-AMIS-ADMIN远程调用的函数
 *
 * @param {string} remoteMethod - 要调用的远程服务的处理器
 * @param {Object} args - 要发送到远程服务的数据
 */
function remoteCall(remoteMethod: string, ...args: any[]) {
  const amisAdminHost = Process('yao.env.get', 'YAO_AMIS_ADMIN_HOST');
  if (!amisAdminHost) {
    throw new Error('YAO_AMIS_ADMIN_HOST Not set');
  }

  const amisAdminKey = Process('yao.env.get', 'YAO_AMIS_ADMIN_ACCESS_KEY');
  if (!amisAdminKey) {
    throw new Error('YAO_AMIS_ADMIN_ACCESS_KEY Not set');
  }
  const response = http.Post(
    `${amisAdminHost}/api/proxy/call`,
    {
      type: 'Process',
      method: remoteMethod,
      args: [...args]
    },
    null,
    null,
    { Authorization: `Bearer ${amisAdminKey}` }
  );
  if (response.status != 200 || response.data.code != 200) {
    throw new Error(response.message);
  }
  return response.data.data;
}

export function toCamelCaseNameSpace(str: string) {
  if (!str || typeof str.replace !== 'function') {
    return str;
  }
  const newStr = str.replace(/[._]([a-z])/g, function (match, letter) {
    return letter.toUpperCase();
  });
  return newStr.charAt(0).toUpperCase() + newStr.slice(1);
}

/**
 * 生成模型服务代码
 *
 * yao run scripts.service.model.generateModelCode admin.user
 * @param modelId 模型ID
 */
export function generateModelCode(modelId: string, overwrite: boolean = true) {
  const modelDsl = FindCachedModelById(modelId);

  const code = remoteCall(
    'scripts.system.tscode.getModelServiceTemplate',
    modelId,
    modelDsl
  );

  const serviceName = modelId.replace(/\./g, '/');

  const fname = `/scripts/db_services/${serviceName}.ts`;
  const fs = new FS('app');
  if (overwrite || !fs.Exists(fname)) {
    fs.WriteFile(fname, code);
    console.log(`create file: ${fname}`);
  } else {
    console.log(`file ${fname} already exists`);
  }
}

/**
 * 生成模型类型代码
 *
 * yao run scripts.service.model.generateModelTypeCode admin.user
 * @param modelId
 */
export function generateModelTypeCode(
  modelId: string,
  overwrite: boolean = true
) {
  const modelDsl = FindCachedModelById(modelId);

  const code = remoteCall(
    'scripts.template.tstype.createTSTypes',
    modelId,
    modelDsl,
    'I'
  );

  const typeName = modelId.replace(/\./g, '/');

  // const typeName = toCamelCaseNameSpace(modelId);
  const fname = `/scripts/db_types/${typeName}.ts`;
  const fs = new FS('app');
  if (overwrite || !fs.Exists(fname)) {
    fs.WriteFile(fname, code);
    console.log(`create file: ${fname}`);
  } else {
    console.log(`file ${fname} already exists`);
  }
}

/**
 * 生成所有模型服务代码
 */
export function generateAllModelService() {
  getCachedModelIDList().map((modelId) => {
    generateModelCode(modelId);
  });
}

/**
 * 生成所有模型类型代码
 */
export function generateAllModelType() {
  getCachedModelIDList().map((modelId) => {
    generateModelTypeCode(modelId);
  });
}
