const { getModelFields } = Require("amis.lib");

/**
 * generate xgen table views
 * @param {string} modelId
 * @param {Array} columns
 */
function generateTableView(modelId, columns) {
  const fields = getModelFields(modelId, columns);

  return {
    name: modelId,
    action: { bind: { model: modelId } },
  };
}

/**
 * generate xgen form views
 * @param {string} modelId
 * @param {Array} columns
 */
function generateFormView(modelId, columns) {
  const fields = getModelFields(modelId, columns);

  return {
    name: modelId,
    action: { bind: { model: modelId } },
  };
}
