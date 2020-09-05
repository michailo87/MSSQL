CREATE SEQUENCE prm.sq_etl_log_1 
 AS bigint
 START WITH 1
 INCREMENT BY 1
 
 CREATE TABLE prm.dwh_size_of_tables(
	ddate date NULL,							--����  �� ������ ������� ������� ���������� �������
	run_id numeric(14, 0) NOT NULL,	--ID ������� ����� ����������, �������
	db_name varchar(20) NOT NULL,	--���� ������
	schema_name sysname NOT NULL,	--����� �������
	table_name sysname NOT NULL,	--�������� �������
	row_count bigint NULL,				--���������� ����� � �������
	reserved_KB bigint NULL,			--���� ������ �������  ������ � ��������
	data_KB bigint NULL,					--������ ����� ������ � ������� 
	index_size_KB bigint NULL,		--������ ��������
	unused_KB bigint NULL					--����������������� �����
) 