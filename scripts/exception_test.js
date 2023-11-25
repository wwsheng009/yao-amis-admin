
function excption() {
    throw new Exception("用户不存在", 430)
}
//yao run scripts.exception.testVerify
function testVerify() {

    try {
        excption()
    } catch (error) {
        // error.code  430
        // error.message 用户不存在
        // error.name Exception | 430
        console.log(error.code, error.message, error.name)
    }

    try {
        // 通过处理器调用的exception被转换，没有err.code
        // 这里是无法捕捉到Exception类型的错误，因为已经被go转换过了，会变成成标准的Error,
        // throw new Exception 只能直接使用，不能在处理器之外使用。
        // 或者是required的方法，避免转换
        Process("scripts.exception.excption")
    } catch (error) {
        // error.code undefined,
        // error.message 用户不存在
        // error.name Error
        console.log(error.code, error.message, error.name)
    }
}