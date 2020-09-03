
select  distinct  app.client_id into #temp1
from OCMTest.fyt.applications app
left join  OCMTest.dyt.clients cl on app.client_id=cl.id
where cl.id is null --and app.date_time >= '01.01.2019' 
and app.posted = 1 and app.client_id is not null


select count(*) from OCMTest.dyt.clients cl




--
select  client_id ,max(date_time ) max_date_time into #temp2 from OCMTest.fyt.applications  group by client_id

select  a.client_id ,isnull(a.client_gender_id,0xA5BA88039F4BFE3C463072DC5545798F) gender_id, a.application_id into #temp3 
from OCMTest.fyt.applications  a  
	inner join #temp2  t 
		on t.client_id=a.client_id and t.max_date_time=a.date_time


select  a.client_id ,max( a.application_id ) application_id into #temp4
from #temp3 a
 group by  a.client_id 


 select  a.client_id ,isnull(a.client_gender_id,0xA5BA88039F4BFE3C463072DC5545798F) gender_id into #temp5 
from OCMTest.fyt.applications  a  
	inner join #temp4  t 
		on t.client_id=a.client_id and t.application_id=a.application_id



--select client_id from  #temp3 group by client_id having count(*)>1


SELECT 
T1._IDRRef id /*������,*/
,T1._Marked marked /*���������������,*/
,T1._Description name /* ������������,*/
,DATEADD(YEAR,-2000,T1._Fld888)    birth_date /*������������,*/
,T1._Fld6807 snils /*�����,*/
,T.gender_id /* ��_���,*/-- into #clients
FROM [OCM-SQL-1C].[ut_ocm_report].dbo.[_Reference59] T1 left  join #temp5 t on t.client_id=T1._IDRRef
where  T1._IDRRef  in (select client_id from #temp1)

--select * from ocmtest.dyt.clients  where id  in (SELECT id  from #clients)


/*

N	����	��� ���� � 1�	��� ���� � ���
1	��	������	id
2	���	���������������	marked
3	���	������������	name
4	���	������������	birth_date
5	���	�����	snils
6	���	���	gender_id

*/


/*

�������
    ��������������������.������.������,
    ��������(��������������.����) ��� ��������
��������� ����������������
��
    ����������.�����������.��������� ��� ��������������������
//  ����������.����������� ��� ��������������������
        ����� ���������� ��������.�������������� ��� ��������������
        �� ��������������������.������ = ��������������.����������
���
    ��������������������.���� = &����
//+++ 20190207 ssidelnikov "FR1C-1113"
� (&������������������ = ������������ ��� ��������������.���� <= &������������������)
//--- 20190207 ssidelnikov

������������� ��
    ��������������������.������.������
;

////////////////////////////////////////////////////////////////////////////////
�������
    ����������������.������������ ��� ������,
    ����NULL(��������������.���, ��������(������������.������������������.�������)) ��� ���,
    ����������������.������������.������������ ��� ������������,
    ����������������.������������.������������ ��� ������������,
    ����������������.������������.����� ��� �����,
    ����������������.������������.��������������� ��� ���������������
��
    ���������������� ��� ����������������
        ����� ���������� ��������.�������������� ��� ��������������
        �� ����������������.������������ = ��������������.����������
� ����������������.�������� = ��������������.����

*/