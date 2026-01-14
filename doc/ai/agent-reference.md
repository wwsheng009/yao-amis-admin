# Agent Reference

A condensed reference for building Yao Agents. For detailed documentation, see the source: `yao/agent/docs/`.

## Directory Structure

```
assistants/<id>/
├── package.yao          # Configuration
├── prompts.yml          # System prompts
├── prompts/             # Prompt presets
│   ├── chat.yml
│   └── task.yml
├── locales/             # Translations
│   ├── en-us.yml
│   └── zh-cn.yml
├── src/                 # Hooks & Scripts
│   └── index.ts
├── models/              # Database models (→ agents.<id>.*)
│   └── order.mod.yao    # → agents.my-assistant.order
├── mcps/                # MCP servers (→ agents.<id>.*)
│   ├── tools.mcp.yao    # → agents.my-assistant.tools
│   └── mapping/         # Tool schemas
│       └── tools/
│           └── schemes/
│               └── search.in.yao
└── pages/               # Web UI (SUI)
    └── index/
        └── index.html
```

## package.yao

```json
{
  "name": "{{ name }}",
  "type": "assistant",
  "avatar": "/assets/avatar.png",
  "connector": "gpt-4o",
  "connector_options": {
    "optional": true,
    "connectors": ["gpt-4o", "gpt-4o-mini"],
    "filters": ["tool_calls"]
  },
  "description": "{{ description }}",
  "options": { "temperature": 0.7 },
  "public": true,
  "share": "team",
  "placeholder": {
    "title": "{{ chat.title }}",
    "prompts": ["{{ chat.prompts.0 }}"]
  },
  "tags": ["Category"],
  "modes": ["chat", "task"],
  "default_mode": "chat",
  "mentionable": true,
  "mcp": {
    "servers": [{ "server_id": "tools", "tools": ["search"] }]
  },
  "kb": { "collections": ["docs"] },
  "db": { "models": ["model.name"] },
  "uses": { "search": "disabled" },
  "search": {
    "web": { "max_results": 10 },
    "kb": { "threshold": 0.7 },
    "citation": { "format": "[{index}]" }
  }
}
```

## prompts.yml

```yaml
- role: system
  content: |
    You are a helpful assistant.
    Current date: {{ $CTX.date }}
    User locale: {{ $CTX.locale }}
```

## Hooks (src/index.ts)

```typescript
import { agent } from "@yao/runtime";

function Create(ctx: agent.Context, messages: agent.Message[]): agent.Create {
  // Store data for Next hook
  ctx.memory.context.Set("start", Date.now());

  // Return null for default behavior
  return null;

  // Or return configuration
  return {
    messages, // Modified messages
    temperature: 0.7, // Override temperature
    connector: "gpt-4o-mini", // Override connector
    prompt_preset: "task", // Select preset
    disable_global_prompts: true, // Skip global prompts
    mcp_servers: [{ server_id: "tools" }],
    uses: { search: "disabled" },
    search: false, // Disable auto search
    locale: "zh-cn",
    metadata: { key: "value" },
  };

  // Or delegate to another agent
  return {
    delegate: {
      agent_id: "specialist",
      messages: messages,
    },
  };
}

function Next(ctx: agent.Context, payload: agent.Payload): agent.Next {
  const { messages, completion, tools, error } = payload;

  if (error) {
    return { data: { status: "error", message: error } };
  }

  // Process tool results
  if (tools?.length > 0) {
    return {
      data: {
        status: "success",
        results: tools.map((t) => t.result),
      },
    };
  }

  // Delegate based on response
  if (completion?.content?.includes("transfer")) {
    return {
      delegate: { agent_id: "transfer", messages },
    };
  }

  // Return null for standard response
  return null;
}
```

## Context API

### Messaging

