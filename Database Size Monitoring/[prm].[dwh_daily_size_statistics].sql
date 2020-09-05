USE [LEMON]
GO
/****** Object:  StoredProcedure [prm].[dwh_daily_size_statistics]    Script Date: 01.04.2020 17:34:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  procedure [prm].[dwh_daily_size_statistics]   @sdate date, @edate date
AS-------555555555555----
BEGIN ------
	--Ñîáèğàåì ïîäíåâíóş ñòàòèñòèêó
		declare   @str nvarchar(4000)		
		set @str=
				 stuff
				 (
				  (	 
					select  N','+ 'round(cast(sum(case when ddate =  cast('''+ cast( ddate as nvarchar)+'''as date)  then	reserved_KB	end) as float) /1024/1024,0)  [GB_'+ cast( ddate as nvarchar)+']'+char(10)
					from ( 
						select distinct ddate from  lemon.prm.dwh_size_of_tables
						where ddate >=@sdate and  ddate<@edate
						) t
					 order by t.ddate
				   for xml path('')
				  ,type
				  ).value('.','nvarchar(max)'),
				  1,0,''
				 )-- column_string

		--print @str


		exec ('

		 select db_name --ÁÄ-
		
				'+@str+'
		 from  lemon.prm.dwh_size_of_tables
		--where ddate = cast(getdate() as date)
		 group by  db_name
		--order  by  db_name
		');


end ;