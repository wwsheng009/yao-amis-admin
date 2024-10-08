import { buildHierarchy } from './hierarchy';

//yao run scripts.app.litemall.demo.toList
function toList() {
  const originData = {
    items: [
      {
        label: 'app.litemall.goods.attribute',
        value: 'app.litemall.goods.attribute'
      },
      {
        label: 'app.litemall.goods.product',
        value: 'app.litemall.goods.product'
      },
      {
        label: 'app.litemall.goods.specification',
        value: 'app.litemall.goods.specification'
      },
      {
        label: 'app_litemall_goods',
        value: 'app.litemall.goods'
      }
    ]
  };
  // 将结果格式化为目标格式
  const targetData = {
    items: buildHierarchy(originData.items)
  };

  console.log(JSON.stringify(targetData, null, 2));

  //   const targetData2 = {
  //     items: [
  //       {
  //         label: 'app',
  //         value: 'app',
  //         children: [
  //           {
  //             label: 'app_litemall',
  //             value: 'app.litemall',
  //             childern: [
  //               {
  //                 label: 'app_litemall_goods',
  //                 value: 'app.litemall.goods',
  //                 children: [
  //                   {
  //                     label: 'app_litemall_goods_attribute',
  //                     value: 'app.litemall.goods.attribute'
  //                   },
  //                   {
  //                     label: 'app_litemall_goods_product',
  //                     value: 'app.litemall.goods.product'
  //                   }
  //                 ]
  //               }
  //             ]
  //           }
  //         ]
  //       }
  //     ]
  //   };
}