```typescript
// Complete message
ctx.Send({ type: "text", props: { content: "Hello!" } });
ctx.Send("Hello!");

// Streaming
const id = ctx.SendStream("Starting...");
ctx.Append(id, " processing...");
ctx.End(id);

// Update streaming
ctx.Replace(id, { type: "text", props: { content: "Done!" } });
ctx.Merge(id, { progress: 100 }, "props");
ctx.Set(id, "success", "props.status");

// Block grouping
const blockId = ctx.BlockID();
ctx.Send("Step 1", blockId);
ctx.Send("Step 2", blockId);
ctx.EndBlock(blockId);
```

### Memory

```typescript
// Scopes: user (persistent), team (persistent), chat (persistent), context (request)
ctx.memory.user.Set("pref", "value");
ctx.memory.user.Set("temp", "value", 300); // With TTL
const pref = ctx.memory.user.Get("pref");
ctx.memory.user.Del("pref");
ctx.memory.user.Has("pref");

// Counters
ctx.memory.user.Incr("views");
ctx.memory.user.Decr("credits", 5);

// Lists
ctx.memory.chat.Push("history", [msg1, msg2]);
ctx.memory.chat.Pop("queue");

// Arrays
ctx.memory.chat.ArrayGet("messages", -1);
ctx.memory.chat.ArrayPage("messages", 1, 20);
```

### Trace

```typescript
const node = ctx.trace.Add(
  { query: "input" },
  { label: "Processing", type: "process", icon: "play" }
);
node.Info("Step completed");
node.SetOutput({ result: data });
node.Complete();
// or node.Fail("error");

ctx.trace.Info("Info message");
ctx.trace.Error("Error message");
```

### MCP

```typescript
ctx.mcp.ListTools("server-id");
ctx.mcp.CallTool("server-id", "tool-name", { arg: "value" });
ctx.mcp.CallToolsParallel("server-id", [
  { name: "tool1", arguments: {} },
  { name: "tool2", arguments: {} },
]);
ctx.mcp.ReadResource("server-id", "resource://uri");
```

### Search

```typescript
// Single search
ctx.search.Web("query", { limit: 10, sites: ["example.com"] });
ctx.search.KB("query", { collections: ["docs"], threshold: 0.7 });
ctx.search.DB("query", { models: ["articles"], limit: 20 });

// Parallel
ctx.search.All([
  { type: "web", query: "topic" },
  { type: "kb", query: "topic", collections: ["docs"] },
]);
```

## Locales (locales/en-us.yml)

```yaml
name: My Assistant
description: A helpful AI assistant
chat:
  title: New Chat
  prompts:
    - How can I help?
```

## MCP Server (mcps/tools.mcp.yao)

MCP servers in `mcps/` are auto-loaded with `agents.<assistant-id>.` prefix.

```json
{
  "label": "Tools",
  "description": "Custom tools",
  "transport": "process",
  "tools": {
    "search": "agents.my-assistant.tools.Search",
    "list_orders": "models.agents.my-assistant.order.Paginate"
  }
}
```

**Tool Schema (mcps/mapping/tools/schemes/search.in.yao):**

```json
{
  "type": "object",
  "description": "Search records",
  "properties": {
    "keyword": { "type": "string" },
    "limit": { "type": "integer", "default": 10 }
  },
  "x-process-args": [":arguments"]
}
```

## Model (models/order.mod.yao)

Models in `models/` are auto-loaded with `agents.<assistant-id>.` prefix.
Tables are prefixed with `agents_<assistant-id>_`.

```json
{
  "name": "Order",
  "table": { "name": "order" },
  "columns": [
    { "name": "id", "type": "ID", "primary": true },
    { "name": "order_no", "type": "string", "length": 100, "unique": true },
    {
      "name": "status",
      "type": "enum",
      "option": ["pending", "completed"],
      "default": "pending"
    },
    { "name": "total", "type": "decimal", "precision": 10, "scale": 2 }
  ],
  "option": { "timestamps": true, "soft_deletes": true }
}
```

**Usage in Hooks/Scripts:**

```typescript
// Model ID: agents.my-assistant.order
// Table: agents_my_assistant_order
Process("models.agents.my-assistant.order.Paginate", { limit: 10 });
Process("models.agents.my-assistant.order.Find", id);
Process("models.agents.my-assistant.order.Create", {
  order_no: "001",
  total: 100,
});
```

