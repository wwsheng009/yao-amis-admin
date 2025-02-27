import { ModelProxy } from '@lib/proxy';
import { getWebPageContent } from '@lib/web';
import { getWeatherByName } from '@scripts/app/weather/tool';
import { IAdminUser } from '@scripts/db_types/admin/user';
import { neo } from '@yao/neo';

declare function Send(message: string | object): void;
/**
 * user request -> [Create hook] -> openai
 *
 * called before the chat with openai.
 *
 * @param context The context object containing session information and other relevant data.
 * @param input The input message array.
 * @param option A payload object containing additional options or data.
 * @returns A response object containing the next action, input messages, and output data.
 */
export function Create(
  input: neo.Message[],
  option: { [key: string]: any }
): neo.ResHookInit {
  //case 1 return null
  //return null

  //case 2 returns a string,change the assistant_id
  //return "assignment_id"
  //check if the last message in input attachment with type URL

  // Get the last message in the input array
  const lastMessage = input[input.length - 1];
  input.pop();
  // Check if the last message has attachments
  if (lastMessage.attachments && lastMessage.attachments.length > 0) {
    // Check if any attachment has the type 'URL'
    lastMessage.attachments.forEach((attachment) => {
      if (attachment.type === 'URL' && attachment.url) {
        // console.log('attachment');
        // console.log(attachment);
        try {
          Send('读取网页' + attachment.url);

          const content = getWebPageContent(attachment.url);
          Send('读取网页完成' + attachment.url);

          Send(content);
        } catch (error) {
          console.log(error.message);
        }
      }
    });
  }
  // get the assistant_id from the message text where it looks  "@xxxxx"
  const mentenion_assistant_id = lastMessage.text?.match(/@(\w+)/)?.[1];
  let new_assistant_id = context.assistant_id;

  if (
    mentenion_assistant_id &&
    mentenion_assistant_id !== context.assistant_id
  ) {
    new_assistant_id = mentenion_assistant_id;
  }

  input.push(lastMessage);
  // console.log('new_assistant_id');
  // console.log(new_assistant_id);

  //case 3 returns an object
  return {
    assistant_id: new_assistant_id, //optional,change the assistant_id,switch the assistant for following process
    chat_id: context.chat_id, //optional
    // next: {
    //   //optional, if you want to call another action in frontend
    //   action: 'assistant', //call other assistant set to 'exit' to exit process
    //   payload: {
    //     assistant_id: new_assistant_id,
    //     input: input,
    //     options: {
    //       max_tokens: 8192
    //     }
    //   }
    // },
    input: input //optional,overwrite the input messages
    // options: {
    //   max_tokens: 8192
    //   //optional, if you want to change the options for openai api call
    // }
  };
}

/**
 * called only once, when the call openai api done,open ai return messages
 *
 * @param context context info
 * @param input input messages
 * @param output messages
 * @param writer for response
 * @returns
 */
function Done(
  input: neo.ChatMessage[],
  output: neo.ChatMessage[]
): any | null | string {
  console.log('output');
  console.log(output);
  if (
    output.length > 0 &&
    output[output.length - 1].props != null &&
    output[output.length - 1].props['function'] !== ''
  ) {
    const lastLine = output[output.length - 1];
    const funcName = lastLine.props['function'];

    if (funcName == 'get_weather') {
      const data = getWeatherByName(lastLine.props['arguments']['location']);
      // const data = Process(
      //   'scripts.app.weather.init.getWeatherByName',
      //   fcall.function.arguments['location']
      // );
      console.log('get_weather:');
      console.log(data);
      return {
        output: [{ text: data }] as neo.ChatMessage[]
      };

      // return '{"temperature": "15°C"}';
    } else if (funcName == 'find_user') {
      console.log('find_user:');
      console.log(lastLine.props['arguments']);
      const [user] = new ModelProxy<IAdminUser>('admin.user').Get({
        wheres: [
          {
            column: 'name',
            op: 'like',
            value: `%${lastLine.props['arguments']['username']}%`
          }
        ]
      });
      if (user) {
        console.log(user);
        return {
          output: [{ text: user }] as neo.ChatMessage[]
        };
      } else {
        console.log('用户不存在');
        return {
          output: [{ text: '用户不存在' }] as neo.ChatMessage[]
        };
      }
    }

    return {
      ouput: [
        { text: '错误的调用，不支持的函数调用：' + funcName }
      ] as neo.ChatMessage[]
    };
  }

  // case 1 return null,no change
  // return null
  return null;
  // case 2 return object
  return {
    next: {
      action: 'action1', //set to 'exit' to exit stream,only set it when you want to exit the process
      payload: {}
    }
    // output: output //change the output message
  };
}

/**
 * called every time when the call openai api failed,open ai return error messages
 *
 * @param input input messages
 * @param error error messages
 * @returns {next,input,output}
 */
function Fail(input: neo.Message[], error: string): neo.ResHookFail | null {
  // case 1 return null,no change
  // return null
  return null;
  // case 2 return object
  return {
    // output: output,
    // most important, return error message
    // error: 'error message'
  };
}
