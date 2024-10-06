

-- get table comments as markdown


select '| 分类  | 表名                                  | 描述                 |','','','','','',''
UNION
SELECT '| ----- | ------------------------------------- | -------------------- |','','','','','',''
UNION

SELECT 
'|',
-- 	SUBSTRING(table_name,5,3),
	 'yshop',
	'|',
    CONCAT('app_',table_name) as table_name, 
    '|',
    table_comment,
    '|'
FROM 
    information_schema.tables
WHERE 
    table_schema = 'crm' and table_comment <> '' order by 'table_name'

