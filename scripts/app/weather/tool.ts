import { UtilsProxy } from '@lib/proxy';
import {
  AppWeatherLocationService,
  IAppWeatherLocation
} from '@scripts/db_services/app/weather/location';
import { AppWeatherProvinceService } from '@scripts/db_services/app/weather/province';
import { Process } from '@yaoapps/client';

//yao run scripts.app.weather.tool.loadLocationList

export function loadLocationList() {
  const provinces = AppWeatherProvinceService.Get({});
  AppWeatherLocationService.DeleteAll();
  provinces.forEach((province) => {
    updateLocation(province.code);
    UtilsProxy.Sleep(1000);
  });
}

//yao run scripts.app.weather.tool.updateLocation AAH

function updateLocation(province_code: string) {
  // {
  //     "msg": "success",
  //     "code": 0,
  //     "data": "54527,西青|54517,黑牛城|54526,东丽|54528,北辰|54623,塘沽|54529,宁河|54525,宝坻|54523,武清|54622,津南|54428,蓟州|54619,静海"
  // }
  //url =>https://weather.cma.cn/api/dict/province/{province_code}
  // retrive the data , then update the location list
  const response = Process(
    'http.get',
    'https://weather.cma.cn/api/dict/province/' + province_code
  );
  if (response.code !== 200) {
    console.log('error', response.message);
    return;
  } else {
    console.log('processing...', province_code);
  }
  const data = response.data;

  if (data.code === 0) {
    const locations = data.data.split('|');
    const list = [] as IAppWeatherLocation[];
    locations.forEach((location: string) => {
      const [code, name] = location.split(',');
      list.push({
        province_code: province_code,
        name,
        code
      });
    });
    // const { columns, values } = Process('utils.arr.split', list);

    AppWeatherLocationService.InsertBatch(list);
  } else {
    console.log('error', data.msg);
  }
}

//yao run scripts.app.weather.tool.getWeatherByName 北京

export function getWeatherByName(locationName: string) {
  const [location] = AppWeatherLocationService.Get({
    wheres: [
      {
        column: 'name',
        op: 'like',
        value: `%${locationName}%`
      }
    ]
  });
  if (!location) {
    const [province] = AppWeatherProvinceService.Get({
      wheres: [
        {
          column: 'name',
          op: 'like',
          value: `%${locationName}%`
        }
      ]
    });
    if (province) {
      const locations = AppWeatherLocationService.Get({
        wheres: [
          {
            column: AppWeatherLocationService.FieldNames.province_code,
            op: 'eq',
            value: province.code
          }
        ]
      });
      if (locations.length > 0) {
        return (
          '错误的区域,请用户选择以下地区中的一个：' +
          locations.map((location) => location.name).join(', ')
        );
      }
    }

    let output = '此地区不存在，需要用户选择以下省份中的一个：';
    const provinces = AppWeatherProvinceService.Get({ limit: 10 });
    output += provinces.map((province) => province.name).join(', ');

    // provinces.forEach((p) => {
    //   const locations = AppWeatherLocationService.Get({
    //     wheres: [
    //       {
    //         column: AppWeatherLocationService.FieldNames.province_code,
    //         op: 'eq',
    //         value: p.code
    //       }
    //     ],
    //     limit: 1000
    //   });
    //   output +=
    //     p.name + '：' + locations.map((location) => location.name).join(', ');
    // });

    return output;
  }

  // const tm = Math.floor(Date.now() / 1000);
  // console.log('tm', tm);
  const resp = Process(
    'http.get',
    `https://weather.cma.cn/api/now/${location.code}`
  );
  const headers = resp.headers;
  let isJson = false;
  if (
    headers['Content-Type'] &&
    headers['Content-Type'][0].includes('application/json')
  ) {
    isJson = true;
  }
  let responseData = resp.data;

  if (!isJson) {
    responseData = Process('encoding.base64.Decode', resp.data);
  }
  // console.log('responseData', responseData);
  // console.log('resp', resp);
  if (resp.code !== 200) {
    return { code: 1, message: resp.message };
  }
  const body = responseData;
  return body.data?.now?.temperature + '°C';
}
