"use strict";
// const { User, admin_user } = Require("admin.types.user");
Object.defineProperty(exports, "__esModule", { value: true });
// scripts.admin.user.saveSetting
function saveSetting(payload) {
    console.log("scripts.admin.user.saveSetting");
    let user_id = Process("session.get", "user_id");
    let setting = payload.system_theme_setting;
    if (typeof setting === "string") {
        try {
            setting = JSON.parse(setting);
        }
        catch (error) {
            console.log("failed to parse the setting");
        }
    }
    const [theme_setting] = Process("models.admin.theme.setting.Get", {
        wheres: [{ column: "user_id", value: user_id }],
    });
    if (theme_setting) {
        return Process("models.admin.theme.setting.save", {
            user_id: user_id,
            theme_setting: setting,
        });
    }
    else {
        return Process("models.admin.theme.setting.create", {
            user_id: user_id,
            theme_setting: setting,
        });
    }
}
// scripts.admin.user.readSetting
function readSetting() {
    let default_setting = {
        footer: false,
        breadcrumb: true,
        breadcrumbIcon: false,
        themeColor: "#4080FF",
        menuWidth: 220,
        layoutMode: "default",
        siderTheme: "light",
        topTheme: "light",
        animateInType: "alpha",
        animateInDuration: 550,
        animateOutType: "alpha",
        animateOutDuration: 450,
        loginTemplate: "default",
        keepAlive: false,
        enableTab: true,
        tabIcon: true,
    };
    let user_id = Process("session.get", "user_id");
    if (user_id) {
        const [row] = Process("models.admin.theme.setting.Get", {
            wheres: [{ column: "user_id", value: user_id }],
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
                type: "button",
                actionType: "url",
                icon: "fa-brands fa-github",
                blank: true,
                url: "https://github.com/Slowlyo/owl-admin-demo",
                tooltip: "demo 源码",
                className: "mr-2 rounded-full",
            },
        },
        assets: {
            js: [],
            css: [],
            scripts: [
                'window.localStorage.setItem("admin-api-loginParams", "JTdCJTIydXNlcm5hbWUlMjIlM0ElMjJhZG1pbiUyMiUyQyUyMnBhc3N3b3JkJTIyJTNBJTIyYWRtaW4lMjIlN0Q=")',
            ],
            styles: [],
        },
        app_name: "Owl Admin",
        locale: "zh_CN",
        layout: {
            title: "%title% | OwlAdmin",
            header: {
                refresh: true,
                dark: true,
                full_screen: true,
                theme_config: true,
            },
            keep_alive_exclude: [],
            footer: '<a href="https://github.com/slowlyo/owl-admin" target="_blank">Owl Admin</a>',
        },
        logo: "http://demo.owladmin.com/admin/logo.png",
        login_captcha: true,
        show_development_tools: true,
        system_theme_setting: default_setting,
        enabled_extensions: ["slowlyo.owl-amis-json-parse"],
    };
}
/**
 * 读取用户列表，并转换
 * yao run scripts.admin.user.userList
 * @returns array[]
 */
function userList() {
    const userlist = Process("models.admin.user.get", {});
    let user = userlist.map((user) => {
        return {
            id: user.id,
            userName: user.name,
            age: 18,
            gender: user.extra?.sex,
            email: user.email,
            phone: user.mobile,
            userStatus: user.status == "enabled" ? "1" : "2",
        };
    });
    return user;
}
//# sourceMappingURL=user.js.map