import { Exception, Process, Query } from '@yao/yao';

interface ChartConfig {
  label: string; //描述
  model: string; //模型名称
  yfields: { field: string; type1?: string }[]; //系列值
  xfield: string; //x轴配置字段
}

/**
 * yao run scripts.amis.chart.getChartById 1
 * @param chartId
 * @returns
 */
export function getChartById(chartId: string | number) {
  const [row] = Process('models.system.chart.get', {
    wheres: [
      {
        column: 'id',
        value: chartId,
      },
      {
        method: 'orwhere',
        column: 'name',
        value: chartId,
      },
    ],
  });
  if (!row) {
    throw new Exception(`图表配置不存在${chartId}`);
  }
  // console.log('row', row);
  return getChartUseConfig(row);
}

/**
 * yao run scripts.chart.config.getConfig
 * @param payload
 * @returns
 */
export function getChartUseConfig(payload: ChartConfig) {
  //   payload = {
  //     model: 'product',
  //     field1: [{ field: 'price', type1: 'bar' }],
  //     field2: 'name',
  //   };
  if (!payload || !payload.yfields) {
    return {};
  }
  let fields = [];
  payload.yfields.forEach((f) => fields.push(f.field));
  fields.push(payload.xfield);
  fields = [...new Set(fields)];

  const model = payload.model;

  const q = new Query();
  const list = q.Get({
    // "debug": true,
    select: fields,
    from: `${model}`,
    wheres: [{ ':deleted_at': '删除', '=': null }],
    limit: 1000,
  });
  // console.log('list', list);

  const xAxis = [];
  const series = []; //有可能会有重复的字段，但是显示类型不一样。
  const fieldsDataMap = {};

  payload.yfields.forEach((f1) => {
    series.push({ type: f1.type1 || 'bar', name: f1.field, data: [] });
    fieldsDataMap[f1.field] = [];
  });

  list.forEach((line) => {
    xAxis.push(line[payload.xfield]);
    for (const key in fieldsDataMap) {
      if (Object.prototype.hasOwnProperty.call(fieldsDataMap, key)) {
        fieldsDataMap[key].push(line[key]);
      }
    }
  });
  for (const key in fieldsDataMap) {
    series.forEach((s) => {
      if (s.name == key) {
        s.data = fieldsDataMap[key];
      }
    });
    // series.filter((x) => x.name == key)[0].data = x1[key];
  }

  return {
    title: {
      text: payload.label || payload.model,
    },
    tooltip: {},
    legend: {
      data: Object.keys(fieldsDataMap),
    },
    xAxis: {
      data: xAxis,
    },
    yAxis: {},
    series: series,
  };
}
