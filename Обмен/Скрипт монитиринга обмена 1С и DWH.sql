
--список таблиц  для обмена в OCMTest
select 'OCMTest' db_name, s.name schema_name ,t.name table_name--,tt.*
from sys.schemas s 
inner join sys.tables t on t.schema_id=s.schema_id
inner join sysobjects o on t.object_id=o.id
inner   join dwh_copy.dbo.etl_load_tables tt --список таблиц  для обмена в OCMTest
on tt.[schema_name] = s.[name] and  tt.[table_name]= t.[name]



--Для монитринга  времени обновления

SELECT    DB_name(database_id) database_name,s.name, OBJECT_NAME(e.OBJECT_ID) AS TableName,         MAX(last_user_update) ASLastUpdateDate
FROM  dwh_copy.dbo.etl_log  e ---sys.dm_db_index_usage_stats e--dwh_copy.dbo.etl_log  e
       left join sys.tables t on t.object_id=e.object_id
       left join sys.schemas s on t.schema_id=s.schema_id
      -- inner join  #temp1 tmp on tmp.schem=  s.name and   tmp.tabl=  t.name 
  where 1=1
      -- and  date_time between    CAST('2019-12-29T07:00:00.000' AS datetime) and CAST('2019-12-29T07:11:00.000' AS datetime)  
         and  DB_name(database_id)='OCMTest' 
		and run_id =2636--2610--2597
--991 --and OBJECT_NAME(e.OBJECT_ID) ='payments'
GROUP BY  DB_name(database_id),(e.OBJECT_ID),s.name
order  by     MAX(last_user_update) desc


--Посмотреть run_id  по времени обновления
select distinct date_time dt,run_id/*,**/
 from dwh_copy.dbo.etl_log -- where date_time > cast (getdate()-2 as date)
--and  run_id =976
 order by date_time desc


 exec DWH_copy.dbo.load_etl_log

  --Посмотреть историю джобов
 select --JobID, 
		JobName Джоб
		,cast(RunDateTime  as datetime)Дата_Запуска
		,cast(RunDateTime+substring([dur (DD:HH:MM:SS)]+':00',4,100)as datetime) Дата_Конца
		,stuff([dur (DD:HH:MM:SS)],3,1,'  ') Длительность
		,StepID Шаг,StepName [Имя шага]
		,Status Статус
		,Message Сообщение
		, job_enabled Вкл
		
 from DWH_COPY.dbo.etl_job_history 
 where jobname like 'update_dwh'and StepName ='Successful update'
 --and Status='ошибка'
 order by rundatetime,StepID


 select db_name(dbid) as db, spid as idproc, loginame, program_name, status
from sys.sysprocesses s
where
 status like 'runnable%'

select * from  DWH.[dbs].[session_statistics_lt] where date_time > getdate()-1
order by date_time DESC


select getdate() as [date_time], 
	es.[session_id], 
	es.login_name, 
	db_name(sp.dbid) as db, 
	es.[host_name], 
	sp.[program_name], 
	sp.net_library, es.[login_time], sp.cpu, sp.physical_io, sp.cmd,  
	(SELECT TEXT FROM ::fn_get_sql(sp.sql_handle )) SQL_text
	from sys.dm_exec_sessions es 
	join sys.sysprocesses sp on es.session_id = sp.spid 
	where es.status = 'running' 
	and len(sp.loginame) > 1 
	and es.[session_id] <> @@SPID 
	and es.[security_id] <> 0x010600000000000550000000DCA88F14B79FD47A992A3D8943F829A726066357


		select 
		   getdate()
		  ,[session_id]
		  ,[login_time]
		  ,[host_name]
		  ,[program_name]
		  ,[host_process_id]
		  ,[client_version]
		  ,[client_interface_name]
		  ,[security_id]
		  ,[login_name]
		  ,[nt_domain]
		  ,[nt_user_name]
		  ,[status]
		  ,[context_info]
		  ,[cpu_time]
		  ,[memory_usage]
		  ,[total_scheduled_time]
		  ,[total_elapsed_time]
		  ,[endpoint_id]
		  ,[last_request_start_time]
		  ,[last_request_end_time]
		  ,[reads]
		  ,[writes]
		  ,[logical_reads]
		  ,[is_user_process]
		  ,[text_size]
		  ,[language]
		  ,[date_format]
		  ,[date_first]
		  ,[quoted_identifier]
		  ,[arithabort]
		  ,[ansi_null_dflt_on]
		  ,[ansi_defaults]
		  ,[ansi_warnings]
		  ,[ansi_padding]
		  ,[ansi_nulls]
		  ,[concat_null_yields_null]
		  ,[transaction_isolation_level]
		  ,[lock_timeout]
		  ,[deadlock_priority]
		  ,[row_count]
		  ,[prev_error]
		  ,[original_security_id]
		  ,[original_login_name]
		  ,[last_successful_logon]
		  ,[last_unsuccessful_logon]
		  ,[unsuccessful_logons]
		  ,[group_id]
		  ,[database_id]
		  ,[authenticating_database_id]
		  ,[open_transaction_count]
	from sys.dm_exec_sessions
	where status = 'running'
	and [security_id] <> 0x010600000000000550000000DCA88F14B79FD47A992A3D8943F829A726066357