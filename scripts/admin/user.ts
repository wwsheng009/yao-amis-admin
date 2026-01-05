// const { User, admin_user } = Require("admin.types.user");
import { Process } from '@yao/yao';

// scripts.admin.user.saveSetting
export function saveSetting(payload) {
  // console.log('scripts.admin.user.saveSetting');
  const user_id = Process('session.get', 'user_id');

  let setting = payload.system_theme_setting;
  if (typeof setting === 'string') {
    try {
      setting = JSON.parse(setting);
    } catch (err) {
      console.log('failed to parse the setting' + err);
    }
  }
  const [theme_setting] = Process('models.admin.theme.setting.Get', {
    wheres: [{ column: 'user_id', value: user_id }]
  });
  if (theme_setting) {
    return Process('models.admin.theme.setting.save', {
      user_id: user_id,
      theme_setting: setting
    });
  } else {
    return Process('models.admin.theme.setting.create', {
      user_id: user_id,
      theme_setting: setting
    });
  }
}

// scripts.admin.user.readSetting
export function readSetting() {
  let default_setting = {
    footer: false,
    breadcrumb: true,
    breadcrumbIcon: false,
    themeColor: '#4080FF',
    menuWidth: 220,
    layoutMode: 'default',
    siderTheme: 'light',
    topTheme: 'light',
    animateInType: 'alpha',
    animateInDuration: 550,
    animateOutType: 'alpha',
    animateOutDuration: 450,
    loginTemplate: 'default',
    keepAlive: false,
    enableTab: true,
    tabIcon: true
  };

  const user_id = Process('session.get', 'user_id');
  if (user_id) {
    const [row] = Process('models.admin.theme.setting.Get', {
      wheres: [{ column: 'user_id', value: user_id }]
    });
    // const { theme_setting } = Process(
    //   "models.admin.theme.setting.find",
    //   user_id,
    //   {}
    // );
    if (row) {
      default_setting = row.theme_setting;
    }
  }

  return {
    nav: {
      appendNav: null,
      prependNav: {
        type: 'button',
        actionType: 'url',
        icon: 'fa-brands fa-github',
        blank: true,
        url: 'https://github.com/Slowlyo/owl-admin-demo',
        tooltip: 'demo 源码',
        className: 'mr-2 rounded-full'
      }
    },
    assets: {
      js: [],
      css: [],
      scripts: [
        'window.localStorage.setItem("admin-api-loginParams", "JTdCJTIydXNlcm5hbWUlMjIlM0ElMjJhZG1pbiUyMiUyQyUyMnBhc3N3b3JkJTIyJTNBJTIyYWRtaW4lMjIlN0Q=")'
      ],
      styles: []
    },
    app_name: 'Owl Admin',
    locale: 'zh_CN',
    layout: {
      title: '%title% | OwlAdmin',
      header: {
        refresh: true,
        dark: true,
        full_screen: true,
        theme_config: true
      },
      keep_alive_exclude: [],
      footer:
        '<a href="https://github.com/slowlyo/owl-admin" target="_blank">Owl Admin</a>'
    },
    logo: 'http://demo.owladmin.com/admin/logo.png',
    login_captcha: true,
    show_development_tools: true,
    system_theme_setting: default_setting,
    enabled_extensions: ['slowlyo.owl-amis-json-parse']
  };
}

/**
 * 读取用户列表，并转换
 * yao run scripts.admin.user.userList
 * @returns array[]
 */
export function userList() {
  const userlist: admin_user[] = Process('models.admin.user.get', {});

  const user: User[] = userlist.map((user: admin_user) => {
    return {
      id: user.id,
      userName: user.name,
      age: 18,
      gender: user.extra?.sex,
      email: user.email,
      phone: user.mobile,
      userStatus: user.status == 'enabled' ? '1' : '2'
    } as User;
  });
  return user;
}

export interface User {
  /** 用户id */
  id: number;
  /** 用户名 */
  userName: string | null;
  /** 用户年龄 */
  age: number | null;
  /**
   * 用户性别
   * - 0: 女
   * - 1: 男
   */
  gender: '0' | '1' | null;
  /** 用户手机号码 */
  phone: string;
  /** 用户邮箱 */
  email: string | null;
  /**
   * 用户状态
   * - 1: 启用
   * - 2: 禁用
   * - 3: 冻结
   * - 4: 软删除
   */
  userStatus: '1' | '2' | '3' | '4' | null;
}

/**
 * Model=> admin.user (用户表)
 *
 * Table=> admin_user (用户表)
 */
export interface admin_user {
  /** ID */
  id?: number;
  /** 账号类型 admin 管理员, staff 员工, user 用户, robot 机器人 */
  type?: string;
  /** 邮箱 */
  email?: string;
  /** 手机号 */
  mobile?: string;
  /** 登录密码 */
  password?: string;
  /** 姓名 */
  name?: string;
  /** 身份证号码 */
  idcard?: string;
  /** API Key */
  key?: string;
  /** API 密钥 */
  secret?: string;
  /** 扩展信息 */
  extra?: { [key: string]: any };
  /** 用户状态 enabled 有效, disabled 无效 */
  status?: string;
}
