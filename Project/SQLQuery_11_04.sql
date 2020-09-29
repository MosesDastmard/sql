/*
use pubs 

update titles set price = case when title_id in (select title_id from titleauthor group by title_id having count(au_id)> 1) then price * 1.1
																															else price * .95
						  end

update titles set price  = case when  CoAu  > 1 then price * 1.1 
													   else price * .95
						   end
from titles 
inner join 	
	(select title_id , count(au_id) as CoAu
		from titleauthor group by title_id  ) as d on d.title_id = titles.title_id 
	
;with cteCoAu(title_id , CoAu)
as
	(select title_id , count(au_id) as CoAu
		from titleauthor group by title_id)

update titles set price = case when  CoAu  > 1 then price * 1.1 
													   else price * .95
						   end 
from 
	titles inner join cteCoAu on cteCoAu.title_id = titles.title_id 



update titles set price = case when title_id in (select titles.title_id from titles inner join sales on sales.title_id = titles.title_id 
													group by titles.title_id having sum(qty*price)> 500) then price * 1.1
																										 else price * .95
						  end

;	with cteSale (Title_id , SaleAmount)
	as
		(select titles.title_id , sum(qty*price)
			from titles inner join sales on sales.title_id = titles.title_id 
		group by titles.title_id)

	update titles set price = case when SaleAmount > 500 then price * 1.1
														 else price * .95
							  end
	from titles inner join cteSale on cteSale.Title_id = titles.title_id 
*/

;with cteUpdate(title,newPrice)
as
	(select titles.title_id , case when state = 'CA' then price * 1.1 
							 else case when CoAu > 1 then price * 1.05
							 else case when sum(qty*price)>200 then price * 1.02 
							 else price * .99
							 end end end
			from titles inner join 
				 sales on sales.title_id = titles.title_id inner join 
				 publishers on publishers.pub_id = titles.pub_id inner join 
				 (select title_id , count(*) as CoAu from titleauthor group by title_id) as tblCoAu on tblCoAu.title_id = titles.title_id 
				 group by titles.title_id , price , CoAu , state )

update titles set price = newPrice 
from titles inner join cteUpdate on cteUpdate.title = titles.title_id 
--select * from jobs 
--delete jobs where job_id = 19
delete roysched where title_id in (select title_id from titles where price > 20)
delete titleauthor where title_id in (select title_id from titles where price > 20)
delete sales where title_id in (select title_id from titles where price > 20)
delete titles where price > 20

create table #tblDel (title_id varchar(80))
insert into #tblDel select title_id  from titleauthor group by title_id having count(*) > 1
--select title_id into #tblDel from titleauthor group by title_id having count(*) > 1
--select title_id into ##temp from titleauthor group by title_id having count(*) > 1

delete roysched where title_id in
	(select title_id  from #tblDel)

delete sales where title_id in
	(select title_id  from #tblDel)

delete titleauthor where title_id in
	(select title_id  from #tblDel)

delete titles  where title_id in
	(select title_id  from #tblDel)

select ASCII('A')
select char(65)
select CHARINDEX('a','sdafa',3)

select title, CHARINDEX('the' , title) from titles 
where  CHARINDEX('the' , title) > 0

select left('abcd',2)
select right('abcd',2)
select substring('abcd',2,2)
select LTRIM('    ASD   ')
select RTRIM('    ASD   ')
select LOWER('ASD')
select upper('asd')
select SPACE(3)+'a'

select replicate('a',3)
select REPLACE(title,'%','œ—’œ') from titles 
select REVERSE('ASD')
select ISNULL(price,0) , * from titles 
select STUFF('aaaa',1,3,'bcdvcghj')
select STR(12.1234556,4,2)
declare @i int = 1
while @i < 11
begin
	print @i
	--set @i = @i + 1
	set @i += 1
end


create function fnTitleSale(@TitleID varchar(80))
returns money
as
begin

		declare @Result money
		set @Result = 
						(select SUM(qty*price)
								from titles inner join 
								sales on sales.title_id = titles.title_id 
								where titles.title_id = @TitleID)
		return @Result
end
go

create function fnCountAu (@titleID varchar(80))
returns tinyint
as
begin
		
		--return (select count(*) from titleauthor where title_id = @titleID)
		
		declare @result tinyint 
		set @result = (select count(*) from titleauthor where title_id = @titleID)
		return @Result

end 
go
select title_id , title , type , price , pub_id , dbo.fnTitleSale(title_id) as SaleAmount , dbo.fnCountAu(title_id)
 from titles 


 select au_id ,sum( dbo.fnTitleSale(title_id) / dbo.fnCountAu(title_id))
  from titleauthor 
  group by au_id  