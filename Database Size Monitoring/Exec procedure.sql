

--������� ���������� ����� �� ����� ��������� ������  �� ������� �������
exec  LEMON.prm.dwh_daily_size_statistics @sdate ='2020-03-01', @edate ='2020-04-01'

--�������� ���������� ����� �� ����� ��������� ������  �� ������� �������
exec  LEMON.prm.dwh_monthly_size_statistics @sdate ='2020-03-01', @edate ='2020-05-01'

--�������� ���������� ����� �� ������ �������
exec  LEMON.prm.dwh_monthly_table_size_statistics 
			  @sdate ='2020-02-01'
			, @edate ='2020-05-01'
			, @db_name ='DWH'--���� ��������� null �� ���������� ��� ������� �� ���� �����

