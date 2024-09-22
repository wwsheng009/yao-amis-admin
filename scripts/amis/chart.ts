import { getDBModelById } from '@scripts/system/model';
import { Exception, log, Process, Query } from '@yao/yao';

interface ChartDBConfig {
  label: string; //描述
  model: string; //模型名称
  yfields: { field: string; chartType?: string }[]; //系列值
  xfield: string; //x轴配置字段
  config: {
    series: string | object[];
    xAxis:
      | {
          data: object[];
        }[]
      | string;
  };
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
  return getChartUseConfig(row);
}

/**
 * yao run scripts.chart.config.getConfig
 * @param payload
 * @returns
 */
export function getChartUseConfig(payload: ChartDBConfig) {
  //   payload = {
  //     model: 'product',
  //     field1: [{ field: 'price', chartType: 'bar' }],
  //     field2: 'name',
  //   };

  // console.log('payload', payload);

  const chartData = getDbDataFromConfig(payload);
  // 没有自定义配置。
  if (payload.config == null) {
    return chartData;
  }

  let chartData1 = payload.config;
  if (typeof chartData1 === 'string') {
    try {
      chartData1 = JSON.parse(chartData1);
    } catch (error) {
      log.Error('invalid config', +error.message);
      return {};
    }
  }

  if (chartData1?.series.length == 0 || chartData1?.series == '$series') {
    chartData1.series = chartData.series;
  }
  if (chartData1?.xAxis?.length == 0 || chartData1?.xAxis == '$xAxis') {
    chartData1.xAxis = chartData.xAxis;
  }
  return chartData1;
}

function getDbDataFromConfig(payload: ChartDBConfig) {
  if (!payload.yfields || !payload.model || !payload.xfield) {
    return {};
  }
  let fields = [];
  payload.yfields?.forEach((f) => fields.push(f.field));
  fields.push(payload.xfield);
  fields = [...new Set(fields)];

  const model = payload.model;

  const modelDsl = getDBModelById(model);
  let wheres = [];
  if (modelDsl.option.soft_deletes) {
    wheres = [{ ':deleted_at': '删除', '=': null }];
  }

  const q = new Query();
  const list = q.Get({
    // "debug": true,
    select: fields,
    from: `${model}`,
    wheres: wheres,
    limit: 1000,
  });

  const xAxis = [];
  const series = []; //有可能会有重复的字段，但是显示类型不一样。
  const fieldsDataMap = {};

  payload.yfields.forEach((f1) => {
    const [column] = modelDsl.columns.filter((c) => c.name === f1.field);

    let name = f1.field;
    if (column != null) {
      name = column.label || name;
    }
    series.push({
      type: f1.chartType || 'bar',
      name: name,
      data: [],
      field: f1.field,
    });
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
      if (s.field == key) {
        s.data = fieldsDataMap[key];
      }
      delete s.field;
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
    xAxis: [
      {
        data: xAxis,
      },
    ],
    yAxis: [{}],
    series: series,
  };
}