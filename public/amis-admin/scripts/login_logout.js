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
    if (payload.expires_at) {
      newDate.setTime(payload.expires_at * 1000);
    } else {
      newDate.setTime(newDate.getTime() + 24 * 60 * 60 * 1000);
    }

    let expires = "expires=" + newDate.toGMTString();
    document.cookie = `token=${token};${expires};path=/`;
    document.cookie = `username=${payload.user.name};${expires};path=/`;
    document.cookie = `email=${payload.user.email};${expires};path=/`;

    const tokenStoarageType = this.getTokenStorageType();
    this.xgenSetStorage("xgen:token", token, tokenStoarageType);
    this.xgenSetStorage("xgen:user", payload.user);

    this.updateXgenMenus(payload.menus)

    if (payload.studio) {
      //studio

      if (payload.studio.expires_at) {
        newDate.setTime(payload.studio.expires_at * 1000);
      } else {
        newDate.setTime(newDate.getTime() + 24 * 60 * 60 * 1000);
      }
      expires = "expires=" + newDate.toGMTString();
      document.cookie = `studio=${encodeURIComponent(
        payload.studio.token
      )};${expires};path=/`;

      this.xgenSetStorage("xgen:studio", payload.studio, tokenStoarageType);
    }
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
    return {
      status: 0,
      msg: "登录成功",
      data: data,
    };
  },

  logout(toLogin) {
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
    const tokenName = tokenIn ? tokenIn : "token";
    const stoarage_type = this.getTokenStorageType();

    let token = this.xgenGetStorage(`xgen:${tokenName}`, stoarage_type);

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
