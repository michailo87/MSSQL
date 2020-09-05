

--Дневная статистика места по базам указываем период  за который смотрим
exec  LEMON.prm.dwh_daily_size_statistics @sdate ='2020-03-01', @edate ='2020-04-01'

--Месячная статистика места по базам указываем период  за который смотрим
exec  LEMON.prm.dwh_monthly_size_statistics @sdate ='2020-03-01', @edate ='2020-05-01'

--Месячная статистика места по каждой таблице
exec  LEMON.prm.dwh_monthly_table_size_statistics 
			  @sdate ='2020-02-01'
			, @edate ='2020-05-01'
			, @db_name ='DWH'--если указываем null то показывает все таблицы по всем базам

