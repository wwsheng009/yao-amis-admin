const models = [
  {
    name: 'admin',
    children: [
      {
        name: 'user.mod.json',
        data: {
          DSL: 'models/admin/user.mod.json',
          ID: 'admin.user',
          columns: [
            {
              label: 'ID',
              name: 'id',
              type: 'ID'
            },
            {
              label: '类型',
              name: 'type',
              type: 'enum',
              comment:
                '账号类型 admin 管理员, staff 员工, user 用户, robot 机器人',
              option: ['admin', 'staff', 'user', 'robot'],
              default: 'user',
              validations: [
                {
                  method: 'typeof',
                  args: ['string'],
                  message: '{{input}}类型错误, {{label}}应该为字符串'
                },
                {
                  method: 'enum',
                  args: ['admin', 'staff', 'user', 'robot'],
                  message:
                    '{{input}}不在许可范围, {{label}}应该为 admin/staff/user/robot'
                }
              ]
            },
            {
              label: '邮箱',
              name: 'email',
              type: 'string',
              comment: '邮箱',
              length: 50,
              nullable: true,
              validations: [
                {
                  method: 'typeof',
                  args: ['string'],
                  message: '{{input}}类型错误, {{label}}应该为字符串'
                },
                {
                  method: 'email',
                  message: '{{input}}不是邮箱地址'
                }
              ]
            },
            {
              label: '手机号',
              name: 'mobile',
              type: 'string',
              comment: '手机号',
              length: 50,
              nullable: true,
              validations: [
                {
                  method: 'mobile',
                  message: '{{input}}格式错误'
                }
              ]
            },
            {
              label: '登录密码',
              name: 'password',
              type: 'string',
              comment: '登录密码',
              length: 256,
              nullable: true,
              crypt: 'PASSWORD',
              validations: [
                {
                  method: 'typeof',
                  args: ['string'],
                  message: '{{input}}类型错误, {{label}}应该为字符串'
                },
                {
                  method: 'minLength',
                  args: [6],
                  message: '{{label}}应该由6-18位，大小写字母、数字和符号构成'
                },
                {
                  method: 'maxLength',
                  args: [18],
                  message: '{{label}}应该由6-18位，大小写字母、数字和符号构成'
                },
                {
                  method: 'pattern',
                  args: ['[0-9]+'],
                  message: '{{label}}应该至少包含一个数字'
                },
                {
                  method: 'pattern',
                  args: ['[A-Z]+'],
                  message: '{{label}}应该至少包含一个大写字母'
                },
                {
                  method: 'pattern',
                  args: ['[a-z]+'],
                  message: '{{label}}应该至少包含一个小写字母'
                },
                {
                  method: 'pattern',
                  args: ['[@#$&*\\+]+'],
                  message: '{{label}}应该至少包含一个符号'
                }
              ]
            },
            {
              label: '操作密码',
              name: 'password2nd',
              type: 'string',
              comment: '操作密码',
              length: 256,
              nullable: true,
              crypt: 'PASSWORD',
              validations: [
                {
                  method: 'typeof',
                  args: ['string'],
                  message: '{{input}}类型错误, {{label}}应该为字符串'
                },
                {
                  method: 'minLength',
                  args: [6],
                  message: '{{label}}应该由6-18位，大小写字母、数字和符号构成'
                },
                {
                  method: 'maxLength',
                  args: [18],
                  message: '{{label}}应该由6-18位，大小写字母、数字和符号构成'
                },
                {
                  method: 'pattern',
                  args: ['[0-9]+'],
                  message: '{{label}}应该至少包含一个数字'
                },
                {
                  method: 'pattern',
                  args: ['[A-Z]+'],
                  message: '{{label}}应该至少包含一个大写字母'
                },
                {
                  method: 'pattern',
                  args: ['[a-z]+'],
                  message: '{{label}}应该至少包含一个小写字母'
                },
                {
                  method: 'pattern',
                  args: ['[@#$&*\\+]+'],
                  message: '{{label}}应该至少包含一个符号'
                }
              ]
            },
            {
              label: '姓名',
              name: 'name',
              type: 'string',
              comment: '姓名',
              length: 80,
              nullable: true,
              validations: [
                {
                  method: 'typeof',
                  args: ['string'],
                  message: '{{input}}类型错误, {{label}}应该为字符串'
                },
                {
                  method: 'minLength',
                  args: [2],
                  message: '{{label}}至少需要2个字'
                },
                {
                  method: 'maxLength',
                  args: [40],
                  message: '{{label}}不能超过20个字'
                }
              ],
              index: true
            },
            {
              label: '身份证号码',
              name: 'idcard',
              type: 'string',
              comment: '身份证号码',
              length: 256,
              nullable: true,
              crypt: 'AES',
              validations: [
                {
                  method: 'typeof',
                  args: ['string'],
                  message: '{{input}}类型错误, {{label}}应该为字符串'
                },
                {
                  method: 'pattern',
                  args: ['^(\\d{18})|(\\d{14}X)$'],
                  message: '{{label}}格式错误'
                }
              ]
            },
            {
              label: 'API Key',
              name: 'key',
              type: 'string',
              comment: 'API Key',
              length: 256,
              nullable: true,
              validations: [
                {
                  method: 'typeof',
                  args: ['string'],
                  message: '{{input}}类型错误, {{label}}应该为数字'
                },
                {
                  method: 'pattern',
                  args: ['^[0-9]{10}$'],
                  message: ' {{label}}应该由10位数字构成'
                }
              ]
            },
            {
              label: 'API 密钥',
              name: 'secret',
              type: 'string',
              comment: 'API 密钥',
              length: 256,
              nullable: true,
              crypt: 'AES',
              validations: [
                {
                  method: 'typeof',
                  args: ['string'],
                  message: '{{input}}类型错误, {{label}}应该为字符串'
                },
                {
                  method: 'pattern',
                  args: ['^[0-9A-Za-z@#$&*]{32}$'],
                  message: '{{label}}应该由32位，大小写字母、数字和符号构成'
                }
              ]
            },
            {
              label: '扩展信息',
              name: 'extra',
              type: 'json',
              comment: '扩展信息',
              nullable: true
            },
            {
              label: '状态',
              name: 'status',
              type: 'enum',
              comment: '用户状态 enabled 有效, disabled 无效',
              option: ['enabled', 'disabled'],
              default: 'enabled',
              validations: [
                {
                  method: 'typeof',
                  args: ['string'],
                  message: '{{input}}类型错误, {{label}}应该为字符串'
                },
                {
                  method: 'enum',
                  args: ['enabled', 'disabled'],
                  message:
                    '{{input}}不在许可范围, {{label}}应该为 enabled/disabled'
                }
              ]
            },
            {
              label: '::Delete At',
              name: 'deleted_at',
              type: 'timestamp',
              comment: '::Delete At',
              nullable: true
            },
            {
              label: '::Created At',
              name: 'created_at',
              type: 'timestamp',
              comment: '::Created At',
              nullable: true
            },
            {
              label: '::Updated At',
              name: 'updated_at',
              type: 'timestamp',
              comment: '::Updated At',
              nullable: true
            }
          ],
          connector: '',
          indexes: null,
          option: {
            timestamps: true,
            soft_deletes: true
          },
          relations: {},
          table: {
            name: 'admin_user',
            comment: '用户表',
            engine: 'InnoDB',
            collation: '',
            charset: '',
            primarykeys: null
          },
          values: [
            {
              email: 'xiang@iqka.com',
              extra: {
                sex: '男'
              },
              key: '8304925176',
              mobile: null,
              name: '管理员',
              password: 'A123456p+',
              secret: 'XMTdNRVigbgUiAPdiJCfaWgWcz2PaQXw',
              status: 'enabled',
              type: 'admin'
            },
            {
              email: 'staff@iqka.com',
              extra: {
                sex: '女'
              },
              key: null,
              mobile: null,
              name: '员工',
              password: 'S123456p+',
              secret: null,
              status: 'enabled',
              type: 'staff'
            },
            {
              email: null,
              extra: {
                sex: '女'
              },
              key: null,
              mobile: '13900001111',
              name: '用户',
              password: 'U123456p+',
              secret: null,
              status: 'enabled',
              type: 'user'
            },
            {
              email: null,
              extra: {
                sex: '女'
              },
              key: '3845196072',
              mobile: null,
              name: '机器人',
              password: null,
              secret: 'wBeYjL7FjbcvpAdBrxtDFfjydsoPKhRN',
              status: 'enabled',
              type: 'robot'
            }
          ]
        }
      }
    ]
  },
  {
    name: 'ddic',
    children: [
      {
        name: 'model',
        children: [
          {
            name: 'column.mod.json',
            data: {
              DSL: 'models/ddic/model/column.mod.json',
              ID: 'ddic.model.column',
              columns: [
                {
                  label: 'ID',
                  name: 'id',
                  type: 'ID',
                  comment: 'ID'
                },
                {
                  label: '所属模型',
                  name: 'model_id',
                  type: 'integer',
                  comment: '所属模型'
                },
                {
                  label: '字段名称',
                  name: 'name',
                  type: 'string',
                  comment: '字段名称',
                  length: 80,
                  validations: [
                    {
                      method: 'pattern',
                      args: ['^[a-zA-Z_][a-zA-Z0-9_]*$'],
                      message: '只允许数字与字母，下划线，划线'
                    }
                  ]
                },
                {
                  label: '标签',
                  name: 'label',
                  type: 'string',
                  comment: '标签',
                  length: 80
                },
                {
                  label: '是否索引',
                  name: 'index',
                  type: 'boolean',
                  comment: '是否索引',
                  default: false
                },
                {
                  label: '唯一索引',
                  name: 'unique',
                  type: 'boolean',
                  comment: '唯一索引',
                  default: false
                },
                {
                  label: '数据元素',
                  name: 'element_id',
                  type: 'integer',
                  comment: '数据元素',
                  nullable: true
                },
                {
                  label: '数据类型',
                  name: 'type',
                  type: 'string',
                  comment: '数据类型',
                  nullable: true
                },
                {
                  label: '长度',
                  name: 'length',
                  type: 'integer',
                  comment: '长度',
                  nullable: true
                },
                {
                  label: '位数(含小数位)',
                  name: 'precision',
                  type: 'integer',
                  comment: '字段位数(含小数位)',
                  nullable: true
                },
                {
                  label: '小数位',
                  name: 'scale',
                  type: 'integer',
                  comment: '小数位数',
                  nullable: true
                },
                {
                  label: '允许空值',
                  name: 'nullable',
                  type: 'boolean',
                  comment: '允许空值',
                  default: false
                },
                {
                  label: '加密方式',
                  name: 'crypt',
                  type: 'enum',
                  comment: '加密方式',
                  nullable: true,
                  option: ['PASSWORD', 'AES']
                },
                {
                  label: '默认值',
                  name: 'default',
                  type: 'string',
                  comment: '默认值',
                  nullable: true
                },
                {
                  label: '可选项',
                  name: 'options',
                  type: 'json',
                  comment: '可选项',
                  nullable: true
                },
                {
                  label: '校验规则',
                  name: 'validations',
                  type: 'json',
                  comment: '校验规则',
                  nullable: true
                },
                {
                  label: '注释',
                  name: 'comment',
                  type: 'string',
                  comment: '注释',
                  length: 200,
                  nullable: true
                }
              ],
              connector: '',
              indexes: null,
              option: {},
              relations: {
                model: {
                  type: 'hasOne',
                  key: 'id',
                  model: 'ddic.model',
                  foreign: 'model_id',
                  query: {}
                }
              },
              table: {
                name: 'ddic_model_column',
                comment: '模型字段列表',
                collation: '',
                charset: '',
                primarykeys: null
              },
              values: null
            }
          }
        ]
      },
      {
        name: 'model.mod.json',
        data: {
          DSL: 'models/ddic/model.mod.json',
          ID: 'ddic.model',
          columns: [
            {
              label: 'ID',
              name: 'id',
              type: 'ID',
              comment: 'ID'
            },
            {
              label: '模型标识',
              name: 'identity',
              type: 'string',
              comment: '模型标识',
              length: 64,
              validations: [
                {
                  method: 'maxLength',
                  args: [64],
                  message: '{{label}}最大长度64'
                },
                {
                  method: 'pattern',
                  args: ['^[a-zA-Z.][a-zA-Z0-9.]*$'],
                  message: '{{label}}只允许数字与字母，点号'
                }
              ],
              index: true,
              unique: true
            },
            {
              label: '名称',
              name: 'name',
              type: 'string',
              comment: '名称',
              index: true
            },
            {
              label: '备注',
              name: 'comment',
              type: 'string',
              comment: '备注',
              nullable: true
            },
            {
              label: '数据库表名',
              name: 'table_name',
              type: 'string',
              comment: '数据库表名',
              length: 64,
              validations: [
                {
                  method: 'maxLength',
                  args: [64],
                  message: '{{label}}最大长度64'
                },
                {
                  method: 'pattern',
                  args: ['^[a-zA-Z_][a-zA-Z0-9_]*$'],
                  message: '{{label}}只允许数字与字母，下划线，划线'
                }
              ]
            },
            {
              label: '数据库表备注',
              name: 'table_comment',
              type: 'string',
              comment: '数据库表备注',
              length: 100,
              nullable: true
            },
            {
              label: '软删除',
              name: 'soft_deletes',
              type: 'boolean',
              comment: '软删除，不直接删除',
              default: true
            },
            {
              label: '时间戳',
              name: 'timestamps',
              type: 'boolean',
              comment: '增加创建，更新时间戳',
              default: true
            },
            {
              label: '只读',
              name: 'read_only',
              type: 'boolean',
              comment: '只读，忽略迁移操作',
              default: true
            },
            {
              label: '关联关系',
              name: 'relations',
              type: 'json',
              comment: '关联关系',
              nullable: true
            }
          ],
          connector: '',
          indexes: null,
          option: {},
          relations: {
            columns: {
              type: 'hasMany',
              key: 'model_id',
              model: 'ddic.model.column',
              foreign: 'id',
              query: {}
            }
          },
          table: {
            name: 'ddic_model',
            comment: '业务模型',
            collation: '',
            charset: '',
            primarykeys: null
          },
          values: null
        }
      }
    ]
  },
  {
    name: 'demo',
    children: [
      {
        name: 'excel.mod.json',
        data: {
          DSL: 'models/demo/excel.mod.json',
          ID: 'demo.excel',
          columns: [
            {
              label: 'ID',
              name: 'id',
              type: 'id'
            },
            {
              label: 'number',
              name: 'number',
              type: 'integer'
            },
            {
              label: '时间',
              name: 'time',
              type: 'datetime'
            }
          ],
          connector: '',
          indexes: null,
          option: {},
          relations: null,
          table: {
            name: 'demo_excel',
            collation: '',
            charset: '',
            primarykeys: null
          },
          values: null
        }
      },
      {
        name: 'table.mod.json',
        data: {
          DSL: 'models/demo/table.mod.json',
          ID: 'demo.table',
          columns: [
            {
              label: 'ID',
              name: 'id',
              type: 'ID'
            },
            {
              label: '引擎',
              name: 'engine',
              type: 'string'
            },
            {
              label: '浏览器',
              name: 'browser',
              type: 'string'
            },
            {
              label: '操作系统',
              name: 'platform',
              type: 'string'
            },
            {
              label: '版本',
              name: 'version',
              type: 'string'
            },
            {
              label: '级别',
              name: 'grade',
              type: 'string'
            }
          ],
          connector: '',
          indexes: null,
          option: {},
          relations: null,
          table: {
            name: 'demo_table',
            comment: '演示表',
            engine: 'InnoDB',
            collation: '',
            charset: '',
            primarykeys: null
          },
          values: [
            {
              browser: 'Internet Explorer 4.0',
              engine: 'Trident',
              grade: 'X',
              platform: 'Win 95+',
              version: '4'
            },
            {
              browser: 'Internet Explorer 5.0',
              engine: 'Trident',
              grade: 'C',
              platform: 'Win 95+',
              version: '5'
            },
            {
              browser: 'Internet Explorer 5.5',
              engine: 'Trident',
              grade: 'A',
              platform: 'Win 95+',
              version: '5.5'
            },
            {
              browser: 'Internet Explorer 6',
              engine: 'Trident',
              grade: 'A',
              platform: 'Win 98+',
              version: '6'
            },
            {
              browser: 'Internet Explorer 7',
              engine: 'Trident',
              grade: 'A',
              platform: 'Win XP SP2+',
              version: '7'
            },
            {
              browser: 'AOL browser (AOL desktop)',
              engine: 'Trident',
              grade: 'A',
              platform: 'Win XP',
              version: '6'
            },
            {
              browser: 'Firefox 1.0',
              engine: 'Gecko',
              grade: 'A',
              platform: 'Win 98+ / OSX.2+',
              version: '1.7'
            },
            {
              browser: 'Firefox 1.5',
              engine: 'Gecko',
              grade: 'A',
              platform: 'Win 98+ / OSX.2+',
              version: '1.8'
            },
            {
              browser: 'Firefox 2.0',
              engine: 'Gecko',
              grade: 'A',
              platform: 'Win 98+ / OSX.2+',
              version: '1.8'
            },
            {
              browser: 'Firefox 3.0',
              engine: 'Gecko',
              grade: 'A',
              platform: 'Win 2k+ / OSX.3+',
              version: '1.9'
            },
            {
              browser: 'Camino 1.0',
              engine: 'Gecko',
              grade: 'A',
              platform: 'OSX.2+',
              version: '1.8'
            },
            {
              browser: 'Camino 1.5',
              engine: 'Gecko',
              grade: 'A',
              platform: 'OSX.3+',
              version: '1.8'
            },
            {
              browser: 'Netscape 7.2',
              engine: 'Gecko',
              grade: 'A',
              platform: 'Win 95+ / Mac OS 8.6-9.2',
              version: '1.7'
            },
            {
              browser: 'Netscape Browser 8',
              engine: 'Gecko',
              grade: 'A',
              platform: 'Win 98SE+',
              version: '1.7'
            },
            {
              browser: 'Netscape Navigator 9',
              engine: 'Gecko',
              grade: 'A',
              platform: 'Win 98+ / OSX.2+',
              version: '1.8'
            },
            {
              browser: 'Mozilla 1.0',
              engine: 'Gecko',
              grade: 'A',
              platform: 'Win 95+ / OSX.1+',
              version: '1'
            },
            {
              browser: 'Mozilla 1.1',
              engine: 'Gecko',
              grade: 'A',
              platform: 'Win 95+ / OSX.1+',
              version: '1.1'
            },
            {
              browser: 'Mozilla 1.2',
              engine: 'Gecko',
              grade: 'A',
              platform: 'Win 95+ / OSX.1+',
              version: '1.2'
            },
            {
              browser: 'Mozilla 1.3',
              engine: 'Gecko',
              grade: 'A',
              platform: 'Win 95+ / OSX.1+',
              version: '1.3'
            },
            {
              browser: 'Mozilla 1.4',
              engine: 'Gecko',
              grade: 'A',
              platform: 'Win 95+ / OSX.1+',
              version: '1.4'
            },
            {
              browser: 'Mozilla 1.5',
              engine: 'Gecko',
              grade: 'A',
              platform: 'Win 95+ / OSX.1+',
              version: '1.5'
            },
            {
              browser: 'Mozilla 1.6',
              engine: 'Gecko',
              grade: 'A',
              platform: 'Win 95+ / OSX.1+',
              version: '1.6'
            },
            {
              browser: 'Mozilla 1.7',
              engine: 'Gecko',
              grade: 'A',
              platform: 'Win 98+ / OSX.1+',
              version: '1.7'
            },
            {
              browser: 'Mozilla 1.8',
              engine: 'Gecko',
              grade: 'A',
              platform: 'Win 98+ / OSX.1+',
              version: '1.8'
            },
            {
              browser: 'Seamonkey 1.1',
              engine: 'Gecko',
              grade: 'A',
              platform: 'Win 98+ / OSX.2+',
              version: '1.8'
            },
            {
              browser: 'Epiphany 2.20',
              engine: 'Gecko',
              grade: 'A',
              platform: 'Gnome',
              version: '1.8'
            },
            {
              browser: 'Safari 1.2',
              engine: 'Webkit',
              grade: 'A',
              platform: 'OSX.3',
              version: '125.5'
            },
            {
              browser: 'Safari 1.3',
              engine: 'Webkit',
              grade: 'A',
              platform: 'OSX.3',
              version: '312.8'
            },
            {
              browser: 'Safari 2.0',
              engine: 'Webkit',
              grade: 'A',
              platform: 'OSX.4+',
              version: '419.3'
            },
            {
              browser: 'Safari 3.0',
              engine: 'Webkit',
              grade: 'A',
              platform: 'OSX.4+',
              version: '522.1'
            },
            {
              browser: 'OmniWeb 5.5',
              engine: 'Webkit',
              grade: 'A',
              platform: 'OSX.4+',
              version: '420'
            },
            {
              browser: 'iPod Touch / iPhone',
              engine: 'Webkit',
              grade: 'A',
              platform: 'iPod',
              version: '420.1'
            },
            {
              browser: 'S60',
              engine: 'Webkit',
              grade: 'A',
              platform: 'S60',
              version: '413'
            },
            {
              browser: 'Opera 7.0',
              engine: 'Presto',
              grade: 'A',
              platform: 'Win 95+ / OSX.1+',
              version: '-'
            },
            {
              browser: 'Opera 7.5',
              engine: 'Presto',
              grade: 'A',
              platform: 'Win 95+ / OSX.2+',
              version: '-'
            },
            {
              browser: 'Opera 8.0',
              engine: 'Presto',
              grade: 'A',
              platform: 'Win 95+ / OSX.2+',
              version: '-'
            },
            {
              browser: 'Opera 8.5',
              engine: 'Presto',
              grade: 'A',
              platform: 'Win 95+ / OSX.2+',
              version: '-'
            },
            {
              browser: 'Opera 9.0',
              engine: 'Presto',
              grade: 'A',
              platform: 'Win 95+ / OSX.3+',
              version: '-'
            },
            {
              browser: 'Opera 9.2',
              engine: 'Presto',
              grade: 'A',
              platform: 'Win 88+ / OSX.3+',
              version: '-'
            },
            {
              browser: 'Opera 9.5',
              engine: 'Presto',
              grade: 'A',
              platform: 'Win 88+ / OSX.3+',
              version: '-'
            },
            {
              browser: 'Opera for Wii',
              engine: 'Presto',
              grade: 'A',
              platform: 'Wii',
              version: '-'
            },
            {
              browser: 'Nokia N800',
              engine: 'Presto',
              grade: 'A',
              platform: 'N800',
              version: '-'
            },
            {
              browser: 'Nintendo DS browser',
              engine: 'Presto',
              grade: 'C',
              platform: 'Nintendo DS',
              version: '8.5'
            },
            {
              browser: 'Konqureror 3.1',
              engine: 'KHTML',
              grade: 'C',
              platform: 'KDE 3.1',
              version: '3.1'
            },
            {
              browser: 'Konqureror 3.3',
              engine: 'KHTML',
              grade: 'A',
              platform: 'KDE 3.3',
              version: '3.3'
            },
            {
              browser: 'Konqureror 3.5',
              engine: 'KHTML',
              grade: 'A',
              platform: 'KDE 3.5',
              version: '3.5'
            },
            {
              browser: 'Internet Explorer 4.5',
              engine: 'Tasman',
              grade: 'X',
              platform: 'Mac OS 8-9',
              version: '-'
            },
            {
              browser: 'Internet Explorer 5.1',
              engine: 'Tasman',
              grade: 'C',
              platform: 'Mac OS 7.6-9',
              version: '1'
            },
            {
              browser: 'Internet Explorer 5.2',
              engine: 'Tasman',
              grade: 'C',
              platform: 'Mac OS 8-X',
              version: '1'
            },
            {
              browser: 'NetFront 3.1',
              engine: 'Misc',
              grade: 'C',
              platform: 'Embedded devices',
              version: '-'
            },
            {
              browser: 'NetFront 3.4',
              engine: 'Misc',
              grade: 'A',
              platform: 'Embedded devices',
              version: '-'
            },
            {
              browser: 'Dillo 0.8',
              engine: 'Misc',
              grade: 'X',
              platform: 'Embedded devices',
              version: '-'
            },
            {
              browser: 'Links',
              engine: 'Misc',
              grade: 'X',
              platform: 'Text only',
              version: '-'
            },
            {
              browser: 'Lynx',
              engine: 'Misc',
              grade: 'X',
              platform: 'Text only',
              version: '-'
            },
            {
              browser: 'IE Mobile',
              engine: 'Misc',
              grade: 'C',
              platform: 'Windows Mobile 6',
              version: '-'
            },
            {
              browser: 'PSP browser',
              engine: 'Misc',
              grade: 'C',
              platform: 'PSP',
              version: '-'
            },
            {
              browser: 'All others',
              engine: 'Other browsers',
              grade: 'U',
              platform: '-',
              version: '-'
            }
          ]
        }
      }
    ]
  },
  {
    name: 'app',
    children: [
      {
        name: 'amis.mod.json',
        data: {
          DSL: 'models/dsl/amis.mod.json',
          ID: 'system.amis',
          columns: [
            {
              label: '标识',
              name: 'id',
              type: 'ID'
            },
            {
              label: '文件名',
              name: 'file',
              type: 'string'
            },
            {
              label: '源代码',
              name: 'source',
              type: 'json'
            },
            {
              label: '失效时间',
              name: 'expired_at',
              type: 'timestamp'
            },
            {
              label: '::Created At',
              name: 'created_at',
              type: 'timestamp',
              comment: '::Created At',
              nullable: true
            },
            {
              label: '::Updated At',
              name: 'updated_at',
              type: 'timestamp',
              comment: '::Updated At',
              nullable: true
            }
          ],
          connector: '',
          indexes: null,
          option: {
            timestamps: true
          },
          relations: null,
          table: {
            name: 'dsl_amis',
            collation: '',
            charset: '',
            primarykeys: null
          },
          values: null
        }
      }
    ]
  },
  {
    name: 'plan.mod.json',
    data: {
      DSL: 'models/plan.mod.json',
      ID: 'plan',
      columns: [
        {
          label: 'ID',
          name: 'id',
          type: 'ID'
        },
        {
          label: '名称',
          name: 'name',
          type: 'string',
          comment: '名称',
          length: 40,
          unique: true
        },
        {
          label: '开始时间',
          name: 'start',
          type: 'datetime',
          comment: '开始时间',
          nullable: true,
          index: true
        },
        {
          label: '结束时间',
          name: 'end',
          type: 'datetime',
          comment: '结束时间',
          nullable: true,
          index: true
        },
        {
          label: '编码',
          name: 'plan_sn',
          type: 'string',
          comment: '编码',
          length: 32,
          nullable: true,
          unique: true
        },
        {
          label: '状态',
          name: 'status',
          type: 'enum',
          comment: '状态: 草稿, 进行中, 已完成',
          option: ['draft', 'process', 'finish'],
          default: 'draft',
          index: true
        },
        {
          label: '::Delete At',
          name: 'deleted_at',
          type: 'timestamp',
          comment: '::Delete At',
          nullable: true
        },
        {
          label: '::Created At',
          name: 'created_at',
          type: 'timestamp',
          comment: '::Created At',
          nullable: true
        },
        {
          label: '::Updated At',
          name: 'updated_at',
          type: 'timestamp',
          comment: '::Updated At',
          nullable: true
        }
      ],
      connector: '',
      indexes: null,
      option: {
        timestamps: true,
        soft_deletes: true
      },
      relations: {
        items: {
          type: 'hasMany',
          key: 'plan_id',
          model: 'plan.item',
          foreign: 'id',
          query: {
            select: ['id', 'sku_id', 'amount', 'amount_plan']
          }
        }
      },
      table: {
        name: 'plan',
        comment: '计划',
        collation: '',
        charset: '',
        primarykeys: null
      },
      values: null
    }
  },
  {
    name: 'system',
    children: [
      {
        name: 'api.mod.json',
        data: {
          DSL: 'models/system/api.mod.json',
          ID: 'system.api',
          columns: [
            {
              label: '编号',
              name: 'id',
              type: 'ID',
              comment: '标识'
            },
            {
              label: '名称',
              name: 'name',
              type: 'string',
              comment: '角色名称',
              nullable: true,
              index: true
            },
            {
              label: '描述',
              name: 'description',
              type: 'string',
              comment: '描述',
              nullable: true,
              index: true
            },
            {
              label: '路径',
              name: 'path',
              type: 'string',
              comment: '路径',
              nullable: true,
              index: true
            },
            {
              label: '全路径',
              name: 'fullpath',
              type: 'string',
              comment: '全路径',
              nullable: true,
              index: true
            },
            {
              label: '路由',
              name: 'router',
              type: 'string',
              comment: '路由',
              index: true
            },
            {
              label: '处理器',
              name: 'process',
              type: 'string',
              comment: '处理器',
              index: true
            },
            {
              label: '调用方法',
              name: 'method',
              type: 'string',
              comment: '调用方法',
              nullable: true
            },
            {
              label: '守卫',
              name: 'guard',
              type: 'string',
              comment: '守卫',
              nullable: true
            },
            {
              label: '传入参数',
              name: 'in',
              type: 'json',
              comment: '传入参数',
              nullable: true
            },
            {
              label: '传出参数',
              name: 'out',
              type: 'json',
              comment: '传出参数',
              nullable: true
            },
            {
              label: '参数',
              name: 'url_params',
              type: 'json',
              comment: '参数',
              nullable: true
            },
            {
              label: '::Created At',
              name: 'created_at',
              type: 'timestamp',
              comment: '::Created At',
              nullable: true
            },
            {
              label: '::Updated At',
              name: 'updated_at',
              type: 'timestamp',
              comment: '::Updated At',
              nullable: true
            }
          ],
          connector: '',
          indexes: null,
          option: {
            timestamps: true
          },
          relations: null,
          table: {
            name: 'system_api',
            collation: '',
            charset: '',
            primarykeys: null
          },
          values: null
        }
      },
      {
        name: 'dept.mod.json',
        data: {
          DSL: 'models/system/dept.mod.json',
          ID: 'admin.dept',
          columns: [
            {
              label: '编号',
              name: 'id',
              type: 'ID',
              comment: '编号'
            },
            {
              label: '名称',
              name: 'name',
              type: 'string',
              comment: '名称'
            },
            {
              label: '上级',
              name: 'parent',
              type: 'bigInteger',
              comment: '上级',
              default: 0
            },
            {
              label: '状态',
              name: 'status',
              type: 'boolean',
              comment: '状态',
              default: 1
            },
            {
              label: '::Created At',
              name: 'created_at',
              type: 'timestamp',
              comment: '::Created At',
              nullable: true
            },
            {
              label: '::Updated At',
              name: 'updated_at',
              type: 'timestamp',
              comment: '::Updated At',
              nullable: true
            }
          ],
          connector: '',
          indexes: null,
          option: {
            timestamps: true
          },
          relations: null,
          table: {
            name: 'admin_dept',
            collation: '',
            charset: '',
            primarykeys: null
          },
          values: null
        }
      },
      {
        name: 'font.mod.json',
        data: {
          DSL: 'models/system/font.mod.json',
          ID: 'system.font',
          columns: [
            {
              label: '编号',
              name: 'id',
              type: 'ID',
              comment: '标识'
            },
            {
              label: '名称',
              name: 'name',
              type: 'string',
              comment: '名称',
              index: true
            },
            {
              label: '分类',
              name: 'category',
              type: 'string',
              comment: '分类',
              nullable: true,
              index: true
            },
            {
              label: 'URL地址',
              name: 'url',
              type: 'string',
              comment: 'URL地址',
              nullable: true
            },
            {
              label: '来源',
              name: 'source',
              type: 'string',
              comment: '来源',
              nullable: true
            },
            {
              label: '版本',
              name: 'version',
              type: 'string',
              comment: '版本',
              nullable: true
            },
            {
              label: '::Created At',
              name: 'created_at',
              type: 'timestamp',
              comment: '::Created At',
              nullable: true
            },
            {
              label: '::Updated At',
              name: 'updated_at',
              type: 'timestamp',
              comment: '::Updated At',
              nullable: true
            }
          ],
          connector: '',
          indexes: null,
          option: {
            timestamps: true
          },
          relations: null,
          table: {
            name: 'system_font',
            collation: '',
            charset: '',
            primarykeys: null
          },
          values: null
        }
      },
      {
        name: 'menu.mod.json',
        data: {
          DSL: 'models/system/menu.mod.json',
          ID: 'admin.menu',
          columns: [
            {
              name: 'id',
              type: 'ID',
              comment: 'ID'
            },
            {
              name: 'parent',
              type: 'bigInteger',
              comment: '父节点',
              default: 0,
              index: true
            },
            {
              label: '菜单名称',
              name: 'name',
              type: 'string',
              comment: '菜单名称',
              length: 200,
              index: true
            },
            {
              label: '菜单图标',
              name: 'icon',
              type: 'string',
              comment: '菜单图标',
              length: 200,
              nullable: true
            },
            {
              label: '路由',
              name: 'url',
              type: 'string',
              comment: '路由',
              length: 200,
              nullable: true,
              index: true
            },
            {
              label: '链接',
              name: 'link',
              type: 'string',
              comment: '链接',
              length: 200,
              nullable: true
            },
            {
              label: '重定位',
              name: 'redirect',
              type: 'string',
              comment: '重定位',
              length: 200,
              nullable: true
            },
            {
              label: '重渲染',
              name: 'rewrite',
              type: 'string',
              comment: '重渲染',
              length: 200,
              nullable: true
            },
            {
              label: '默认页面',
              name: 'is_default_page',
              type: 'boolean',
              comment: '默认页面',
              nullable: true,
              default: false
            },
            {
              label: '页面配置',
              name: 'schema',
              type: 'json',
              comment: '页面的配置',
              nullable: true
            },
            {
              label: '配置接口',
              name: 'schema_api',
              type: 'string',
              comment: '配置接口',
              nullable: true
            },
            {
              label: '是否可见',
              name: 'visible',
              type: 'boolean',
              comment: '是否可见',
              default: true
            },
            {
              label: '排列',
              name: 'rank',
              type: 'integer',
              comment: '排列',
              nullable: true,
              default: 9999
            },
            {
              label: '类名',
              name: 'class_name',
              type: 'string',
              comment: '类名',
              nullable: true
            },
            {
              label: '状态',
              name: 'status',
              type: 'enum',
              comment: '状态',
              option: ['enabled', 'disabled'],
              default: 'enabled'
            },
            {
              label: '::Created At',
              name: 'created_at',
              type: 'timestamp',
              comment: '::Created At',
              nullable: true
            },
            {
              label: '::Updated At',
              name: 'updated_at',
              type: 'timestamp',
              comment: '::Updated At',
              nullable: true
            }
          ],
          connector: '',
          indexes: [],
          option: {
            timestamps: true
          },
          relations: {
            children: {
              type: 'hasMany',
              key: 'id',
              model: 'admin.menu',
              foreign: 'parent',
              query: {
                select: [
                  'label',
                  'icon',
                  'url',
                  'schema',
                  'schemaApi',
                  'link',
                  'redirect',
                  'rewrite',
                  'isDefaultPage',
                  'visible',
                  'className'
                ]
              }
            }
          },
          table: {
            name: 'admin_menu',
            comment: '菜单表',
            engine: 'InnoDB',
            collation: '',
            charset: '',
            primarykeys: null
          },
          values: [
            {
              icon: 'icon-activity',
              name: '数据看板',
              rank: 1,
              status: 'enabled',
              url: '/kanban/kanban',
              visible: 1
            },
            {
              icon: 'icon-pie-chart',
              name: '数据分析',
              rank: 2,
              status: 'enabled',
              url: '/chart/compare',
              visible: 1
            },
            {
              icon: 'icon-cloud',
              name: '云服务库',
              rank: 3,
              status: 'enabled',
              url: '/table/service',
              visible: 1
            },
            {
              icon: 'icon-list',
              name: '云服务库',
              parent: 3,
              url: '/table/service',
              visible: 1
            },
            {
              icon: 'icon-plus',
              name: '创建云服务库',
              parent: 3,
              url: '/form/service/0',
              visible: 1
            },
            {
              icon: 'icon-plus',
              name: '云服务库',
              parent: 5,
              url: '/form/service/2',
              visible: 1
            }
          ]
        }
      },
      {
        name: 'role.mod.json',
        data: {
          DSL: 'models/system/role.mod.json',
          ID: 'admin.auth.role',
          columns: [
            {
              label: '编号',
              name: 'id',
              type: 'ID',
              comment: '标识'
            },
            {
              label: '名称',
              name: 'name',
              type: 'string',
              comment: '角色名称',
              index: true
            },
            {
              label: '角色值',
              name: 'value',
              type: 'string',
              comment: '角色值',
              index: true
            },
            {
              label: '菜单',
              name: 'menu',
              type: 'text',
              comment: '菜单'
            },
            {
              label: '状态',
              name: 'status',
              type: 'boolean',
              comment: '状态',
              default: 1
            },
            {
              label: '::Created At',
              name: 'created_at',
              type: 'timestamp',
              comment: '::Created At',
              nullable: true
            },
            {
              label: '::Updated At',
              name: 'updated_at',
              type: 'timestamp',
              comment: '::Updated At',
              nullable: true
            }
          ],
          connector: '',
          indexes: null,
          option: {
            timestamps: true
          },
          relations: null,
          table: {
            name: 'system_role',
            collation: '',
            charset: '',
            primarykeys: null
          },
          values: null
        }
      }
    ]
  }
];

