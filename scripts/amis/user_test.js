
//yao run scripts.amis.user_test.testVerify
function testVerify() {

    try {
        Process("scripts.amis.user.userVerify", 'a', 123)
    } catch (error) {
        console.log(error.code, error.message, error.name)
    }
}