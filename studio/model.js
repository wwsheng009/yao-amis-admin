const { SlashName, FileNameConvert } = Require("amis.lib_tool");
/**
 * yao studio run model.GenerateModelFile
 * @param modelid model id
 */
function GenerateModelFile(modelid) {
  const model = Process("models.ddic.model.Find", modelid, {
    withs: {
      columns: { withs: { element: {} } },
    },
  });

  const m = Process("scripts.system.model.ConvertTableLineToModel", model);
  m.columns.forEach((col) => {
    delete col.id;
    delete col.model_id;
    delete col.element_id;
  });
  delete m.id;
  return SaveModelToFile(m);
}

function SaveModelToFile(model) {
  let modelName = SlashName(model.name);
  const filename = `/models/${modelName}.mod.json`;

  const fs = new FS("dsl");
  const nfilename = FileNameConvert(filename);
  if (!fs.Exists(nfilename)) {
    const folder = nfilename.split("/").slice(0, -1).join("/");
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
