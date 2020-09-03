--Скрипт сверки возвратов
with q1 as (
	select   p.* 
		from OCMTest.[dbo].[vw_ocm_copy_payments]
 p
			
		where   cast(p.Date_time as date) between cast('2019-09-01' as date) and cast('2019-09-21' as date)  
		and loan_pay is not null
		)
		,q2 as (
		SELECT   pay.*
		FROM            OCMTest.fyt.payments AS pay 
		WHERE    
		cast(pay.date_time as date) between   cast('2019-09-01' as date) and cast('2019-09-21' as date)  
		--and (pay.loan_pay is not null )
		and marked = 0x00
		and pay.debt_type_id 
				in (0x9556E38F9D038C8647FD673A43D5E982
				,0xA986D5D3488A05C24E6D935D1D0AC481) --Основной долг--Реструктуризация (основной)-- loan_pay,
		
		/*(0xA5671A2422D3C61C40B2514CD771B21B,0xB6EA9243791D76B64756B0E2761222BF)
		 --Проценты по кредиту--Реструктуризация (проценты)-- interest_pay
		*/

		)


		select q2.* into #temp1
		from q1 full outer join q2 on q1.id=q2.id
		where q1.id is null or q2.id is null



		select* from  #temp1  where cast(date_time as date) = cast(getdate()-1 as date)and  contract_id=0x816600155D93BF2011E9D9F914F82383

		select *  from cyt.payments where contract_id=0x816600155D93BF2011E9D9F914F82383

		select sum(2250.00+
2480.50+
2792.88+
3176.62)



	--Проверка наличие дубликатов 
	select cast(date_time as date)
	from (
	select id,line_no ,max(date_time) date_time
	from  fyt.payments  where date_time > getdate()-10--contract_id=0x814800155D93BF2011E941B01A1DED81 --order by date_time
	group by id,line_no 
	having count(*)>1
		) t
  group by cast(date_time as date)
