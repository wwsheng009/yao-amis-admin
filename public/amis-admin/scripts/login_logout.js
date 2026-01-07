if (!window.axios) {
  window.axios = amisRequire('axios').default || amisRequire('axios');
}

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

async function __amisFetcher(api) {
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
  } catch (error) { }
  // if (token) {
  //   config.headers["Authorization"] = `Bearer ${token}`;
  // } else {
  //   window.location.href = "login.html";
  //   return;
  // }
  const catcherr = (error) => {
    if (error.response) {
      if (error.response.data?.error_description) {
          error.message = error.response.data.error_description;
        }
      if (error.response.status == 401 || error.response.data?.error == 'token_missing'){
        window.location.href = "login.html";
      }
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
    if (response.data?.error_descriptionor) {
        response.message = response.data.error_description;
      }
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
      } catch (error) { }
    }
  }
  return axios[method](url, data, config).then(check).catch(catcherr);
}



/**
 * yao_amis 对象提供了用户认证相关的功能,包括登录、登出、token管理等
 * 主要功能:
 * - 登录/登出管理
 * - token的存储和刷新
 * - xgen菜单更新
 * - cookie管理
 * - studio token管理
 * 
 * 该对象与xgen保持兼容,可以在amis-admin中使用
 * 
 * @namespace yao_amis
 * @property {string} loginUrl - 登录页面URL
 * @property {number} tokenRefreshTimer - token刷新定时器ID
 * @property {string} reloadUrl - 登录成功后重定向的URL
 */
/**
 * yao_amis 对象提供了一组用于处理登录、登出和令牌管理的工具方法。
 * 主要功能包括:
 * - 登录/登出处理
 * - token 存储和管理(localStorage/sessionStorage)
 * - xgen 菜单更新
 * - token 自动刷新
 * - cookie 操作
 * - studio token 管理
 * 
 * 该对象与 xgen 框架集成,用于处理身份验证和授权。
 * 所有方法都设计为保持与 xgen 的兼容性。
 */
