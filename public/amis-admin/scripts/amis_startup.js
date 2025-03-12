yao_amis.checkToken();
(async function () {
    
    const axios = amisRequire('axios').default || amisRequire('axios');
    window.axios = axios;//确保在fetcher的js文件中能引用到。或是把fetcher移动到这个文件

    const appInfo = await axios.get("/api/__yao/app/setting")
    let amisEmbed = amisRequire('amis/embed');
    const match = amisRequire('path-to-regexp').match;

    // 如果想用 browserHistory 请切换下这处代码, 其他不用变
    // const history = History.createBrowserHistory();
    const history = History.createHashHistory();

    const request = await axios.get("pages/definitions.json")
    const definitions = request.data.definitions
    const app = {
        type: 'app',
        brandName: appInfo.data.name,
        logo: appInfo.data.logo,
        header: {
            "schemaApi": "get:/api/v1/amis/pages/system.toolbar",
            "type": "service",
            "className": "w-full flex",
        },
        footer: '<div class="p-2 text-center bg-light"><%= Date() %></div>',
        // asideBefore: '<div class="p-2 text-center">菜单前面区域</div>',
        // asideAfter: '<div class="p-2 text-center">菜单后面区域</div>',
        api: "/api/v1/amis/menu",

        // 多页应用里，resolveDefinitions函数挂载在root组件上。
        // \amis\packages\amis-core\src\Root.tsx
        definitions: definitions,
    };

    function normalizeLink(to, location = history.location) {
        to = to || '';

        if (to && to[0] === '#') {
            to = location.pathname + location.search + to;
        } else if (to && to[0] === '?') {
            to = location.pathname + to;
        }
        const idx = to.indexOf('?');
        const idx2 = to.indexOf('#');
        let pathname = ~idx
            ? to.substring(0, idx)
            : ~idx2
                ? to.substring(0, idx2)
                : to;
        let search = ~idx ? to.substring(idx, ~idx2 ? idx2 : undefined) : '';
        let hash = ~idx2 ? to.substring(idx2) : location.hash;

        if (!pathname) {
            pathname = location.pathname;
        } else if (pathname[0] != '/' && !/^https?\:\/\//.test(pathname)) {
            let relativeBase = location.pathname;
            const paths = relativeBase.split('/');
            paths.pop();
            let m;
            while ((m = /^\.\.?\//.exec(pathname))) {
                if (m[0] === '../') {
                    paths.pop();
                }
                pathname = pathname.substring(m[0].length);
            }
            pathname = paths.concat(pathname).join('/');
        }

        return pathname + search + hash;
    }

    function isCurrentUrl(to, ctx) {
        if (!to) {
            return false;
        }
        const pathname = history.location.pathname;
        const link = normalizeLink(to, {
            ...location,
            pathname,
            hash: ''
        });

        if (!~link.indexOf('http') && ~link.indexOf(':')) {
            let strict = ctx && ctx.strict;
            return match(link, {
                decode: decodeURIComponent,
                strict: typeof strict !== 'undefined' ? strict : true
            })(pathname);
        }

        return decodeURI(pathname) === link;
    }

    let amisInstance = amisEmbed.embed(
        '#root',
        app,
        {
            location: history.location,
            locale: "zh-CN",
            data: {
                // props 里的 data 属性来赋予 amis 顶层数据域的值
                // 全局数据，是受控的数据
            },
            context: {
                // 全局上下文数据, 非受控的数据，无论哪一层都能获取到，包括弹窗自定义数据映射后都能获取到。
                // 可以用来放一下全局配置等。比如 API_HOST, 这样页面配置里面可以通过 ${API_HOST} 来获取到。
                //API_HOST: ''
                STUDIO_HOST: 'http://localhost:5077',
                SSE_ENDPOINT: '/api/chat-process'
            }
        },
        {
            fetcher: __amisFetcher,
            // watchRouteChange: fn => {
            //   return history.listen(fn);
            // },
            updateLocation: (location, replace) => {
                location = normalizeLink(location);
                if (location === 'goBack') {
                    return history.goBack();
                } else if (
                    (!/^https?\:\/\//.test(location) &&
                        location ===
                        history.location.pathname + history.location.search) ||
                    location === history.location.href
                ) {
                    // 目标地址和当前地址一样，不处理，免得重复刷新
                    return;
                } else if (/^https?\:\/\//.test(location) || !history) {
                    return (window.location.href = location);
                }
                if (isCurrentUrl(location)) {
                    return;
                }
                history[replace ? 'replace' : 'push'](location);
            },
            jumpTo: (to, action) => {
                if (to === 'goBack') {
                    return history.goBack();
                }

                to = normalizeLink(to);

                if (isCurrentUrl(to)) {
                    return;
                }

                if (action && action.actionType === 'url') {
                    action.blank === false
                        ? (window.location.href = to)
                        : window.open(to, '_blank');
                    return;
                } else if (action && action.blank) {
                    window.open(to, '_blank');
                    return;
                }

                if (/^https?:\/\//.test(to)) {
                    window.location.href = to;
                } else if (
                    (!/^https?\:\/\//.test(to) &&
                        to === history.pathname + history.location.search) ||
                    to === history.location.href
                ) {
                    // do nothing
                } else {
                    history.push(to);
                }
            },
            isCurrentUrl: isCurrentUrl,
            theme: 'cxd',
            // theme: 'antd',
            enableAMISDebug: true,
            // pdfjsWorkerSrc: `https://unpkg.com/pdfjs-dist@4.3.136/build/pdf.worker.min.mjs` // pdfJsUrl1
        }
    );
    window.amisInstance = amisInstance;

    // console.log("amisInstance", amisInstance)
    history.listen(state => {
        amisInstance.updateProps({
            location: state.location || state,
            locale: "zh-CN"
        });
    });
})();