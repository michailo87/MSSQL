USE [LEMON]
GO
/****** Object:  StoredProcedure [prm].[dwh_monthly_table_size_statistics]    Script Date: 01.04.2020 17:35:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [prm].[dwh_monthly_table_size_statistics]   @sdate date, @edate date ,@db_name nvarchar(100)
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
 declare @ORDER_DATE NVARCHAR(100)



 SET @ORDER_DATE= convert(nvarchar, year( @edate)  ) +'_'+  convert(nvarchar, month( @edate) )


 SELECT  @ORDER_DATE = convert(nvarchar, year( DDATE)  ) +'_'+  convert(nvarchar, month( DDATE) ) FROM (
	select MAX( ddate ) DDATE from  lemon.prm.dwh_size_of_tables
				where ddate >=@sdate and  ddate<@edate and day(ddate)=1 
				) tt  ;
declare @ddb_name nvarchar(100)
set @ddb_name =  case when @db_name is null then '' else  ' and '+ 'db_name= '''+@db_name + '''' end 

exec ('

 select db_name --ÁÄ-
		,table_name
		'+@str2+'
 from  lemon.prm.dwh_size_of_tables
where 1=1  ' + @ddb_name  + '

-- ddate = cast(getdate() as date)
 group by  db_name,table_name
 order by  db_name,['+ @ORDER_DATE +'] desc
');


end;