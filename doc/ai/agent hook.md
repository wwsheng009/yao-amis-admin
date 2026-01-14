# agent hook reference




## Next函数

- 当Next函数返回null时,不干预ai处理流程,ai会继续处理下一个step,一般会使用llm返回的completion作为结果。

- 当Next函数返回Delegate时,会干预ai处理流程,ai会使用Delegate作为输入,继续调用另外一个agent.

- 当Next函数返回自定义数据时，会优先使用自定义数据作为结果,而不是completion.这一特性可以在Next函数中根据业务逻辑,返回不同的结果.比如在Next函数中进行其它的api调用，数据库搜索等操作。
    * 可以直接返回string
    * 可以返回object
    * 常用的返回`{data: {...}}`

```js
//返回data,会干预ai处理流程,ai会使用data作为输入,继续处理下一个step.
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


### Memory Examples

```javascript
// Pass data between Create and Next hooks
function Create(ctx, messages) {
  ctx.memory.context.Set("original_query", messages[0]?.content);
  ctx.memory.context.Set("request_time", Date.now());
  return { messages };
}

function Next(ctx, payload) {
  const query = ctx.memory.context.Get("original_query");
  const duration = Date.now() - ctx.memory.context.Get("request_time");
  console.log(`Query: ${query}, Duration: ${duration}ms`);
}