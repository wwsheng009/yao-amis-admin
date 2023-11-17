// 注意，
// 1 需要在index.html或是其它的脚本文件中引用变量axios
// const axios = amisRequire('axios')
// window.axios = axios;//确保在fetcher的js文件中能引用到
//
// 2 还需要引用token.js文件

function attachmentAdpator(response, api) {
  if (response && response.headers && response.headers["content-disposition"]) {
    const disposition = response.headers["content-disposition"];
    let filename = "";

    if (disposition && disposition.indexOf("attachment") !== -1) {
      // 如果 api 中配置了，则优先用 api 中的配置
      if (api?.downloadFileName) {
        filename = api.downloadFileName;
      } else {
        // disposition 有可能是 attachment; filename="??.xlsx"; filename*=UTF-8''%E4%B8%AD%E6%96%87.xlsx
        // 这种情况下最后一个才是正确的文件名
        let filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/i;

        let matches = disposition.match(filenameRegex);
        if (matches && matches.length) {
          filename = matches[1].replace(`UTF-8''`, "").replace(/['"]/g, "");
        }

        // 很可能是中文被 url-encode 了
        if (filename && filename.replace(/[^%]/g, "").length > 2) {
          filename = decodeURIComponent(filename);
        }
      }

      let type = response.headers["content-type"];
      // 一定要设置responseType=blob,要不存在问题，如果是image文件下载了无法打开
      let blob =
        response.data.toString() === "[object Blob]"
          ? response.data
          : new File([response.data], { type: type });
      if (typeof window.navigator.msSaveBlob !== "undefined") {
        // IE workaround for "HTML7007: One or more blob URLs were revoked by closing the blob for which they were created. These URLs will no longer resolve as the data backing the URL has been freed."
        window.navigator.msSaveBlob(blob, filename);
      } else {
        let URL = window.URL || window.webkitURL;
        let downloadUrl = URL.createObjectURL(blob);
        if (filename) {
          // use HTML5 a[download] attribute to specify filename
          let a = document.createElement("a");
          // safari doesn't support this yet
          if (typeof a.download === "undefined") {
            window.location = downloadUrl;
          } else {
            a.href = downloadUrl;
            a.download = filename;
            document.body.appendChild(a);
            a.click();
          }
        } else {
          window.location = downloadUrl;
        }
        setTimeout(function () {
          URL.revokeObjectURL(downloadUrl);
        }, 100); // cleanup
      }

      return {
        ...response,
        data: {
          status: 0,
          msg: "Embed.downloading",
        },
      };
    }
  } else if (response.data && response.data.toString() === "[object Blob]") {
    return new Promise((resolve, reject) => {
      let reader = new FileReader();
      reader.addEventListener("loadend", (e) => {
        const text = reader.result;

        try {
          resolve({
            ...response,
            data: text,
          });
        } catch (e) {
          reject(e);
        }
      });

      reader.readAsText(response.data);
    });
  }

  return response;
}

function __amisFetcher(api) {
  let { url, method, data, responseType, config, headers } = api;

  config = config || {};
  config.headers = config.headers || headers || {};
  responseType && (config.responseType = responseType);

  if (config.cancelExecutor) {
    config.cancelToken = new axios.CancelToken(config.cancelExecutor);
  }

  //使用token
  let token = yao_amis.getToken();

  config.withCredentials = true;
  try {
    // debugger;
    const url2 = new URL(url);
    //跨域
    //后端可能会设置：Access-Control-Allow-Origin:'*'，与withCredentials会有冲突
    if (
      url2.port !== window.location.port ||
      url2.host !== window.location.host ||
      url2.protocol != window.location.protocol
    ) {
      //使用studio
      token = getStudioToken();

      config.withCredentials = false;
    }
  } catch (error) {}
  if (token) {
    config.headers["Authorization"] = `Bearer ${token}`;
  } else {
    window.location.href = "login.html";
    return;
  }
  const catcherr = (error) => {
    if (error.response) {
      if (error.response.data?.message) {
        error.message = error.response.data.message;
      }
      if (
        error.response.data?.code === 403 ||
        error.response.data?.code === 402
      ) {
        yao_amis.deleteToken();
        window.location.href = "login.html";
      }
      if (error.response.data?.message === "Invalid token") {
        yao_amis.deleteToken();
        window.location.href = "login.html";
      }
    } else if (error.request) {
      // The request was made but no response was received
      // `error.request` is an instance of XMLHttpRequest in the browser and an instance of
      // http.ClientRequest in node.js
      console.log(error.request);
    } else {
      // Something happened in setting up the request that triggered an Error
      console.log("Error", error.message);
    }

    return new Promise(function (resolve, reject) {
      reject(error);
    });
  };
  const check = (response) => {
    response = attachmentAdpator(response, api);

    //判断返回结构是否已经是amis结构
    if (
      typeof response.data === "object" &&
      response.data !== null &&
      "data" in response.data &&
      "msg" in response.data &&
      "status" in response.data
    ) {
      return new Promise(function (resolve, reject) {
        resolve(response);
      });
    }
    // const url = new URL(response.config.url);
    const path = url; //response.config.url;

    if (!path.startsWith("/api")) {
      return new Promise(function (resolve, reject) {
        resolve(response);
      });
    }

    //组成新的payload,即是修改response的数据
    let payload = {
      status: !response.data?.code ? 0 : response.data.code,
      msg: response.data?.message ? response.data?.message : "处理成功",
      data: response.data,
    };

    response.data = payload;

    // 在这个回调函数中返回一个新的 Promise 对象
    return new Promise(function (resolve, reject) {
      // 这里应该返回一个新的response,可以在下一个adapter里使用
      // 执行异步操作
      // 在异步操作完成后调用 resolve 或 reject
      resolve(response);
    });
  };
  if (method !== "post" && method !== "put" && method !== "patch") {
    if (data) {
      config.params = data;
    }
    return axios[method](url, config).then(check).catch(catcherr);
  } else if (data && data instanceof FormData) {
    // config.headers = config.headers || {};
    config.headers["Content-Type"] = "multipart/form-data";
  } else if (
    data &&
    typeof data !== "string" &&
    !(data instanceof Blob) &&
    !(data instanceof ArrayBuffer)
  ) {
    // data = JSON.stringify(data);
    config.headers["Content-Type"] = "application/json";
  }
  if (config.headers["Content-Type"]?.toLowerCase().includes("json")) {
    if (typeof data === "string") {
      try {
        data = JSON.parse(data);
      } catch (error) {}
    }
  }
  return axios[method](url, data, config).then(check).catch(catcherr);
}
