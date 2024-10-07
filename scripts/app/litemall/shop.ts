import { Process } from '@yao/yao';
import { catalogInfo, LiteMallResPonse, shopInfos } from './type';
import { convertKeysToCamelCase } from './utils';
import { YaoQueryParam } from '@yaoapps/types';

/**
 * yao run scripts.app.litemall.shop.getRulesGoods
 * @returns
 */
function getRulesGoods() {
  const grouponRulesList = Process('models.app.litemall.groupon.rules.get', {
    withs: {
      goods: {
        query: {
          select: [
            'id',
            'title',
            'pic_url',
            'brief',
            'counter_price',
            'retail_price'
          ]
        }
      }
    },
    limit: 10,
    select: ['id', 'discount', 'discount_member']
  } as YaoQueryParam.QueryParam);

  return grouponRulesList.map((r) => {
    const item = { ...r.goods };
    item.groupon_discount = r.discount;
    item.groupon_member = r.discount_member;
    item.groupon_price = item.retail_price - r.discount;
    return item;
  });
}
/**
 * 首页数据
 *
 * yao run scripts.app.litemall.shop.homeIndex
 */
export function homeIndex(): LiteMallResPonse<shopInfos> {
  const branList = Process('models.app.litemall.brand.get', {
    select: ['id', 'name', 'pic_url'],
    limit: 10
  } as YaoQueryParam.QueryParam);

  const channelList = Process('models.app.litemall.category.get', {
    select: ['id', 'name', 'icon_url'],
    limit: 10
  } as YaoQueryParam.QueryParam);

  const topicList = Process('models.app.litemall.topic.get', {
    select: ['id', 'title', 'pic_url'],
    limit: 10
  } as YaoQueryParam.QueryParam);

  const newGoodsList = Process('models.app.litemall.goods.get', {
    select: ['id', 'name', 'pic_url'],
    wheres: [{ column: 'is_new', value: 1 }],
    limit: 10
  } as YaoQueryParam.QueryParam);

  const hotGoodsList = Process('models.app.litemall.goods.get', {
    select: [
      'id',
      'title',
      'pic_url',
      'brief',
      'counter_price',
      'retail_price'
    ],
    wheres: [{ column: 'is_hot', value: 1 }],
    limit: 10
  } as YaoQueryParam.QueryParam);

  const couponList = Process('models.app.litemall.coupon.get', {
    select: ['id', 'name', 'discount', 'tag', 'desc', 'days', 'end_time'],
    limit: 10
  } as YaoQueryParam.QueryParam);

  return convertKeysToCamelCase({
    data: {
      banner: [],
      channel: channelList,
      couponList: couponList,
      grouponList: getRulesGoods(),
      brandList: branList,
      newGoodsList: newGoodsList,
      hotGoodsList: hotGoodsList,
      topicList: topicList
    },
    errno: 0
  });
}

export function catalogIndex(): LiteMallResPonse<catalogInfo> {
  return {
    data: {
      categoryList: [],
      brotherCategory: [],
      currentCategory: {
        id: 0
      }
    },
    errno: 0
  };
}
