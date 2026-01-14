export declare namespace agent {
  /**
   * A generated message id (e.g. "M1", "M2", ...).
   */
  export type MessageID = `M${number}` | string;

  /**
   * A generated block id (e.g. "B1", "B2", ...).
   */
  export type BlockID = `B${number}` | string;

  /**
   * A generated thread id (e.g. "T1", "T2", ...).
   */
  export type ThreadID = `T${number}` | string;

  /**
   * UI message payload for the assistant UI renderer.
   */
  export interface UIMessage<
    TProps extends Record<string, any> = Record<string, any>
  > {
    /** Message type, e.g. "text", "loading", "status", "result". */
    type: string;
    /** Props passed to the UI renderer. */
    props?: TProps;
    /** Extra fields depending on message type. */
    [key: string]: any;
  }

  /**
   * Payload accepted by Send/SendStream.
   * - string: shorthand for { type: "text", props: { content: string } }
   * - object: full UI message payload
   */
  export type SendInput = string | UIMessage | Record<string, any>;

  /**
   * Represents a message exchanged within the system.
   */
  export interface Message {
    /** Optional name of the message sender or identifier. */
    name?: string;
    /** Optional session ID of the message sender. */
    sid?: string;
    /** The content of the message. */
    content?: string;
    /** The role of the message sender, e.g., "user" or "agent", "system". */
    role: string;
    /** Attachments like files or URLs */
    attachments?: any[];
    /** Mentions in the message */
    mentions?: any[];
    /** Tool calls */
    tool_calls?: ToolCall[];
    /** Tool call id */
    tool_call_id?: string;
  }

  export interface ToolCall {
    id: string;
    type: 'function';
    function: {
      name: string;
      arguments: string;
    };
  }

  export interface UsageInfo {
    prompt_tokens: number;
    completion_tokens: number;
    total_tokens: number;
  }

  export interface Completion {
    id: string;
    object: string;
    created: number;
    model: string;
    choices: {
      index: number;
      message: Message;
      finish_reason: string;
    }[];
    usage: UsageInfo;
  }

  /**
   * LLM Response structure in Next hook payload
   */
  export interface CompletionResponse {
    content: string; // LLM text response
    tool_calls?: ToolCall[]; // Tool calls requested
    usage?: UsageInfo; // Token usage
  }

  /**
   * Tool execution result in Next hook payload
   */
  export interface ToolResult {
    /** Tool call ID from LLM */
    toolcall_id: string;
    server: string; // MCP server name
    tool: string; // Tool name
    arguments?: any; // Arguments passed
    result?: any; // Execution result
    error?: string; // Error if failed

    // Backward compatibility for id/name if needed
    id?: string;
    name?: string;
  }

  /**
   * Payload passed to the Next hook.
   */
  export interface NextHookPayload {
    /** User Input messages */
    messages: Message[];
    /** LLM response message */
    completion?: CompletionResponse | Message;
    /** Tool results */
    tools?: ToolResult[];
    /** Error message */
    error?: string;
  }

  export interface MCPServerConfig {
    server_id: string;
    [key: string]: any;
  }

  export interface UsesConfig {
    [key: string]: any;
  }

  export interface AudioConfig {
    voice?: string;
    format?: string;
    [key: string]: any;
  }

  /**
   * Return type for the Create hook.
   */
  export type CreateHookResponse = null | {
    // Messages to send to LLM (can modify/replace input)
    messages?: Message[];

    // Generation parameters
    temperature?: number;
    max_tokens?: number;
    max_completion_tokens?: number;

    // MCP configuration
    mcp_servers?: MCPServerConfig[];

    // Prompt configuration
    prompt_preset?: string;
    disable_global_prompts?: boolean;

    // Context overrides
    connector?: string;
    locale?: string;
    theme?: string;
    route?: string;
    metadata?: Record<string, any>;

    // Capability wrappers
    uses?: UsesConfig;
    force_uses?: boolean;

    // Audio output
    audio?: AudioConfig;

    // Legacy/Other
    search?: boolean | Record<string, any>;

    // Delegation
    delegate?: {
      agent_id: string;
      messages?: Message[];
      options?: Record<string, any>;
    };
  };

  /**
   * Return type for the Next hook.
   */
  export type NextHookResponse =
    | string
    | null
    | {
        /** Custom data to be passed to the next step */
        data?:
          | string
          | {
              [key: string]: any;
            };
        delegate?: {
          agent_id: string;
          messages?: Message[];
          options?: Record<string, any>;
        };
        // Add error message to conversation for LLM to see and retry
        messages?: Message[];
        // Metadata for logging
        metadata?: Record<string, any>;
      };

  /**
   * Key-Value Store interface for Memory.
   */
  export interface KeyValueStore {
    Set(key: string, value: any, ttl?: number): void;
    Get<T = any>(key: string): T | null;
    Del(key: string): void;
    Has(key: string): boolean;
    Incr(key: string, value?: number): number;
    Decr(key: string, value?: number): number;
    Keys(): string[];
    Len(): number;
    Clear(): void;
    GetDel<T = any>(key: string): T | null;
  }

  /**
   * Memory API with different scopes.
   */
  export interface Memory {
    user: KeyValueStore;
    team: KeyValueStore;
    chat: KeyValueStore;
    context: KeyValueStore;
  }

  /**
   * Trace Node interface.
   */
  export interface TraceNode {
    Info(message: string): void;
    SetOutput(output: Record<string, any>): void;
    Complete(): void;
    Fail(error: string): void;
  }

  /**
   * Trace API.
   */
  export interface Trace {
    Add(
      input: any,
      options: { label: string; type: string; icon?: string }
    ): TraceNode;
    Info(message: string): void;
    Error(message: string): void;
    Warn(message: string): void;
  }

  /**
   * MCP Tool interface.
   */
  export interface Tool {
    name: string;
    description?: string;
    inputSchema?: any;
  }

  /**
   * MCP API.
   */
  export interface MCP {
    ListTools(serverId: string): Tool[];
    CallTool(
      serverId: string,
      toolName: string,
      args: Record<string, any>
    ): any;
    CallToolsParallel(
      serverId: string,
      tools: { name: string; arguments: Record<string, any> }[]
    ): any[];
    ReadResource(serverId: string, uri: string): any;
  }

  export interface SearchResult {
    title?: string;
    content?: string;
    url?: string;
    score?: number;
    [key: string]: any;
  }

  /**
   * Search API.
   */
  export interface Search {
    Web(
      query: string,
      options?: { limit?: number; sites?: string[] }
    ): SearchResult[];
    KB(
      query: string,
      options?: { collections?: string[]; threshold?: number }
    ): SearchResult[];
    DB(
      query: string,
      options?: { models?: string[]; limit?: number }
    ): SearchResult[];
    All(
      queries: {
        type: 'web' | 'kb' | 'db';
        query: string;
        [key: string]: any;
      }[]
    ): SearchResult[];
  }

  export interface Client {
    type: string;
    user_agent: string;
    ip: string;
  }
  interface Authorized {
    // Identity
    user_id?: string; // User ID
    team_id?: string; // Team ID (if team login)
    tenant_id?: string; // Tenant ID (multi-tenancy)
    client_id?: string; // OAuth client ID
    session_id?: string; // Session ID

    // Data Access Constraints (set by ACL)
    constraints?: DataConstraints;
  }
  export interface DataConstraints {
    owner_only?: boolean; // Only access owner's data
    creator_only?: boolean; // Only access creator's data
    editor_only?: boolean; // Only access editor's data
    team_only?: boolean; // Only access team's data
    extra?: Record<string, any>; // Custom constraints
  }
  /**
   * Context of the assistant session
   */
  export interface Context {
    chat_id: string; // Chat session ID
    assistant_id: string; // Assistant ID
    client: Client; // Client info
    locale: string; // User locale (e.g., "en-us")
    theme: string; // UI theme
    route: string; // Request route
    referer: string; // Request source
    accept?: string; // Request accept header
    metadata: Record<string, any>; // Custom metadata
    authorized: Authorized; // Auth info
    memory: Memory; // Memory namespaces
    trace: Trace; // Tracing API
    mcp: MCP; // MCP operations
    search: Search; // Search API

    /**
     * Send a complete message to the client.
     */
    Send: (message: SendInput, blockId?: BlockID) => MessageID;

    /**
     * Send a group of messages.
     */
    SendGroup: (group: { id?: string; messages: SendInput[] }) => void;

    /**
     * Start a streaming message.
     */
    SendStream: (message: SendInput, blockId?: BlockID) => MessageID;

    /**
     * Append text to a streaming message.
     */
    Append: (messageId: MessageID, content: string) => void;

    /**
     * Replace the whole message payload of a streaming message.
     */
    Replace: (messageId: MessageID, message: SendInput) => void;

    /**
     * Merge object fields into a message at a given path.
     */
    Merge: (
      messageId: MessageID,
      patch: Record<string, any>,
      path?: string
    ) => void;

    /**
     * Set a value into a message by a dotted path.
     */
    Set: <T = any>(messageId: MessageID, value: T, path: string) => void;

    /**
     * Mark a streaming message as completed.
     */
    End: (messageId: MessageID) => void;

    /**
     * Create a new block id for grouping multiple messages.
     */
    BlockID: () => BlockID;

    /**
     * End a block group.
     */
    EndBlock: (blockId: BlockID) => void;

    /**
     * Generate a new message id.
     */
    MessageID: () => MessageID;

    /**
     * Generate a new thread id.
     */
    ThreadID: () => ThreadID;
  }
}
