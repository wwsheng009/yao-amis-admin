// scripts.return.RSuccess
function RSuccess(data, message) {
  let vmessage = message;
  if (!vmessage) {
    vmessage = '处理成功';
  }
  return {
    status: 0,
    msg: vmessage,
    data: data
  };
}
// 显示成功消息
// scripts.return.RSuccessMessage
function SuccessMessage(message) {
  let vmessage = message;
  if (!vmessage) {
    vmessage = '处理成功';
  }
  return {
    status: 0,
    msg: vmessage,
    data: {}
  };
}
// scripts.return.RError "密码不正确","403","密码不正确"
function RError(data, code, message) {
  let vcode = code;
  let vmessage = message;
  if (code == undefined) {
    vcode = -1;
  }
  if (message == undefined) {
    vmessage = 'error';
  }
  return {
    status: vcode,
    msg: vmessage,
    data: data
  };
}

// scripts.return.ErrorMessage "403","密码不正确"
function ErrorMessage(code, message) {
  let vcode = code;
  let vmessage = message;
  if (code == undefined) {
    vcode = -1;
  }
  if (message == undefined) {
    vmessage = 'error';
  }
  return {
    status: vcode,
    msg: vmessage,
    data: {}
  };
}
