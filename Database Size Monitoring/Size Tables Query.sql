--Статистика места  в DWH по таблицам
select top 100 ddate -- [Дата]
		,run_id --
		,db_name --БД-
		,schema_name --Схема
		,table_name --Имя таблицы
		,row_count --Число записей
		,round(cast(reserved_KB as float) /1024/1024,2) as  reserved_GB --Зарезервировано (КБ)	
		,round(cast(data_KB as float) /1024/1024,2) as data_GB --Данные (КБ)
		,round(cast(index_size_KB as float) /1024/1024,2) as index_size_GB --Индексы (КБ)
		,round(cast(unused_KB as float) /1024/1024,2) as unused_GB--Не используется (КБ)	
 from  lemon.prm.dwh_size_of_tables
where ddate = cast(getdate() as date)-- and  db_name='DWH'
 order by reserved_GB desc


 --Статистика места  в DWH по  Базам
 select ddate -- [Дата]
		,run_id --
		,db_name --БД-
		,round(cast(sum(reserved_KB) as float) /1024/1024,2) as  reserved_GB --Зарезервировано (КБ)	
		,round(cast(sum(data_KB) as float) /1024/1024,2) as data_GB --Данные (КБ)
		,round(cast(sum(index_size_KB) as float) /1024/1024,2) as index_size_GB --Индексы (КБ)
		,round(cast(sum(unused_KB) as float) /1024/1024,2) as unused_GB--Не используется (КБ)	
		,sum(row_count) row_count--Число записей
 from  lemon.prm.dwh_size_of_tables
where ddate = cast(getdate() as date)-- and  db_name='DWH'
 group by   ddate,run_id,db_name
order  by  ddate,run_id	,sum(data_KB+index_size_KB) desc