var yao_amis = {
  loginUrl: "/amis-admin/login.html",

  /**
   * 获取xgenToken的保存类型，与xgen保持一致
   * @returns
   */
  getTokenStorageType() {
    const storage = localStorage.getItem(`xgen:token_storage`);
    let stoarge_type = "localStorage";
    if (storage != null) {
      try {
        const o = JSON.parse(storage);
        if (o.value === "sessionStorage") {
          stoarge_type = "sessionStorage";
        }
      } catch (error) { }
    }
    return stoarge_type;
  },
  /**
   * xgen中的token保存位置，通常需要在页面加载时设置
   *
   * @param {string} type 保存类型 = sessionStorage或是localStorage
   */
  setTokenStorageType(typeIn) {
    //clean up first
    localStorage.removeItem(`xgen:token_storage`);
    localStorage.removeItem(`xgen:token_storage`)

    const type = typeIn === "localStorage" ? "localStorage" : "sessionStorage";
    this.xgenSetStorage(`xgen:token_storage`, type, "localStorage");
  },

  /**
   * 保存xgen的设置，与xgen保持一致
   * @param {string} key key
   * @param {object} obj object
   * @param {string} storageIn
   */
  xgenSetStorage(key, obj, storageIn) {
    // 默认使用localStorage
    let storage =
      storageIn === "sessionStorage" ? sessionStorage : localStorage;
    let ty = "String";
    let value = obj;
    switch (typeof obj) {
      case "string":
        ty = "String";
        value = encodeURIComponent(obj);
        break;
      case "object":
        ty = "Object";
        if (Array.isArray(obj)) {
          ty = "Array";
        }
        break;
      case "number":
        ty = "Number";
        break;
      default:
        console.log("Error=========> Not Support Type:" + typeof obj);
        break;
    }

    storage.setItem(key, JSON.stringify({ type: ty, value: value }));
  },
  xgenGetStorage(key, storageIn) {
    let storage =
      storageIn === "sessionStorage" ? sessionStorage : localStorage;

    let s = storage.getItem(key);

    if (s != null && key.startsWith("xgen:")) {
      try {
        s = JSON.parse(s);
      } catch (error) { }
    }
    return s;
  },
  // 兼容xgen集成登录
  updateXgenMenus(menus) {
    // Set keys for the menu items
    const setKeys = (items, parent_key, in_setting) => {
      let idxkey = 0
      items.forEach((item) => {
        const parent = parent_key != '' ? '/_parent' + parent_key : ''
        const setting = in_setting ? '/_setting' : ''
        const id = idxkey > 0 ? '/_' + idxkey : ''
        const key = `${item.path}/_menu${setting}${parent}${id}`
        item.key = key
        idxkey++
        if (item.children) setKeys(item.children, item.key, in_setting)
      })
    }

    setKeys(menus.items, '', false)
    setKeys(menus.setting, '', true)

    this.xgenSetStorage("xgen:menus", menus);
    this.xgenSetStorage("xgen:menu", menus.items);
  },

  afterLogin(payload) {
    const token = encodeURIComponent(payload.token);

    let newDate = new Date();
    if (payload.expires_in) {
      newDate.setTime(payload.expires_in * 1000);
    } else {
      newDate.setTime(newDate.getTime() + 2 * 60 * 60 * 1000);
    }

    let expires = "expires=" + newDate.toGMTString();
    document.cookie = `token=${token};${expires};path=/`;
    document.cookie = `__Host-access_token=${token};${expires};path=/`;
    // document.cookie = `username=${payload.user.name};${expires};path=/`;
    // document.cookie = `email=${payload.user.email};${expires};path=/`;

    const tokenStoarageType = this.getTokenStorageType();
    this.xgenSetStorage("xgen:token", token, tokenStoarageType);
    // this.xgenSetStorage("xgen:user", payload.user);

    if (payload.menus) {
      this.updateXgenMenus(payload.menus)
    }

    // if (payload.studio) {
    //   //studio

    //   if (payload.studio.expires_at) {
    //     newDate.setTime(payload.studio.expires_at * 1000);
    //   } else {
    //     newDate.setTime(newDate.getTime() + 24 * 60 * 60 * 1000);
    //   }
    //   expires = "expires=" + newDate.toGMTString();
    //   document.cookie = `studio=${encodeURIComponent(
    //     payload.studio.token
    //   )};${expires};path=/`;

    //   this.xgenSetStorage("xgen:studio", payload.studio, tokenStoarageType);
    // }
  },

  /**
   * 注入全局变量，在系统登录时成功后会调用
   * payload,返回的报文值
   * response http请求响应
   * return yao_amis.login(payload,response,api,context)
   */
  login(payload, response, api, context) {
    let data = payload;
    if (data.data) {
      data = data.data;
    }
    if ("msg" in data && "status" in data && data.status != 0) {
      return data;
    }
    if (response.status === 200 && payload) {
      this.afterLogin(data);
      if (this.reloadUrl) {
        window.location.href = this.reloadUrl;
      }
    }
    // 启动定时刷新token
    if (this.tokenRefreshTimer) {
      clearInterval(this.tokenRefreshTimer);
    }
    this.tokenRefreshTimer = setInterval(() => this.refreshToken(), 600000);

    return {
      status: 0,
      msg: "登录成功",
      data: data,
    };
  },

  logout(toLogin) {
    if (this.tokenRefreshTimer) {
      clearInterval(this.tokenRefreshTimer);
      this.tokenRefreshTimer = null;
    }
    document.cookie =
      "token" + "=; expires=Thu, 01 Jan 1970 00:00:01 GMT; path=/";
    document.cookie =
      "studio" + "=; expires=Thu, 01 Jan 1970 00:00:01 GMT; ; path=/";

    localStorage.removeItem("xgen:token");
    sessionStorage.removeItem("xgen:token");
    if (toLogin) {
      window.location.href = this.loginUrl;
    }
  },

  getCookie(name) {
    const cookies = document.cookie.split(";");
    for (let i = 0; i < cookies.length; i++) {
      const cookie = cookies[i].trim();
      if (cookie.startsWith(name + "=")) {
        return cookie.substring(name.length + 1);
      }
    }
    return null;
  },

  getSecureCookie(name) {
    const cookies = document.cookie.split(";");
    for (let i = 0; i < cookies.length; i++) {
      const cookie = cookies[i].trim();
      if (cookie.startsWith(name + "=")) {
        return cookie.substring(name.length + 1);
      }
    }
    return null;
  },

  setCookie(name, value, hours) {
    let expires = "";
    if (hours) {
      let date = new Date();
      date.setTime(date.getTime() + hours * 60 * 60 * 1000);
      expires = "; expires=" + date.toUTCString();
    }
    document.cookie = name + "=" + (value || "") + expires + "; path=/";
  },
  deleteCookie(name) {
    document.cookie = name + "=; expires=Thu, 01 Jan 1970 00:00:01 GMT;";
  },

  deleteToken(tokenIn) {
    const tokenName = tokenIn ? tokenIn : "token";
    sessionStorage.removeItem(`xgen:${tokenName}`);
    localStorage.getItem(`xgen:${tokenName}`);
    this.deleteCookie(tokenName);
  },
  getToken(tokenIn) {
    const cookie = this.getCookie('__Host-access_token');
    let token = null;
    // trim Bearer+ in cookie
    // check if the cookie is startwith Bearer+
    if (cookie?.startsWith('Bearer+')) {
      token = cookie?.substring(7);
    }
    if (token) {
      return token;
    }
    const tokenName = tokenIn ? tokenIn : "token";
    const stoarage_type = this.getTokenStorageType();

    token = this.xgenGetStorage(`xgen:${tokenName}`, stoarage_type);

    if (token) {
      token = token.value;
      if (tokenName == "studio") {
        token = token.value.token;
      }
    }
    if (token) {
      this.setCookie(tokenName, token, 8);
    } else {
      // 需要确保当从xgen里退出后，本地的cookie也不能生效，两边的token进行同步
      this.deleteCookie(tokenName);
    }
    return token;
  },

  checkToken() {
    let token = this.getToken();

    if (!token) {
      window.location.href = this.loginUrl;
    }
  },

  async refreshToken() {
    let token = this.getToken();
    if (token) {
      try {
        let payload = await __amisFetcher({ method: 'post', url: '/api/v1/amis/refresh_token' })
        if (payload.status == 200) {
          this.afterLogin(payload.data?.data)
        } else {
          this.deleteToken()
          clearInterval(this.tokenRefreshTimer);
          this.tokenRefreshTimer = null;
          window.location.href = this.loginUrl;
        }
      } catch (error) {
        console.error('刷新token失败:', error);
        this.deleteToken();
        clearInterval(this.tokenRefreshTimer);
        this.tokenRefreshTimer = null;
        window.location.href = this.loginUrl;
      }
    }
  },

  checkStudioToken() {
    let token = this.getToken("studio");

    if (!token) {
      window.location.href = this.loginUrl;
    }
  },

  generateUniqueId() {
    const timestamp = Date.now().toString(36);
    const randomString = Math.random().toString(36).substr(2, 25);
    return `${timestamp}-${randomString}`;
  },
};
