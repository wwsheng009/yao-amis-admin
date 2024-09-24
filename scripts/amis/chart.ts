import { getDBModelById } from '@scripts/system/model';
import { Exception, log, Process, Query } from '@yao/yao';

interface ChartDBLine {
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
  processor?: string;
}
interface ChartConfig {
  title?: {
    text: string;
  };
  tooltip?: object;
  legend?: {
    data: string[];
  };
  series?: string | object[];
  yAxis?: object[];
  xAxis?:
    | {
        data: object[];
      }[]
    | string;
}
/**
 * yao run scripts.amis.chart.getChartById 1
 * @param chartId
 * @returns
 */
export function getChartById(
  chartId: string | number,
  query?: { [k: string]: object[] }
) {
  const [row] = Process('models.system.chart.get', {
    wheres: [
      {
        column: 'id',
        value: chartId
      },
      {
        method: 'orwhere',
        column: 'name',
        value: chartId
      }
    ]
  });
  if (!row) {
    throw new Exception(`图表配置不存在${chartId}`);
  }
  return getChartUseConfig(row, query);
}

/**
 * yao run scripts.chart.config.getConfig
 * @param payload
 * @returns
 */
export function getChartUseConfig(
  payload: ChartDBLine,
  query: { [k: string]: object[] }
) {
  //   payload = {
  //     model: 'product',
  //     field1: [{ field: 'price', chartType: 'bar' }],
  //     field2: 'name',
  //   };

  // console.log('payload', payload);
  /**
   * 优先使用处理器
   * 再使用数据库模型
   * 最后使用固定配置
   */
  if (payload.processor != null && payload.processor.split('.').length < 3) {
    throw new Exception('处理器名称不正确');
  }
  let chartData = {} as ChartConfig;
  if (payload.processor != null) {
    try {
      chartData = Process(payload.processor, query);
    } catch (error) {
      throw new Exception(error.message);
    }
  } else {
    chartData = getDbDataFromConfig(payload);
  }
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
    chartData1.series = chartData.series || [];
  }
  if (chartData1?.xAxis?.length == 0 || chartData1?.xAxis == '$xAxis') {
    chartData1.xAxis = chartData.xAxis || [];
  }
  return chartData1;
}

function getDbDataFromConfig(payload: ChartDBLine): ChartConfig {
  if (!payload.yfields || !payload.model || !payload.xfield) {
    return {};
  }
  let fields = [];
  payload.yfields?.forEach((f) => fields.push(f.field));
  fields.push(payload.xfield);
  fields = [...new Set(fields)];

  const model = payload.model;

  const modelDsl = getDBModelById(model);
  if (!modelDsl) {
    throw new Exception(`模型定义不存在${model}`);
  }
  let wheres = [];
  if (modelDsl.option?.soft_deletes) {
    wheres = [{ ':deleted_at': '删除', '=': null }];
  }

  const q = new Query();
  const list = q.Get({
    // "debug": true,
    select: fields,
    from: `$${model}`,
    wheres: wheres,
    limit: 1000
  });

  const xAxis = [];
  const series = []; //有可能会有重复的字段，但是显示类型不一样。
  const fieldsDataMap = {};

  const legend = [];
  payload.yfields.forEach((f1) => {
    const [column] = modelDsl.columns.filter((c) => c.name === f1.field);

    let name = f1.field;
    if (column != null) {
      name = column.label || name;
    }
    legend.push(name);
    series.push({
      type: f1.chartType || 'bar',
      name: name,
      data: [],
      field: f1.field
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
  series.forEach((s) => {
    s.data = fieldsDataMap[s.field];
    delete s.field;
  });

  return {
    title: {
      text: payload.label || payload.model
    },
    tooltip: {},
    legend: {
      data: legend
    },
    xAxis: [
      {
        data: xAxis
      }
    ],
    yAxis: [{}],
    series: series
  };
}

//scripts.amis.chart.chartDemo
export function chartDemo() {
  return {
    title: {
      text: '未来一周气温变化',
      subtext: '纯属虚构',
      textStyle: {},
      subtextStyle: {}
    },
    tooltip: {
      trigger: 'axis'
    },
    legend: {
      data: ['最高气温', '最低气温'],
      textStyle: {},
      pageTextStyle: {}
    },
    toolbox: {
      show: true,
      feature: {
        mark: {
          show: true
        },
        dataView: {
          show: true,
          readOnly: true
        },
        magicType: {
          show: false,
          type: ['line', 'bar']
        },
        restore: {
          show: true
        },
        saveAsImage: {
          show: true
        }
      }
    },
    calculable: true,
    xAxis: [
      {
        type: 'category',
        boundaryGap: false,
        data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
      }
    ],
    yAxis: [
      {
        type: 'value',
        name: '°C'
      }
    ],
    series: [
      {
        name: '最高气温',
        type: 'line',
        data: [11, 11, 15, 13, 12, 13, 10]
      },
      {
        name: '最低气温',
        type: 'line',
        data: [1, -2, 2, 5, 3, 2, 0]
      }
    ],
    color: [
      '#c23531',
      '#2f4554',
      '#61a0a8',
      '#d48265',
      '#91c7ae',
      '#749f83',
      '#ca8622',
      '#bda29a',
      '#6e7074',
      '#546570',
      '#c4ccd3'
    ],
    textStyle: {}
  };
}
// getChartById(1, {});
