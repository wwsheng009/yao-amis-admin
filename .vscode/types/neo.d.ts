import { io } from './io.d.ts';
/**
 * Namespace containing types and interfaces for the Neo system.
 */
export declare namespace neo {
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
  }

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
  export interface ResponseWriter extends HttpResponseWriter, Hijacker {
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
  /**
   * Represents the context of an operation or request.
   */
  export interface Context {
    /** Session ID, optional. */
    sid: string; // Session ID
    chat_id?: string; // Chat ID, use to select chat
    assistant_id?: string; // Assistant ID, use to select assistant
    /** Stack trace or operation stack. */
    stack?: string;
    /** The current path of the operation. */
    path?: string;
    /** Form data associated with the context. */
    formdata?: Payload; // Map of string to any type
    /** The current field being processed. */
    field?: Field;
    /** The namespace where the operation is executed. */
    namespace?: string;
    /** Configuration settings for the context. */
    config?: Payload; // Map of string to any type
    /** Signal data for triggering or handling events. */
    signal?: any; // Can be any type
    /** update data. */
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

  export interface ChatMessage {
    type?: string;
    id?: string;
    text?: string;
    props?: { [key: string]: any };
  }
  export interface Message {
    /** The content of the message. */
    text?: string; // text content
    type?: string; // error, text, plan, table, form, page, file, video, audio, image, markdown, json ...
    props?: Payload; // props for the types
    done?: boolean;
    actions?: Action[]; // Conversation Actions for frontend
    attachments?: Attachment[]; // File attachments
    role?: string; // user, assistant, system ...
    /** Optional name of the message sender or identifier. */
    name?: string; // name for the message
  }

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

  export interface ResHookInit {
    assistant_id?: string;
    chat_id?: string;
    next?: NextAction;
    input?: Message[];
    options?: Payload;
  }
  export interface ResHookStream {
    silent?: boolean; // Whether to suppress the output
    next?: NextAction; // The next action
    output?: string; // The output
  }

  export interface NextAction {
    action: string; // The action to be performed
    payload?: Payload; // Optional payload for the action
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

  type FCAttributes = {
    name: string; // json:"name"
    arguments: string; // json:"arguments"
  };

  type FunctionCall = {
    index: number; // json:"index"
    id: string; // json:"id"
    type: string; // json:"type"
    function: FCAttributes; // json:"function"
  };

  type Mention = {
    assistant_id: string; // json:"assistant_id"
    name: string; // json:"name"
    avatar?: string; // json:"avatar,omitempty"
  };

  export type AiMessage = {
    text?: string; // json:"text,omitempty"
    type?: string; // json:"type,omitempty"
    props?: { [key: string]: any }; // json:"props,omitempty"
    done?: boolean; // json:"done,omitempty"
    new?: boolean; // json:"new,omitempty"
    actions?: Action[]; // json:"actions,omitempty"
    attachments?: Attachment[]; // json:"attachments,omitempty"
    role?: string; // json:"role,omitempty"
    name?: string; // json:"name,omitempty"
    assistant_id?: string; // json:"assistant_id,omitempty"
    assistant_name?: string; // json:"assistant_name,omitempty"
    assistant_avatar?: string; // json:"assistant_avatar,omitempty"
    menions?: Mention[]; // json:"menions,omitempty"
    data?: { [key: string]: any }; // json:"-"`
    tool_call_id?: string; // json:"tool_call_id,omitempty"
    tool_calls?: FunctionCall[]; // json:"tool_calls,omitempty"
  };

  export declare function Send(str: string, saveHistory: boolean);
}
