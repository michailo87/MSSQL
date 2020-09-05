USE [LEMON]
GO

CREATE  PROCEDURE  [prm].[load_etl_log]
AS
declare 
@run_id int
BEGIN

--Если сегодня был запуск очищаем текущюую статистику и перезаливаем
delete from lemon.prm.dwh_size_of_tables where ddate = cast(getdate() as date);

--Для страых периодов  храним только статистику только на начало и на середину месяца
delete from  lemon.prm.dwh_size_of_tables
where (DATEPART(day, ddate)not in (1,15) and ddate < dateadd(month ,-2, getdate())) 

DECLARE @SQL_text varchar(max),@SQL_text_final varchar(max); ;  
set @SQL_text=   '
USE {SCHEMA_FOR_REPLACE};


insert into  lemon.prm.dwh_size_of_tables
SELECT 

	cast(getdate() as date) date_time,
	'''+ convert(nvarchar , @run_id  ) +''' run_id ,
	''{SCHEMA_FOR_REPLACE}'' db_name,
	a3.name AS schema_name
	,--Схема
	a2.name AS table_name
	,--Имя таблицы
	a1.rows AS row_count
	,--Число записей
	(a1.reserved + ISNULL(a4.reserved, 0)) * 8 AS reserved_KB
	,--Зарезервировано (КБ)	
	a1.data * 8 AS data_KB
	,--Данные (КБ)
	(
		CASE 
			WHEN (a1.used + ISNULL(a4.used, 0)) > a1.data
				THEN (a1.used + ISNULL(a4.used, 0)) - a1.data
			ELSE 0
			END
		) * 8 AS index_size_KB
	,--Индексы (КБ)
	(
		CASE 
			WHEN (a1.reserved + ISNULL(a4.reserved, 0)) > a1.used
				THEN (a1.reserved + ISNULL(a4.reserved, 0)) - a1.used
			ELSE 0
			END
		) * 8 AS unused_KB --Не используется (КБ)
		
	FROM (
				SELECT ps.object_id
					,SUM(CASE 
							WHEN (ps.index_id < 2)
								THEN row_count
							ELSE 0
							END) AS [rows]
					,SUM(ps.reserved_page_count) AS reserved
					,SUM(CASE 
							WHEN (ps.index_id < 2)
								THEN (ps.in_row_data_page_count + ps.lob_used_page_count + ps.row_overflow_used_page_count)
							ELSE (ps.lob_used_page_count + ps.row_overflow_used_page_count)
							END) AS data
					,SUM(ps.used_page_count) AS used
				FROM sys.dm_db_partition_stats ps
				WHERE ps.object_id NOT IN (
						SELECT object_id
						FROM sys.tables
						WHERE is_memory_optimized = 1
						)
				GROUP BY ps.object_id
		) AS a1
	LEFT OUTER JOIN (
				SELECT it.parent_id
					,SUM(ps.reserved_page_count) AS reserved
					,SUM(ps.used_page_count) AS used
				FROM sys.dm_db_partition_stats ps
				INNER JOIN sys.internal_tables it ON (it.object_id = ps.object_id)
				WHERE it.internal_type IN (
						202
						,204
						)
				GROUP BY it.parent_id
		) AS a4 ON (a4.parent_id = a1.object_id)
	INNER JOIN sys.all_objects a2 ON (a1.object_id = a2.object_id)
	INNER JOIN sys.schemas a3 ON (a2.schema_id = a3.schema_id)
	WHERE a2.type <> N''S''
		AND a2.type <> N''IT''
		';
		
			DECLARE @request_id nvarchar(36), @schema_for_replace nvarchar(100)
	
			DECLARE bki_cursor CURSOR FOR   
				SELECT name as schem    
				FROM    sys.databases
				--Здесь можно перечислить список баз по которым собираем статистику
				/*  where name  in (
					'DWH','DWH_copy','VN','VN_test') --and name ='DWH'
					*/
			OPEN bki_cursor  

			FETCH NEXT FROM bki_cursor INTO @schema_for_replace

			WHILE @@FETCH_STATUS = 0  
			BEGIN
				set @SQL_text_final = replace (@sql_text,'{SCHEMA_FOR_REPLACE}',@schema_for_replace);  
				execute (@SQL_text_final)

			FETCH NEXT FROM bki_cursor INTO @schema_for_replace
			END   
	
		CLOSE bki_cursor;  
		DEALLOCATE bki_cursor;
END