## Pages (Web UI)

Agent Pages use SUI framework for building web interfaces.

**Directory Structure:**

```
agent/template/              # Global template
├── __document.html          # Document template
├── __data.json              # Global data
└── __assets/                # Global assets

assistants/<id>/pages/       # Assistant pages
├── index/
│   ├── index.html           # Page template
│   ├── index.css            # Styles
│   ├── index.ts             # Frontend script
│   └── index.backend.ts     # Backend script
```

**Routes:** `/agents/<assistant-id>/<page-name>`

**Build:** `yao sui build agent` / `yao sui watch agent`

**Open page from hook:**

```typescript
ctx.Send({
  type: "action",
  props: {
    name: "navigate",
    payload: {
      route: "/agents/my-assistant/result",
      title: "Results",
      query: { id: "123" },
    },
  },
});
```

## Frontend Script

**Direct style (simple pages):**

```typescript
document.addEventListener("DOMContentLoaded", () => {
  const form = document.querySelector("#myForm") as HTMLFormElement;
  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    // Handle submission
  });
});
```

**Component style (interactive pages):**

```typescript
import { $Backend, Component, EventData } from "@yao/sui";

const self = this as Component;

self.HandleClick = async (event: Event, data: EventData) => {
  const result = await $Backend().Call("Method", data.id);
};
```

## Iframe Communication

Pages embedded in CUI (`/web/<assistant-id>/<page>`) can communicate with host:

```typescript
// Helper: Send action to CUI parent
const sendAction = (name: string, payload?: any) => {
  window.parent.postMessage(
    { type: "action", message: { name, payload } },
    window.location.origin
  );
};

// Usage
sendAction("notify.success", { message: "Done!" });
sendAction("navigate", {
  route: "/agents/my-assistant/detail",
  title: "Details",
});

// Receive messages from CUI
window.addEventListener("message", (e) => {
  if (e.origin !== window.location.origin) return;
  if (e.data.type === "setup") {
    const { theme, locale } = e.data.message;
  }
});
```

**Actions:** `navigate`, `navigate.back`, `notify.success/error/warning/info`, `app.menu.reload`, `modal.open/close`, `table.search/refresh/save/delete`, `form.find/submit/reset`, `mcp.tool.call`, `event.emit`, `confirm`

## Testing

```bash
# Test with direct message
yao agent test -i "Hello" -n assistants.my-assistant

# Test with JSONL file
yao agent test -i tests/inputs.jsonl

# Dynamic mode with simulator
yao agent test -i tests/dynamic.jsonl --simulator tests.simulator-agent -v

# Script testing
yao agent test -i scripts.my-assistant.setup -v
```

### JSONL Test Case

```jsonl
{"id": "T001", "input": "Hello", "assert": {"type": "contains", "value": "Hi"}}
{"id": "T002", "input": "Query", "assert": {"type": "agent", "use": "agents:tests.validator", "value": "Response should be helpful"}}
```

### Script Testing

```typescript
// src/setup_test.ts
export function TestSetup(t: TestingT, ctx: Context) {
  const result = Setup(ctx);
  t.assert.True(result.success, "Should succeed");
  t.assert.Equal(result.status, "ready");
  t.assert.Agent(result.message, "tests.validator", {
    criteria: "Clear confirmation",
  });
}
```

## API Endpoints

OpenAPI endpoints (base URL: `/v1`):

| Endpoint                               | Method | Description         |
| -------------------------------------- | ------ | ------------------- |
| `/v1/chat/completions`                 | POST   | Chat with assistant |
| `/v1/chat/sessions`                    | GET    | List chat sessions  |
| `/v1/chat/sessions/:chat_id/messages`  | GET    | Get messages        |
| `/v1/agent/assistants`                 | GET    | List assistants     |
| `/v1/file/:uploaderID`                 | POST   | Upload files        |
| `/v1/file/:uploaderID/:fileID/content` | GET    | Download file       |
