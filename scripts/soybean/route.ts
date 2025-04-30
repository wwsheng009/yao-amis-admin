import {
  cleanUpRouteMenu,
  getSoyRoutesFromDB,
  getSoySuperUserMenu
} from '@scripts/admin/menu';
import { filterTreeDataWithFunc } from '@scripts/amis/data/tree';
import { getUserAuthMenuIds } from '@scripts/auth/lib';
import { Process } from '@yaoapps/client';

export function getConstantRoutes() {
  return [
    {
      name: '403',
      path: '/403',
      component: 'layout.blank$view.403',
      meta: {
        title: '403',
        i18nKey: 'route.403',
        constant: true,
        hideInMenu: true
      }
    },
    {
      name: '404',
      path: '/404',
      component: 'layout.blank$view.404',
      meta: {
        title: '404',
        i18nKey: 'route.404',
        constant: true,
        hideInMenu: true
      }
    },
    {
      name: '500',
      path: '/500',
      component: 'layout.blank$view.500',
      meta: {
        title: '500',
        i18nKey: 'route.500',
        constant: true,
        hideInMenu: true
      }
    },
    {
      name: 'iframe-page',
      path: '/iframe-page/:url',
      component: 'layout.base$view.iframe-page',
      props: true,
      meta: {
        title: 'iframe-page',
        i18nKey: 'route.iframe-page',
        constant: true,
        hideInMenu: true,
        keepAlive: true
      }
    },
    {
      name: 'iconify-design',
      path: '/iconify/design',
      component: 'layout.base$view.iframe-page',
      props: {
        url: 'https://icon-sets.iconify.design/'
      },
      meta: {
        title: 'Iconify Design',
        order: 3,
        url: 'https://icon-sets.iconify.design/',
        icon: 'line-md:iconify2-static'
      }
    },
    {
      name: 'login',
      path: '/login/:module(pwd-login|code-login|register|reset-pwd|bind-wechat)?',
      component: 'layout.blank$view.login',
      props: true,
      meta: {
        title: 'login',
        i18nKey: 'route.login',
        constant: true,
        hideInMenu: true
      }
    }
  ];
}

/**
 * get user auth menus
 * yao run scripts.soybean.route.getSoyUserMenu
 */
export function getSoyUserMenu() {
  // Process('session.set', 'user_id', 3);
  const menusIds = getUserAuthMenuIds();
  if (menusIds.length) {
    // get menus
    let routes = getSoyRoutesFromDB();
    routes = Process(`utils.arr.Tree`, routes, { parent: 'parent', empty: 0 });
    routes = filterTreeDataWithFunc(routes, (item) => {
      return menusIds.includes(item.id) || !item.meta?.requiresAuth;
    });
    return cleanUpRouteMenu(routes);
  } else {
    const user = Process('session.get', 'user');
    if (user?.type === 'super') {
      return getSoySuperUserMenu();
    }
  }
  return [];
}

export function isRouteExist(routeName: string) {
  return routeName != '';
}
