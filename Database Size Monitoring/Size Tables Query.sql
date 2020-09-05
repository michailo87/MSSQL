--���������� �����  � DWH �� ��������
select top 100 ddate -- [����]
		,run_id --
		,db_name --��-
		,schema_name --�����
		,table_name --��� �������
		,row_count --����� �������
		,round(cast(reserved_KB as float) /1024/1024,2) as  reserved_GB --��������������� (��)	
		,round(cast(data_KB as float) /1024/1024,2) as data_GB --������ (��)
		,round(cast(index_size_KB as float) /1024/1024,2) as index_size_GB --������� (��)
		,round(cast(unused_KB as float) /1024/1024,2) as unused_GB--�� ������������ (��)	
 from  lemon.prm.dwh_size_of_tables
where ddate = cast(getdate() as date)-- and  db_name='DWH'
 order by reserved_GB desc


 --���������� �����  � DWH ��  �����
 select ddate -- [����]
		,run_id --
		,db_name --��-
		,round(cast(sum(reserved_KB) as float) /1024/1024,2) as  reserved_GB --��������������� (��)	
		,round(cast(sum(data_KB) as float) /1024/1024,2) as data_GB --������ (��)
		,round(cast(sum(index_size_KB) as float) /1024/1024,2) as index_size_GB --������� (��)
		,round(cast(sum(unused_KB) as float) /1024/1024,2) as unused_GB--�� ������������ (��)	
		,sum(row_count) row_count--����� �������
 from  lemon.prm.dwh_size_of_tables
where ddate = cast(getdate() as date)-- and  db_name='DWH'
 group by   ddate,run_id,db_name
order  by  ddate,run_id	,sum(data_KB+index_size_KB) desc