import { OdataModelColumnMap, OdataModelMap } from './model';

type FunSetValue = (name: string, value: any) => void;

/**
 * 根据yao模型字段信息，获取edm模型字段的类型定义
 * @param {object} column
 * @returns
 */
export function getEdmType(typeIn) {
  const newColumn = {} as { type: string; format: string };
  const type = typeIn.toUpperCase();
  switch (type) {
    case 'STRING':
    case 'CHAR':
      newColumn.type = 'Edm.String';
      break;
    case 'TEXT':
    case 'MEDIUMTEXT':
    case 'LONGTEXT':
      newColumn.type = 'Edm.String';
      break;
    case 'JSON':
    case 'JSONB':
      newColumn.type = 'Edm.String';
      break;
    case 'DATE':
      newColumn.type = 'Edm.DateTime';
      break;
    case 'DATETIME':
      newColumn.type = 'Edm.DateTime';
      break;
    case 'DATETIMETZ':
      newColumn.type = 'Edm.DateTime';
      break;
    case 'TIME':
      newColumn.type = 'Edm.Time';
      newColumn.format = 'HH:mm:ss';
      break;
    case 'TIMETZ':
      newColumn.type = 'Edm.Time';
      newColumn.format = 'HH:mm:ssZ';
      break;
    case 'TIMESTAMP':
    case 'TIMESTAMPTZ':
      newColumn.type = 'Edm.DateTime';
      break;
    case 'TINYINTEGER':
    case 'SMALLINTEGER':
    case 'INTEGER':
    case 'BITINT':
    case 'BIGINTEGER':
      newColumn.type = 'Edm.Int32';
      break;
    case 'UNSIGNEDTINYINTEGER':
    case 'UNSIGNEDSMALLINTEGER':
    case 'UNSIGNEDINTEGER':
      newColumn.type = 'Edm.Int32';
      break;
    case 'UNSIGNEDBIGINTEGER':
      newColumn.type = 'Edm.Int64';
      break;
    case 'ID':
    case 'TINYINCREMENTS':
    case 'SMALLINCREMENTS':
    case 'INCREMENTS':
      // 自增长的类型不应该手工输入
      newColumn.type = 'Edm.Int32';
      break;
    case 'BIGINCREMENTS':
      newColumn.type = 'Edm.Int64';
      break;
    case 'FLOAT':
    case 'DOUBLE':
      newColumn.type = 'Edm.Double';
      break;
    case 'DEMICAL':
      newColumn.type = 'Edm.Decimal';
      break;
    case 'UNSIGNEDFLOAT':
    case 'UNSIGNEDDOUBLE':
    case 'UNSIGNEDDECIMAL':
      newColumn.type = 'Edm.Decimal';
      break;
    case 'BOOLEAN':
      newColumn.type = 'Edm.Boolean';
      break;
    case 'UUID':
      newColumn.type = 'Edm.Guid';
      break;
    default:
      newColumn.type = 'Edm.String';
      break;
  }
  return newColumn.type;
}

export class Metadata {
  models: OdataModelMap;
  private _count: number;
  constructor(models: OdataModelMap) {
    this.models = models;
  }

  visitProperty(node, root: FunSetValue) {
    const result = {} as { $Collection: boolean; $Type: string };

    const type = node.type.toUpperCase();

    switch (type) {
      case 'Array': // node.path = p1; node.schema.paths
        result.$Collection = true;
        if (node.schema && node.schema.paths) {
          this._count += 1;
          const notClassifiedName = `${node.path}Child${this._count}`;
          // Array of complex type
          result.$Type = `OdataService.${notClassifiedName}`;
          root(
            notClassifiedName,
            this.visitor('ComplexType', node.schema.paths, root)
          );
        } else {
          const arrayItemType = this.visitor(
            'Property',
            { instance: node.options.type[0].name },
            root
          );

          result.$Type = arrayItemType.$Type;
        }
        break;
      default:
        result.$Type = getEdmType(node.type);

        return result;
    }

    return result;
  }

  visitEntityType(node: OdataModelColumnMap, root: FunSetValue) {
    const properties = Object.keys(node)
      .filter((path) => path !== 'id')
      .reduce((previousProperty, curentProperty) => {
        const result = {
          ...previousProperty,
          [curentProperty]: this.visitor('Property', node[curentProperty], root)
        };

        return result;
      }, {});

    return {
      $Kind: 'EntityType',
      $Key: ['id'],
      id: {
        $Type: 'Edm.Int32',
        $Nullable: false
      },
      ...properties
    };
  }

  visitComplexType(node, root: FunSetValue) {
    const properties = Object.keys(node)
      .filter((item) => item !== 'id')
      .reduce((previousProperty, curentProperty) => {
        const result = {
          ...previousProperty,
          [curentProperty]: this.visitor('Property', node[curentProperty], root)
        };

        return result;
      }, {});

    return {
      $Kind: 'ComplexType',
      ...properties
    };
  }

  static visitAction(node) {
    return {
      $Kind: 'Action',
      $IsBound: true,
      $Parameter: [
        {
          $Name: node.resource,
          $Type: `OdataService.${node.resource}`,
          $Collection: node.binding === 'collection' ? true : undefined
        }
      ]
    };
  }

  static visitFunction(node) {
    return {
      $Kind: 'Function',
      ...node.params
    };
  }

  visitor(type: string, node: any, root: FunSetValue) {
    switch (type) {
      case 'Property':
        return this.visitProperty(node, root);

      case 'ComplexType':
        return this.visitComplexType(node, root);

      case 'Action':
        return Metadata.visitAction(node);

      case 'Function':
        return Metadata.visitFunction(node);

      default:
        return this.visitEntityType(node, root);
    }
  }

  // 入口
  ctrl() {
    const entityTypeNames = Object.keys(this.models);
    const entityTypes = entityTypeNames.reduce(
      (previousResource, currentResource) => {
        const resource = this.models[currentResource];
        const result = { ...previousResource };
        const attachToRoot = (name: string, value: any) => {
          result[name] = value;
        };

        // if (resource instanceof Resource) {
        const { columns } = resource;

        result[currentResource] = this.visitor(
          'EntityType',
          columns,
          attachToRoot
        );
        if (resource.actions) {
          const actions = Object.keys(resource.actions);
          if (actions && actions.length) {
            actions.forEach((action) => {
              result[action] = this.visitor(
                'Action',
                resource.actions[action],
                attachToRoot
              );
            });
          }
        }

        // } else {
        //   result[currentResource] = this.visitor(
        //     "Function",
        //     resource,
        //     attachToRoot
        //   );
        // }

        return result;
      },
      {}
    );

    const entitySetNames = Object.keys(this.models);
    const entitySets = entitySetNames.reduce(
      (previousResource, currentResource) => {
        const result = { ...previousResource };
        result[currentResource] =
          //   this.models[currentResource] instanceof Resource
          //     ?
          {
            $Collection: true,
            $Type: `OdataService.${currentResource}`
          };
        // : {
        //     $Function: `OdataService.${currentResource}`,
        //   };

        return result;
      },
      {}
    );

    // 创建document

    const document = {
      $Version: '1.0',
      //   ObjectId: {
      //     $Kind: "TypeDefinition",
      //     $UnderlyingType: "Edm.String",
      //     $MaxLength: 24,
      //   },
      ...entityTypes,
      $EntityContainer: 'OdataService',
      ['OdataService']: {
        $Kind: 'EntityContainer',
        ...entitySets
      }
    };

    return document;
  }
}

// module.exports = { Metadata, getEdmType };
