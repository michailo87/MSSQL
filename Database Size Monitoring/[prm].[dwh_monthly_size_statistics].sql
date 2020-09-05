USE [LEMON]
GO
/****** Object:  StoredProcedure [prm].[dwh_monthly_size_statistics]    Script Date: 01.04.2020 17:34:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [prm].[dwh_monthly_size_statistics]   @sdate date, @edate date
AS
begin 
--Ñîáèğàåì ïîìåñÿ÷óş ñòàòèñòèêó
declare   @str2 nvarchar(4000)		
set @str2=
		 stuff
		 (
		  (	 
			select  N','+ 'round(cast(sum(case when ddate =  cast('''+ cast( ddate as nvarchar)+'''as date)  then	reserved_KB	end) as float) /1024/1024,0)  ['+ 
			CAST(year( ddate) as nvarchar) +'_'+ CAST(month( ddate) as nvarchar)
			--cast( ddate as nvarchar)
			+']'+char(10)
			from ( 
				select distinct ddate from  lemon.prm.dwh_size_of_tables
				where ddate >=@sdate and  ddate<@edate and day(ddate)=1
				) t
			 order by t.ddate
		   for xml path('')
		  ,type
		  ).value('.','nvarchar(max)'),
		  1,0,''
		 )

exec ('

 select db_name --ÁÄ-
		--,table_name
		'+@str2+'
 from  lemon.prm.dwh_size_of_tables
--where ddate = cast(getdate() as date)
 group by  db_name--,table_name
order  by  db_name
');


end;