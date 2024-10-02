import { Exception } from '@yao/yao';

// 还存在问题。请参考：
// https://github.com/zackyang000/node-odata/tree/master

const convertToOperator = (odataOperator: string) => {
  let operator: string;
  switch (odataOperator) {
    case 'eq':
      operator = '==';
      break;
    case 'ne':
      operator = '!=';
      break;
    case 'gt':
      operator = '>';
      break;
    case 'ge':
      operator = '>=';
      break;
    case 'lt':
      operator = '<';
      break;
    case 'le':
      operator = '<=';
      break;
    default:
      throw new Exception(
        'Invalid operator code, expected one of ["==", "!=", ">", ">=", "<", "<="].'
      );
  }
  return operator;
};

// contains(CompanyName,'icrosoft')
export const contains = (
  query: { $where: (arg0: string) => void },
  fnKey: string
) => {
  let [key, target] = fnKey
    .substring(fnKey.indexOf('(') + 1, fnKey.indexOf(')'))
    .split(',');
  [key, target] = [key.trim(), target.trim()];
  query.$where(`this.${key}.indexOf(${target}) != -1`);
};

// indexof(CompanyName,'X') eq 1
export const indexof = (
  query: { $where: (arg0: string) => void },
  fnKey: string,
  odataOperator: string,
  value: any
) => {
  let [key, target] = fnKey
    .substring(fnKey.indexOf('(') + 1, fnKey.indexOf(')'))
    .split(',');
  [key, target] = [key.trim(), target.trim()];
  const operator = convertToOperator(odataOperator);
  query.$where(`this.${key}.indexOf(${target}) ${operator} ${value}`);
};

// year(publish_date) eq 2000
export const year = (
  query: {
    where: (arg0: any) => {
      (): any;
      new (): any;
      gte: {
        (arg0: Date): {
          (): any;
          new (): any;
          lt: { (arg0: Date): void; new (): any };
        };
        new (): any;
      };
      lt: { (arg0: Date): void; new (): any };
    };
    or: (arg0: {}[]) => void;
  },
  fnKey: string,
  odataOperator: string,
  value: string | number
) => {
  const key = fnKey.substring(fnKey.indexOf('(') + 1, fnKey.indexOf(')'));

  const start = new Date(+value, 0, 1);
  const end = new Date(+value + 1, 0, 1);

  switch (odataOperator) {
    case 'eq':
      query.where(key).gte(start).lt(end);
      break;
    case 'ne': {
      const condition = [{}, {}];
      condition[0][key] = { $lt: start };
      condition[1][key] = { $gte: end };
      query.or(condition);
      break;
    }
    case 'gt':
      query.where(key).gte(end);
      break;
    case 'ge':
      query.where(key).gte(start);
      break;
    case 'lt':
      query.where(key).lt(start);
      break;
    case 'le':
      query.where(key).lt(end);
      break;
    default:
      throw new Exception(
        'Invalid operator code, expected one of ["==", "!=", ">", ">=", "<", "<="].'
      );
  }
};

export default { indexof, year, contains };
// module.exports = { indexof, year, contains };
