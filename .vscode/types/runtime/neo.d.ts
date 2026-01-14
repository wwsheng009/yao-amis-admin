import { io } from "runtime/io";
/**
 * Namespace containing types and interfaces for the Neo system.
 */
export declare namespace neo {
  /**
   * Represents the context of an operation or request.
   */
  export interface Context {
    /** Session ID, optional. */
    sid?: string;
    /** The current path of the operation. */
    path: string;
    /** Stack trace or operation stack. */
    stack: string;
    /** The namespace where the operation is executed. */
    namespace: string;
    /** Form data associated with the context. */
    formdata: Record<string, any>;
    /** Configuration settings for the context. */
    config: Record<string, any>;
    /** The current field being processed. */
    field: Field;
    /** Signal data for triggering or handling events. */
    signal: any;
  }

  /**
   * Represents a message exchanged within the system.
   */
  export interface Message {
    /** Optional name of the message sender or identifier. */
    name?: string;
    /** Optional session ID of the message sender. */
    sid?: string;
    /** The content of the message. */
    content: string;
    /** The role of the message sender, e.g., "user" or "agent". */
    role: string;
  }

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

  export interface Assistant {}

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

  /**
   * Interface for an agent that processes messages and responses.
   */
  export interface IAgent {
    /**
     * Prepares the messages before further processing.
     * @param context - The current context of the operation.
     * @param messages - The list of messages to prepare.
     * @returns The modified list of messages.
     */
    Prepare: (context: Context, messages: Message[]) => Message[];

    /**
     * Writes responses based on the given context and messages.
     * @param context - The current context of the operation.
     * @param messages - The list of messages to process.
     * @param response - The initial response structure.
     * @param content - Optional additional content to include.
     * @param writer - Optional response writer for output.
     * @returns The final list of responses.
     */
    Write: (
      context: Context,
      messages: Message[],
      response: Response,
      content?: string,
      writer?: io.ResponseWriter
    ) => Response[];
  }
}
