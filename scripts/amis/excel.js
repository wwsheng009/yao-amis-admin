//使用input-excel组件批量导入数据
//input-excel导入的数据已经是解析好的数据，只要在amis页面上配置好映射关系就可以直接使用数据了。

function importData(payload) {
  // Save payload to database or storage
  // 删除所有的旧记录
  Process("models.demo.excel.DestroyWhere", {
    wheres: [{ column: "number", op: "notnull" }],
  });
  //直接插入新记录，这里是可以直接使用amis传入的input-excel的数据结构
  payload.excel && Process("models.demo.excel.EachSave", payload.excel);

  return Process("scripts.return.SuccessMessage", "数据已成功导入");
}

//scripts.amis.excel.getStatic
function getStatic() {
  const q = new Query();

  //方法一，
  const data1 = q.Get({
    select: [":MAX(number) as number", ":DATE(time) AS date"],
    from: "$demo.excel",
    groups: ["date"],
  });
  //方法二
  // const data = q.Get({
  //   sql: {
  //     stmt: "select max(number) as number,DATE(time) AS date from demo_excel group by date order by date;",
  //   },
  // });
  let xaxis = [];
  let series1 = [];

  data1.forEach((element) => {
    const [datePart] = element.date.split("T");
    // element.date = datePart;
    xaxis.push(datePart);
    series1.push(element.number);
  });

  const chartdata = {
    title: { text: "用户在线情况" },
    tooltip: {},
    legend: { data: ["数量"] },
    xAxis: { data: xaxis },
    yAxis: {},
    series: [
      {
        name: "数量",
        type: "line",
        data: series1,
        label: {
          show: true,
        },
      },
    ],
  };
  return Process("scripts.return.Success", chartdata, "数据已成功读取");
}
