export type LiteMallResPonse<T> = {
  data: T;
  errno: number;
};

//首页用户展示信息
export type shopInfos = {
  //
  banner: {
    id: number; //bannerid
    url: string; //图片地址
  }[];
  //频道/分类
  channel: {
    id: number; //频道id，也是categoryid
    name: string; //名称
    iconUrl: string; //图标地址
  }[];
  //优惠券
  couponList: {
    id: number; //优惠券id
    discount: number; //折扣
    tag: string; //标签
    desc: string; //描述
    name: string; //优惠券名称
    days: number; //天数
    endTime: Date; //结束时间
  }[];
  //参加团购的商品
  grouponList: {
    id: number; //团购id
    name: string; //团购名称
    brief: string; //团购描述
    retailPrice: number; //现价
    grouponPrice: number; //团购价格
    picUrl: string; //图片地址
    grouponMember: number; //团购人数
    grouponDiscount: number; //团购折扣
  }[];
  //品牌商直供
  brandList: {
    id: number; //品牌id
    name: string; //品牌名称
    picUrl: string; //图片地址
  }[];
  //新品首发
  newGoodsList: {
    id: number; //商品id
    name: string; //商品名称
    picUrl: string; //图片地址
  }[];
  //人气推荐
  hotGoodsList: {
    id: number; //商品id
    name: string; //商品名称
    brief: string; //商品简介
    counterPrice: number; //原价
    retailPrice: number; //现价
    picUrl: string; //图片地址
  }[];
  //专题精选
  topicList: {
    id: number; //话题id
    picUrl: string; //图片地址
    title: string; //标题
    subTitle: string; //副标题
  }[];
};

export interface catalogInfo {
  categoryList: {
    id: number; //商品id
  }[];
  brotherCategory: {
    id: number; //商品id
  }[];
  currentCategory: {
    id: number; //商品id
  };
}