function FilterCachedModelList(attr) {
  const list = [];
  // console.log(models);
  const getProperty = (object, path) => {
    const properties = path.split('.');
    let currentObject = object;

    for (let i = 0; i < properties.length; i++) {
      currentObject = currentObject[properties[i]];
    }
    return currentObject;
  };

  const setProperty = (object, path, value) => {
    const properties = path.split('.');
    let currentObject = object;

    for (let i = 0; i < properties.length - 1; i++) {
      if (currentObject === undefined) {
        throw new Error(
          `Property '${properties[i]}' does not exist in path '${path}'`
        );
      }
      //   注意，不支持生成数组
      if (!Object.prototype.hasOwnProperty.call(currentObject, properties[i])) {
        currentObject[properties[i]] = {};
      }
      currentObject = currentObject[properties[i]];
    }

    currentObject[properties[properties.length - 1]] = value;
  };
  let attr2 = [];
  if (typeof attr === 'string') {
    // 单个属性
    attr2 = attr.split(',');
  }
  const traverse = (node) => {
    if (node.children) {
      traverse(node.children);
    } else if (node.data) {
      if (attr != null) {
        const o = { ID: node.data.ID };
        attr2.forEach((a) => {
          const p = getProperty(node.data, a);
          if (p != null) {
            // o[a] = p;
            setProperty(o, a, p);
          }
        });
        list.push(o);
      } else {
        list.push(node.data);
      }
    } else if (Array.isArray(node)) {
      node.forEach((line) => {
        traverse(line);
      });
    }
  };
  traverse(models);
  return list;
}

// function FindAndLoadYaoModelById(id) {
//   const traverse = (node, id) => {
//     if (node.children) {
//       return traverse(node.children, id);
//     } else if (node.data) {
//       if (node.data.ID == id) {
//         return node.data;
//       }
//     } else if (Array.isArray(node)) {
//       for (const item of node) {
//         const obj = traverse(item, id);
//         if (obj) {
//           return obj;
//         }
//       }
//     }
//   };
//   return traverse(models, id);
// }

// const data = FindAndLoadYaoModelById("system.api");
// console.log(data);
