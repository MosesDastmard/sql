set transaction isolation level serializable 
begin transaction 
	
	select * from titles
	select * from publishers 

	if( (select count(*) from titles)>12)
		commit transaction
	else
		rollback


set transaction isolation level serializable 
begin transaction 
	
	select * from publishers
	select * from titles t 

	if( (select count(*) from titles)>12)
		commit transaction
	else
		rollback

begin try
	update titles set pub_id = '1111' where title_id = 'BU1032'
end try
begin catch
	select ERROR_LINE(), ERROR_MESSAGE(), ERROR_PROCEDURE() , ERROR_NUMBER() , ERROR_SEVERITY(), ERROR_STATE()
end catch

declare CrTitles cursor for select title_id , title , price from titles 
declare @TitleID varchar(6),
		@Title   varchar(80),
		@Price   money 
open CrTitles
fetch next from CrTitles into @TitleID , @Title , @Price
while @@FETCH_STATUS = 0 
begin 
		print @TitleID + ' , ' + @Title + ' , ' +  convert(varchar(10) ,  isnull(@price , 0))
		fetch next from CrTitles into @TitleID , @Title , @Price
end
close CrTitles
deallocate CrTitles

create table Account (AccountNumber int identity primary key , Score int)
create table AccountLottory(AccountNumber int primary key , Taj int)
insert into Account values (100)
insert into Account values (50)
insert into Account values (170)
insert into Account values (130)
insert into Account values (560)
insert into Account values (10)
insert into Account values (120)

select * from Account

alter table Account 
	add Taj int
	--,   t char(1)

alter table Account
	alter column Accountnumber tinyint

declare CrTaj cursor for select AccountNumber , Score  from Account
declare @AcNumber int ,
		@Score int ,
		@Taj int

open CrTaj
fetch next from CrTaj into  @AcNumber,@Score
set @Taj = 0 
while @@FETCH_STATUS = 0 
begin 
	set @Taj += @Score 
	update Account set Taj = @Taj where AccountNumber = @AcNumber 
	fetch next from CrTaj into  @AcNumber,@Score
end
close CrTaj
deallocate CrTaj

select * from Account 

declare CrTaj cursor for select AccountNumber , Score  from Account
declare @AcNumber int ,
		@Score int ,
		@Taj int

open CrTaj
fetch next from CrTaj into  @AcNumber,@Score
set @Taj = 0 
while @@FETCH_STATUS = 0 
begin 
	set @Taj += @Score 
	insert into AccountLottory values (@AcNumber , @Taj )
	fetch next from CrTaj into  @AcNumber,@Score
end
close CrTaj
deallocate CrTaj
go 

select * from AccountLottory 

	create procedure spBackUP 
as
begin
	declare @Path varchar(max) = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER2014\MSSQL\Backup\pubs_' + 
									convert(varchar(max) , Getdate())
	BACKUP DATABASE [pubs] TO  DISK = @path WITH NOFORMAT, NOINIT,  NAME = N'pubs-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10

end
go 
