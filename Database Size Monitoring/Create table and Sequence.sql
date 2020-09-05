CREATE SEQUENCE prm.sq_etl_log_1 
 AS bigint
 START WITH 1
 INCREMENT BY 1
 
 CREATE TABLE prm.dwh_size_of_tables(
	ddate date NULL,							--Дата  на момент который смотрим статистику таблицы
	run_id numeric(14, 0) NOT NULL,	--ID Запуска сбора статистики, Счетчик
	db_name varchar(20) NOT NULL,	--База данных
	schema_name sysname NOT NULL,	--Схема таблицы
	table_name sysname NOT NULL,	--Название таблицы
	row_count bigint NULL,				--Количество строк в таблице
	reserved_KB bigint NULL,			--Ощий размер таблицы  вместе с индесами
	data_KB bigint NULL,					--Размер самих данных в таблице 
	index_size_KB bigint NULL,		--Размер индексов
	unused_KB bigint NULL					--неиспрользованное место
) 