declare @start_date datetime, @end_date datetime
set @start_date =cast(cast(DatePart(year,GetDate()-1) as char(4))+
               case when len(cast(DatePart(month,GetDate()-1) as char(2)))<2 then '0'+rtrim(cast(DatePart(month,GetDate()-1) as char(2)) )
		else cast(DatePart(month,GetDate()-1) as char(2)) end  +
                 '01'
				 as datetime);--поставить месяц

set @end_date =    dateadd(n,-0---ставим нужную
			, DATEADD(day, 0,  dateadd(day, datediff(day, 0, GetDate()), 0) )  ) ;--ы GETDATE() ;--



	if OBJECT_ID(N'TempDB..#dwh', N'U') is not null drop table #dwh

	SELECt agr.number,agr.date_time,agr.id   into #dwh
	FROM            OCMTest.fyt.agreements AS agr INNER JOIN
								OCMTest.fyt.contracts AS con ON agr.application_id = con.application_id INNER JOIN
								OCMTest.fyt.applications AS app ON con.application_id = app.id INNER JOIN
								OCMTest.dyt.utm AS utm ON app.utm_source_id = utm.id
		WHERE        (con.loan_purchased_by_cession = 0x00) AND (con.issued = 0x01) AND (con.marked = 0x00) AND (agr.loan_purchased_by_cession = 0x00) AND (agr.posted = 0x01) 
		and cast(agr.start_date as date) between  @start_date and  @end_date;

	if OBJECT_ID(N'TempDB..#c1', N'U') is not null drop table #c1
	select  ct.date_time, ct.[start_date],ct.number,ct.id into #c1
	from OCMTest.dbo.vw_ocm_copy_contracts_2m  ct
	where -- ct.marked=0x00 and
		ct.posted = 0x01 and ct.loan_purchased_by_cession = 0x00 
	and cast(ct.[start_date] as date) between   @start_date and  @end_date
	and doctype in( 'Пролонгация','Реструктуризация')--  and ct.number ='УФ-/2000045415'
		--AND ct.issued = 0x01 
		--and doctype in( 'Основной Договор')

if OBJECT_ID(N'TempDB..#corr', N'U') is not null drop table #corr
	select t.*  into #corr
	from  #c1  t 
		full outer join #dwh tt 
			on tt.number=t.number where   tt.number is null --or t.number is null



	insert into ocmtest.fyt.agreements 		
	([id],[marked],[number],[date_time],[posted],[start_date],[end_date],[application_id],[comment]
      ,[client_id],[manager_id],[organisation_id],[contract_id],[division_id],[interest_rate_per_day]
	  ,[default_rate_per_day],[loan_amount],[interest_amount],[penulty_amount],[loan_purchased_by_cession]
      ,[psk]      ,[grace_period]      ,[product_id])
SELECT[id]
      ,[marked]
      ,[number]
      ,[date_time]
      ,[posted]
      ,[start_date]
      ,[end_date]
      ,[application_id]
      ,[comment]
      ,[client_id]
      ,[manager_id]
      ,[organisation_id]
      ,[contract_id]
      ,[division_id]
      ,[interest_rate_per_day]
      ,[default_rate_per_day]
      ,[loan_amount]
      ,[interest_amount]
      ,[penulty_amount]
      ,[loan_purchased_by_cession]
      ,[psk]
      ,[grace_period]
      ,[product_id]
    /*  ,[null]
      ,[term]
      ,[ВидДоговора]
      ,[DocType]*/
  FROM [OCMTest].[dbo].[vw_ocm_copy_contracts_2019] cc
  where  [DocType] in ('Пролонгация','Реструктуризация')
  and
   cc.[id] in (select  c.id  from #corr c)
 --  order by [DocType]





 /*
--EXEC OCMTest.[cyt].[update_full_ocm]

select * from ocmtest.fyt.agreements a where interest_rate_per_day >9

select * from ocmtest.fyt.agreements a where a.number ='УФ-906/2166614' 

select * from [OCMTest].[dbo].[vw_ocm_copy_contracts_2019]  a where a.number ='УФ-906/2166614' 
 where 
 /*
 select interest_rate_per_day,* from [OCMTest].[dbo].[vw_ocm_copy_contracts_2019]  where number ='УФ-906/2166614' 

 select *  into #agr
 from [OCMTest].[dbo].[vw_ocm_copy_contracts_2019]  ct
  where  ct.date_time >= cast('2019-12-03' as date)
  */

  /*

  update  OCMTest.fyt.agreements
  set OCMTest.fyt.agreements.interest_rate_per_day =aa.interest_rate_per_day
  from   #agr aa
  where aa.id=OCMTest.fyt.agreements.id
    and   OCMTest.fyt.agreements.date_time >= cast('2019-12-03' as date)
	*/