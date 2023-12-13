// yao run scripts.app.monitor.getCpuInfo

function getCpuInfo() {
  const dashboard = Process("plugins.psutil.dashboard");
  const cpuData = dashboard.system.currentInfo.cpuPercent;

  // 提取时间戳数据
  var serials = cpuData.map(function (_, i) {
    return "core " + (i + 1);
  });

  return { line: cpuData, serials: serials };
}
