select  cast(date_time as date), count(*)
from fyt.payments
where date_time> getdate()-10
group by cast(date_time as date)
order by  cast(date_time as date)

select  cast(create_date as date), count(*)
from fyt.schedules
where create_date> getdate()-10
group by cast(create_date as date)
order by  cast(create_date as date)

select  cast(date_time as date), count(*)
from fyt.cashin
where date_time> getdate()-10
group by cast(date_time as date)
order by  cast(date_time as date)
