//自定义组件
let React = amisRequire("react");

// 自定义组件，props 中可以拿到配置中的所有参数，比如 props.label 是 'Name'
function CustomComponent(props) {
  let dom = React.useRef(null);
  React.useEffect(function () {
    // 从这里开始写自定义代码，dom.current 就是新创建的 dom 节点
    // 可以基于这个 dom 节点对接任意 JavaScript 框架，比如 jQuery/Vue 等
    dom.current.innerHTML = "custom";
    // 而 props 中能拿到这个
  });
  return React.createElement("div", {
    ref: dom,
  });
}
// 自定义组件，props 中可以拿到配置中的所有参数，比如 props.label 是 'Name'
// props.env 可以拿到env配置中的配置。
function CustomVueComponent(props) {
  let dom = React.useRef(null);
  React.useEffect(function () {
    // 从这里开始写自定义代码，dom.current 就是新创建的 dom 节点
    // 可以基于这个 dom 节点对接任意 JavaScript 框架，比如 jQuery/Vue 等

    const html = `
    <div>
    <h1>{{message}}</h1>
    <button @click=buttonClick>Click Me</button>
    </div>
    `;
    dom.current.innerHTML = html;

    const { createApp, ref } = Vue;

    const app = createApp({
      setup() {
        const message = ref("Hello vue!");

        function buttonClick(event) {
          debugger;
          props.onAction(
            event,
            {
              type: "action",
              label: "弹个框",
              actionType: "dialog",
              dialog: {
                title: "弹框",
                body: "Hello World!",
              },
            },
            {} // 这是 data
          );
          event.preventDefault();
        }
        return {
          message,
          buttonClick,
        };
      },
    });

    app.mount(dom.current);
  });
  return React.createElement("div", {
    ref: dom,
  });
}

// 自定义组件，props 中可以拿到配置中的所有参数，比如 props.label 是 'Name'
// props.env 可以拿到env配置中的配置。
function CustomSSEComponent(props) {
  let dom = React.useRef(null);
  React.useEffect(function () {
    // 从这里开始写自定义代码，dom.current 就是新创建的 dom 节点
    // 可以基于这个 dom 节点对接任意 JavaScript 框架，比如 jQuery/Vue 等

    const html = `
    <div>
      <input v-model="inputValue" type="text" placeholder="Enter something..." class="cxd-TextControl-input"/>
      <textarea>{{ message }}</textarea>
      <button @click="startSSE">Start SSE</button>
    </div>
    `;
    dom.current.innerHTML = html;

    const { createApp, ref, onBeforeUnmount } = Vue;

    const app = createApp({
      setup() {
        const message = ref("Waiting for server...");
        const inputValue = ref("");
        // Function to handle SSE
        function startSSE() {
          if (typeof EventSource === "undefined") {
            message.value = "SSE not supported by your browser.";
            return;
          }
          const neo_api = `/api/__yao/neo`;
          const sse = new EventSource(
            `${neo_api}?content=${encodeURIComponent(
              inputValue.value
            )}&token=${encodeURIComponent(yao_amis.getToken())}`
          ); // Use your server's SSE endpoint

          // const sse = new EventSource(props.env.context.SSE_ENDPOINT); // Use your server's SSE endpoint

          sse.onmessage = function (event) {
            // debugger;
            let data = event.data;
            if (data != null) {
              console.log(`data:${data}`);
              formated_data = JSON.parse(data);
              const { text, confirm, actions, done, command } = formated_data;
              if (done) {
              } else if (text) {
                message.value += text;
              }
            }
          };
          sse.onopen = () => {
            message.value = "";
          };
          sse.onerror = function (event) {
            // debugger;
            sse.close();
            // message.value = "Disconnected from SSE.";
          };
          // Cleanup on component unmount
        }
        onBeforeUnmount(() => {
          // sse.close();
        });
        return {
          message,
          inputValue,
          startSSE,
        };
      },
    });

    app.mount(dom.current);
  });
  return React.createElement("div", {
    ref: dom,
  });
}
