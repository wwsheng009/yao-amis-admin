import { Process } from '@yao/yao';

function studio() {
  const jwtOptions = {
    timeout: 3600,
    sid: 123123,
  };
  const jwtClaims = { user_name: 'abc' };
  //   let myString = "hello world";

  const secret = Process('utils.env.Get', 'YAO_STUDIO_SECRET');
  let bytes = []; // char codes
  let bytesv2 = []; // char codes

  for (let i = 0; i < secret.length; ++i) {
    const code = secret.charCodeAt(i);
    bytes = bytes.concat([code]);
    bytesv2 = bytesv2.concat([code & 0xff, (code / 256) >>> 0]);
  }
  // console.log(bytes);
  // 无法生成studio token,因为utils.jwt.Make只接受3个参数
  const jwt = Process('utils.jwt.Make', 123, jwtClaims, jwtOptions, secret);
  // console.log(jwt);

  //    curl -X POST http://127.0.0.1:5077/service/hello \
  //    -H 'Content-Type: application/json' \
  //    -H 'Authorization: Bearer <Studio JWT>' \
  //    -d '{ "args":["yao.demo.pet"],"method":"word"}'
}
