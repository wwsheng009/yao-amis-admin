const { getUserAuthObjects } = Require("auth.lib")


/**
 * yao run scripts.auth.auth_test.run
 * @returns 
 */
function run() {
    return getUserAuthObjects(5)
}