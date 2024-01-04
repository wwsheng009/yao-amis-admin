/**
 * scripts.ddic.compute.json.View
 * @param {*} data
 * @returns
 */
function View(data) {
    if (isObject(data)) {
        return JSON.stringify(data);
    }
    return data;
}
/**
 * scripts.ddic.compute.json.Edit
 * @param {any} data
 * @returns
 */
function Edit(data) {
    if (isJsonString(data)) {
        return JSON.parse(data);
    }
    return data;
}
function isObject(value) {
    return value && typeof value === "object"; // && value.constructor === Object;
}
function isJsonString(obj) {
    try {
        JSON.parse(obj);
    }
    catch (e) {
        return false;
    }
    return true;
}
