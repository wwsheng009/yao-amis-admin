## 获取城市列表

https://weather.cma.cn/api/dict/province/ATJ

```json
{
    "msg": "success",
    "code": 0,
    "data": "54527,西青|54517,黑牛城|54526,东丽|54528,北辰|54623,塘沽|54529,宁河|54525,宝坻|54523,武清|54622,津南|54428,蓟州|54619,静海"
}
```


## 当前温度信息

https://weather.cma.cn/api/now/58326

```json
{
  "msg": "success",
  "code": 0,
  "data": {
    "location": {
      "id": "58326",
      "name": "巢湖",
      "path": "中国, 安徽, 巢湖"
    },
    "now": {
      "precipitation": 0.0, //毫米mm，降水单位
      "temperature": -1.9, //摄氏度，温度单位
      "pressure": 1027.0, //气压单位，单位为百帕（hPa）
      "humidity": 55.0, //湿度百分比
      "windDirection": "西南风", //风向名称
      "windDirectionDegree": 249.0, //风向角度，单位为度（°）
      "windSpeed": 0.6, //风速，单位为米/秒（m/s）
      "windScale": "微风" //风速等级
    },
    "alarm": [],
    "lastUpdate": "2025/01/17 00:20"
  }
}
```

## 批量更新的数据

中国城市七天内天气预报数据，格式如下：

- https://weather.cma.cn/api/map/weather/1
- https://weather.cma.cn/api/map/weather/2
- https://weather.cma.cn/api/map/weather/3
- https://weather.cma.cn/api/map/weather/4
- https://weather.cma.cn/api/map/weather/5
- https://weather.cma.cn/api/map/weather/6
- https://weather.cma.cn/api/map/weather/7

图片编号对应关系如下：

- 0 晴天
- 1 多云
- 2 阴天
- 4 雷阵雨
- 7 小雨
- 13 阵雪
- 14 小雪

- https://weather.cma.cn/static/img/w/icon/w0.png
- https://weather.cma.cn/static/img/w/icon/w1.png
- https://weather.cma.cn/static/img/w/icon/w2.png
- https://weather.cma.cn/static/img/w/icon/w3.png
- https://weather.cma.cn/static/img/w/icon/w4.png
- https://weather.cma.cn/static/img/w/icon/w5.png
- https://weather.cma.cn/static/img/w/icon/w6.png
- https://weather.cma.cn/static/img/w/icon/w7.png
- https://weather.cma.cn/static/img/w/icon/w13.png
- https://weather.cma.cn/static/img/w/icon/w14.png

```json
{
  "msg": "success",
  "code": 0,
  "data": {
    "lastUpdate": "2025/01/16 20:00", //最后更新时间
    "date": "2025/01/16", //日期
    "city": [
      [
        "53680", //location_code,测量站点编号
        "灵寿", //name
        "中国", //country
        3,//未知用途
        38.32, //纬度
        114.35, //经度
        7.0, //最高
        "晴", //白天，天气
        0, //图片编号
        "东南风", //白天，风向
        "微风", //白天，风力
        -6.0, //最低温度
        "晴", //夜间，天气
        0, //图片编号
        "西风", //夜间，风向
        "微风", //夜间，风力
        "AHE", //province_code 省代码
        "130126",//未知用途
      ]
    ]
  }
}
```


## 气候背景

58326 是中国气象局的一个测量站点编号。

https://weather.cma.cn/api/climate?stationid=58326

N年到N年，月平均汽温和降水量。

降水量的单位是毫米mm。温度的单位是摄氏度°C。

```json
{
  "msg": "success",
  "code": 0,
  "data": {
    "beginYear": 1981,
    "endYear": 2010,
    "data": [
      {
        "month": 1,
        "maxTemp": 7.2,
        "minTemp": 0.1,
        "rainfall": 48.2
      },
      {
        "month": 2,
        "maxTemp": 9.5,
        "minTemp": 2.2,
        "rainfall": 60.9
      },
      {
        "month": 3,
        "maxTemp": 14.4,
        "minTemp": 6.2,
        "rainfall": 92.9
      },
      {
        "month": 4,
        "maxTemp": 21.1,
        "minTemp": 12.1,
        "rainfall": 94.0
      },
      {
        "month": 5,
        "maxTemp": 26.6,
        "minTemp": 17.6,
        "rainfall": 103.2
      },
      {
        "month": 6,
        "maxTemp": 29.3,
        "minTemp": 21.8,
        "rainfall": 164.3
      },
      {
        "month": 7,
        "maxTemp": 32.6,
        "minTemp": 25.5,
        "rainfall": 189.0
      },
      {
        "month": 8,
        "maxTemp": 32.0,
        "minTemp": 24.8,
        "rainfall": 149.0
      },
      {
        "month": 9,
        "maxTemp": 27.9,
        "minTemp": 20.2,
        "rainfall": 71.8
      },
      {
        "month": 10,
        "maxTemp": 22.6,
        "minTemp": 14.3,
        "rainfall": 57.6
      },
      {
        "month": 11,
        "maxTemp": 16.2,
        "minTemp": 7.7,
        "rainfall": 59.9
      },
      {
        "month": 12,
        "maxTemp": 9.9,
        "minTemp": 2.1,
        "rainfall": 33.5
      }
    ]
  }
}
```
