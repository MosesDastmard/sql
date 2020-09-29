/*

alter function fnPercent (@No1 money , @No2 money , @Digit tinyint)
returns nvarchar(20)
as
begin
		
		declare @Result nvarchar(20) , @Per money
		set @Per = round ( (@No1 / @No2 ) * 100 , @Digit) 
		set @Result = CONVERT(nvarchar(19) , @Per ) + ' %'  
		return @Result 
end
go 

select publishers.pub_id , pub_name , sum(qty*price) , dbo.fnPercent(sum(qty*price) , SaleAmount ,0)
	from titles inner join 
		 sales on sales.title_id= titles.title_id inner join 
		 publishers on publishers.pub_id = titles.pub_id cross join 
		 (select sum(qty*price) as SaleAmount from titles inner join sales on sales.title_id = titles.title_id) as d
		 group by publishers.pub_id , pub_name , SaleAmount 

alter view vwSaleTitle
as
	select titles.title_id, title , pub_id , type , price , sum(qty*price) SaleAmount
	 from titles inner join 
		  sales on sales.title_id = titles.title_id 
		  group  by titles.title_id, title , pub_id , type , price

create function fnTitleSales()
returns table
return (select titles.title_id, title , pub_id , type , price , sum(qty*price) SaleAmount 
			from titles inner join 
			     sales on sales.title_id = titles.title_id 
			group by titles.title_id, title , pub_id , type , price)

select * from vwSaleTitle inner join publishers on publishers.pub_id = vwSaleTitle.pub_id 
where SaleAmount > 800 

select sum(saleAmount) from vwSaleTitle 

create function fnTypeSale(@type char(12))
returns table
return (select titles.title_id, title , pub_id , type , price , sum(qty*price) SaleAmount 
			from titles inner join 
			     sales on sales.title_id = titles.title_id 
			where type = @type 
			group by titles.title_id, title , pub_id , type , price)

select * from fnTitleSales() inner join publishers on publishers.pub_id = fnTitleSales.pub_id 
where SaleAmount > 500 

select * from vwSaleTitle 
where type = 'business'

select * from fnTypeSale('business')

create function fnTitleSaleCondition(@Sale money)
returns table 
	return (select titles.title_id , title , type , price , pub_id , sum(qty*Price) as SaleAmount 
			from titles inner join sales on sales.title_id = titles.title_id 
			group by titles.title_id , title , type , price , pub_id  
			having sum(qty*price)>@Sale)
			select * from fnTitleSaleCondition(300)

alter function fnState(@State char(2))
returns @tbl table (Id int identity(1,1) primary key ,TypeID int ,  Name varchar(30) , Type char(1))
as
begin
	
	insert into @tbl select ROW_NUMBER() over(order by pub_name) ,pub_name, 'P' from publishers where state = @State 
	insert into @tbl select ROW_NUMBER() over(order by au_id) ,au_fname + ' ' + au_lname  , 'A' from authors where state = @State 
	insert into @tbl select ROW_NUMBER() over(order by stor_name) ,stor_name  , 'S' from stores  where state = @State 

	return
end
go 

alter function fnTitlePrice ()
returns @tbl table (title_id varchar(6) , title varchar(80) , price money)
as
begin

	insert into @tbl 
				select title_id , title , price * 1.1
				  from titles where pub_id in (select pub_id from publishers where state = 'CA')
	insert into @tbl 
				select title_id , title , price * 1.05
				  from titles where title_id in (select title_id  from titleauthor group by title_id  having count(*)> 1) and
									title_id not in (select title_id from @tbl)		
	insert into @tbl 
				select title_id , title , price * 1.02
				  from titles where title_id in (select titles.title_id  from titles inner join sales on sales.title_id = titles.title_id 
													group by titles.title_id having sum(qty*price)>200) and
									title_id not in (select title_id from @tbl)	

	insert into @tbl 
				select title_id , title , price * .99
				  from titles where title_id not in (select title_id from @tbl)	

	update @tbl set price = 22 where price>22

	return
end
go


alter procedure spJobsInsert(@jobDesc varchar(50) , @Min tinyint , @Max tinyint , @JobID int output)
as
begin
		insert into jobs values (@jobDesc , @Min , @Max )
		set @JobID = (select max(job_id) from jobs)
end
go 

;
alter procedure spJobsUpate(@JobID int , @jobDesc varchar(50) , @Min tinyint , @Max tinyint)
as
begin
		
		update jobs set job_desc = @jobDesc , min_lvl = @Min , max_lvl = @Max 
				where job_id = @JobID 
		select * from jobs where job_id = @JobID 

end
go

declare @Id int 
execute spJobsInsert 'Developer1' , 50 , 100 , @Id output
print @Id

execute spJobsUpate 15 , 'Developer' , 50 , 150 

select * from jobs 

alter procedure spBackupPubs
as
begin
		declare @Path nvarchar(max) = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER2014\MSSQL\Backup\pubs_'+ convert( varchar(20), getdate()) + '.bak'
		BACKUP DATABASE [pubs] TO  DISK = @path
		 WITH NOFORMAT, NOINIT,  NAME = N'pubs-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
end
GO

*/