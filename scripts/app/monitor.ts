// 使用进程插件获取操作系统的信息
// 需要插件的支持
// https://github.com/wwsheng009/yao-plugin-psutil
import { Process, Exception, Query } from '@yao/yao';

/**
 * 获取主机cpu的信息
 * yao run scripts.app.monitor.getCpuInfo
 * @returns
 */
function getCpuInfo() {
  const dashboard = Process('plugins.psutil.dashboard');
  const cpuData = dashboard.system.currentInfo.cpuPercent;

  // 提取时间戳数据
  const serials = cpuData.map(function (_, i) {
    return 'core ' + (i + 1);
  });

  return { line: cpuData, serials: serials };
}
