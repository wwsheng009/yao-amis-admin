/**
 * Represents the response structure of an operation or request.
 */
export interface Response {
  /** Optional text content of the response. */
  text?: string;
  /** Error message, if any occurred. */
  error?: string;
  /** Indicates whether the operation is completed. */
  done?: boolean;
  /** Indicates whether the response requires confirmation. */
  confirm?: boolean;
  /** Optional command to execute. */
  command?: Command | null;
  /** List of actions to be performed. */
  actions?: Action[];
  /** Additional data returned with the response. */
  data?: Record<string, any>;
}

/**
 * Represents a command to be executed within the system.
 */
export interface Command {
  /** Optional unique identifier for the command. */
  id?: string;
  /** Name of the command. */
  name?: string;
  /** Optional request data for the command. */
  request?: string;
}

/**
 * Represents an action to be performed within the system.
 */
export interface Action {
  /** Name of the action. */
  name?: string;
  /** Type of the action, e.g., "update" or "notify". */
  type: string;
  /** Optional payload data for the action. */
  payload?: any;
  /** Optional identifier for the next action. */
  next?: string;
}

/**
 * Represents a field in a form or data structure.
 */
export interface Field {
  /** The binding key for the field. */
  bind: string;
  /** The value associated with the field. */
  value: any;
  name?: string;
  type?: string;
  props?: Payload;
  children?: any[];
}

export interface Header {
  [key: string]: string[];
}

export interface Payload {
  [key: string]: any;
}

export interface HttpResponseWriter {
  header(): Header;
  write(data: Uint8Array): number | Promise<number>;
  writeHeader(statusCode: number): void;
}

export interface Hijacker {
  Hijack(): [any, any, Error];
}

export interface ResponseWriter extends HttpResponseWriter, Hijacker {
  status(): number;
  size(): number;
  writeString(s: string): number;
  written(): boolean;
  writeHeaderNow(): void;
  pusher(): any;
  Flush(): void;
}

/**
 * Represents the context of an operation or request.
 */
export interface Context {
  /** Session ID, optional. */
  sid: string;
  chat_id?: string;
  assistant_id?: string;
  stack?: string;
  path?: string;
  formdata?: Payload;
  field?: Field;
  namespace?: string;
  config?: Payload;
  signal?: any;
  upload?: FileUpload;
}

export interface FileUpload {
  name?: string;
  type?: string;
  size?: number;
  temp_file?: string;
}

export interface ChatMessage {
  type?: string;
  id?: string;
  text?: string;
  props?: { [key: string]: any };
}

export interface Message {
  text?: string;
  type?: string;
  props?: Payload;
  done?: boolean;
  actions?: Action[];
  attachments?: Attachment[];
  role?: string;
  name?: string;
}

export interface Attachment {
  name?: string;
  url?: string;
  type?: string;
  content_type?: string;
  bytes?: number;
  created_at?: number;
  file_id?: string;
  chat_id?: string;
  assistant_id?: string;
}

export interface ResHookInit {
  assistant_id?: string;
  chat_id?: string;
  next?: NextAction;
  input?: Message[];
  options?: Payload;
}

export interface ResHookStream {
  silent?: boolean;
  next?: NextAction;
  output?: string;
}

export interface NextAction {
  action: string;
  payload?: Payload;
}

export interface ResHookDone {
  next?: NextAction;
  input?: Message[];
  output?: string;
}

export interface ResHookFail {
  next?: NextAction;
  input?: Message[];
  output?: string;
  error?: string;
}

export interface FCAttributes {
  name: string;
  arguments: string;
}

export interface FunctionCall {
  index: number;
  id: string;
  type: string;
  function: FCAttributes;
}

export interface Mention {
  assistant_id: string;
  name: string;
  avatar?: string;
}

export interface AiMessage {
  text?: string;
  type?: string;
  props?: { [key: string]: any };
  done?: boolean;
  new?: boolean;
  actions?: Action[];
  attachments?: Attachment[];
  role?: string;
  name?: string;
  assistant_id?: string;
  assistant_name?: string;
  assistant_avatar?: string;
  menions?: Mention[];
  data?: { [key: string]: any };
  tool_call_id?: string;
  tool_calls?: FunctionCall[];
}

/**
 * Sends a message with an option to save history.
 */
export declare function Send(str: string, saveHistory: boolean): void;
