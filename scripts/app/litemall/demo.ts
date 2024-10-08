import { Process, Query } from '@yaoapps/client';

//this is a script to copy the data from different database.

//yao run scripts.app.litemall.demo.copyData litemall_coupon app.litemall.coupon
function copyData(source: string, targetModel: string) {
  const query = new Query('mysql');
  const data = query.Get({
    sql: {
      stmt: `select * from ${source}`
    }
  });

  const query2 = new Query();
  query2.Run({
    sql: {
      stmt: `truncate ${targetModel.replaceAll('.', '_')}`
    }
  });

  const rows = Process(`models.${targetModel}.eachsave`, data);

  console.log(`table ${source} copied success, total: ${rows.length}`);
}

//yao run scripts.app.litemall.demo.copyTableList
export function copyTableList() {
  const query = new Query('mysql');

  const data = query.Get({
    sql: {
      stmt: `SHOW TABLES;`
    }
  });
  const tableList = data.reduce((prev, curr) => {
    prev.push(curr.Tables_in_litemall);
    return prev;
  }, []);

  tableList.forEach((tab) => {
    const modelName = 'app.' + tab.replaceAll('_', '.');
    copyData(tab, modelName);
  });
}
