interface Header {
  [key: string]: string[];
}
interface Payload {
  [key: string]: any;
}
interface HttpResponseWriter {
  header(): Header;
  write(data: Uint8Array): number | Promise<number>;
  writeHeader(statusCode: number): void;
}
interface Hijacker {
  Hijack(): [any, any, Error];
}
interface ResponseWriter extends HttpResponseWriter, Hijacker {
  // Status returns the HTTP response status code of the current request.
  status(): number;

  // Size returns the number of bytes already written into the response http body.
  // See written()
  size(): number;

  // WriteString writes the string into the response body.
  writeString(s: string): number;

  // Written returns true if the response body was already written.
  written(): boolean;

  // WriteHeaderNow forces to write the http header (status code + headers).
  writeHeaderNow(): void;

  // Pusher get the http.Pusher for server push
  pusher(): any;

  Flush();
}

interface Context {
  context: any; // Assuming this is a placeholder for the Go context.Context
  sid: string; // Session ID
  chat_id?: string; // Chat ID, use to select chat
  assistant_id?: string; // Assistant ID, use to select assistant
  stack?: string;
  path?: string;
  formdata?: Payload; // Map of string to any type
  field?: Field;
  namespace?: string;
  config?: Payload; // Map of string to any type
  signal?: any; // Can be any type
  upload?: FileUpload;
}

interface Field {
  name?: string;
  type?: string;
  bind?: string;
  props?: Payload; // Map of string to any type
  children?: any[]; // Array of any type
}

interface FileUpload {
  name?: string;
  type?: string;
  size?: number;
  temp_file?: string;
}

type Message = {
  text?: string; // text content
  type?: string; // error, text, plan, table, form, page, file, video, audio, image, markdown, json ...
  props?: Payload; // props for the types
  done?: boolean;
  actions?: Action[]; // Conversation Actions for frontend
  attachments?: Attachment[]; // File attachments
  role?: string; // user, assistant, system ...
  name?: string; // name for the message
};

type Attachment = {
  name?: string; // name of the attachment
  url?: string; // URL of the attachment
  type?: string; // type of the attachment
  content_type?: string; // MIME type of the attachment
  bytes?: number; // size of the attachment in bytes
  created_at?: number; // timestamp when the attachment was created
  file_id?: string; // unique identifier for the file
  chat_id?: string; // unique identifier for the chat
  assistant_id?: string; // unique identifier for the assistant
};
type Action = {
  name?: string; // name of the action
  type: string; // type of the action (required, as it doesn't have `omitempty` in Go)
  payload?: any; // payload for the action
};

interface ResHookInit {
  assistant_id?: string;
  chat_id?: string;
  next?: NextAction;
  input?: Message[];
  options?: Payload;
}
interface ResHookStream {
  silent?: boolean; // Whether to suppress the output
  next?: NextAction; // The next action
  output?: string; // The output
}

interface NextAction {
  action: string; // The action to be performed
  payload?: Payload; // Optional payload for the action
}

interface ResHookDone {
  next?: NextAction;
  input?: Message[];
  output?: string;
}

interface ResHookFail {
  next?: NextAction;
  input?: Message[];
  output?: string;
  error?: string;
}

/**
 * user request -> [init hook] -> stream call -> openai
 *
 * called before the chat with openai.
 *
 * @param context The context object containing session information and other relevant data.
 * @param input The input message array.
 * @param option A payload object containing additional options or data.
 * @returns A response object containing the next action, input messages, and output data.
 */
export function Init(
  context: Context,
  input: Message[],
  option: Payload
): ResHookInit {
  // input: [
  //     {
  //       text: "Hello, I'm a bot.", //text content
  //       type: 'text', //error, text, plan, table, form, page, file, video, audio, image, markdown, json ...
  //       role: 'system', //user, assistant, system ...
  //       name: 'system', //name for the message
  //       props: {
  //         // props for the types
  //         type: 'text',
  //         payload: {
  //           type: 'text'
  //         }
  //       },
  //       done: true,
  //       actions: [
  //         // Conversation Actions for frontend
  //         {
  //           type: 'button',
  //           name: 'button1',
  //           payload: {}
  //         }
  //       ],
  //       attachments: [
  //         //File attachments
  //         {
  //           name: 'file1',
  //           url: 'https:',
  //           type: 'file',
  //           content_type: 'image/png',
  //           bytes: 123,
  //           created_at: new Date().getTime(),
  //           file_id: '',
  //           chat_id: context.chat_id,
  //           assistant_id: context.assistant_id
  //         }
  //       ]
  //     }
  //   ],

  //case 1 return null
  //return null

  //case 2 returns a string,change the assistant_id
  //return "assignment_id"

  //case 3 returns an object
  return {
    assistant_id: context.assistant_id, //optional,change the assistant_id,switch the assistant for following process
    chat_id: context.chat_id, //optional
    next: {
      //optional, if you want to call another action in frontend
      action: 'action1', //set to 'exit' to exit process
      payload: {}
    }
    // // input: [], //optional,overwrite the input messages
    // options: {
    //   max_tokens: 8192
    //   //optional, if you want to change the options for openai api call
    // }
  };
}

/**
 * called every time when the call openai api stream happen
 *
 * @param context context info
 * @param input input messages
 * @param output output messages
 * @param writer writer for response
 * @returns {next,output}
 */
function Stream(
  context: Context,
  input: Message[],
  output: string,
  writer: ResponseWriter
): ResHookStream | null {
  // case 1 return null,no change
  // return null
  return null;
  // case 2 return object
  return {
    silent: false, // set true to continue the stream without output
    next: {
      action: 'action1', //set to 'exit' to exit stream
      payload: {}
    }
    // output: output //change the output message
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
  context: Context,
  input: Message[],
  output: string,
  writer: ResponseWriter
): ResHookDone | null {
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
 * @param context context info
 * @param input input messages
 * @param output output messages
 * @param writer writer for response
 * @returns {next,input,output}
 */
function Fail(
  context: Context,
  input: Message[],
  output: string,
  writer: ResponseWriter
): ResHookFail | null {
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
