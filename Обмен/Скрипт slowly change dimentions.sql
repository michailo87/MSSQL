USE LEMON
GO
CREATE or alter  TRIGGER dbo.test_insert
ON dbo.test 
AFTER INSERT,update ,delete
AS
 DECLARE @before_id  int, @after_id int ,@seq_number  bigint
    
	SELECT @after_id = Id FROM INSERTED
	SELECT @before_id = Id FROM deleted
	--select @seq_number =  NEXT VALUE FOR LEMON.dbo.seq_transaction_number

	print '@after_id' 
	print  @after_id
	print '@before_id'
	print @before_id
	print '@seq_number'
	print  @seq_number
	select @seq_number =  NEXT VALUE FOR LEMON.dbo.seq_transaction_number
		INSERT INTO lemon.dbo.transaction_test (id,ddate, oper_type,befor_after,transaction_number )
			SELECT Id, ddate,'D','B',@seq_number  FROM DELETED
	select @seq_number =  NEXT VALUE FOR LEMON.dbo.seq_transaction_number
		INSERT INTO lemon.dbo.transaction_test (id,ddate, oper_type,befor_after,transaction_number )
			SELECT Id, ddate,'I','A', @seq_number FROM INSERTED

	/*IF @after_id is null or @before_id is null 
	begin
	print  1
		if @after_id is not null
			INSERT INTO lemon.dbo.transaction_test (id,ddate, oper_type,befor_after,transaction_number )
			SELECT Id, ddate,'I','A', @seq_number FROM INSERTED
		if @before_id is not null
			INSERT INTO lemon.dbo.transaction_test (id,ddate, oper_type,befor_after,transaction_number )
			SELECT Id, ddate,'D','B', @seq_number FROM DELETED

	end;
	else  
	begin
		print  2
		if  @after_id = @before_id 
			begin
				print  3
				INSERT INTO lemon.dbo.transaction_test (id,ddate, oper_type,befor_after,transaction_number )
				SELECT Id, ddate,'U','A', @seq_number FROM INSERTED
			end
		else 
			begin
				print  4
				INSERT INTO lemon.dbo.transaction_test (id,ddate, oper_type,befor_after,transaction_number )
				SELECT Id, ddate,'P','A', @seq_number FROM INSERTED
				union all
				SELECT Id, ddate,'P','B', @seq_number  FROM DELETED
			end;*/
	--end;
	print '@seq_number'



INSERT INTO lemon.dbo.transaction_test (id,ddate, oper_type)
SELECT Id, ddate,'I'
FROM INSERTED


drop table   lemon.dbo.test 
drop table   lemon.dbo.transaction_test 

delete  from  lemon.dbo.transaction_test
delete  from  lemon.dbo.test
 
select * from  lemon.dbo.test 
select * from  lemon.dbo.transaction_test  order by transaction_number ,befor_after desc

create table lemon.dbo.test ( id int primary key , ddate date)
create table lemon.dbo.transaction_test ( id int , ddate date,oper_type nvarchar(1),befor_after nvarchar(1),transaction_number bigint)

insert into lemon.dbo.test values(3 , getdate())
delete from lemon.dbo.test  where id = 3

update  lemon.dbo.test set ddate = getdate()-1
where id=2
update  lemon.dbo.test set id = id+1

update  lemon.dbo.test set id = 3
where id=3


update  lemon.dbo.test set ddate = getdate()-1

insert  lemon.dbo.test 
select convert(int,id),getdate()  from dwh.fyt.contracts
group by convert(int,id) 

10 a,getdate() b 
union all 
select 11  a ,getdate()b


CREATE SEQUENCE dbo.seq_transaction_number
    AS bigint
    START WITH 1  
    INCREMENT BY 1  

	SELECT NEXT VALUE FOR Test.DecSeq;  
	select NEXT VALUE FOR LEMON.dbo.seq_transaction_number