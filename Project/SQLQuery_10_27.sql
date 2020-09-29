select * from Tbl1 
union 
select * from tbl2

select * from Tbl2
union 
select * from tbl3

select * from Tbl1 
union all
select * from tbl2
 select  pub_name , YEAR(ord_date) , sum(qty * price ) 
	from sales inner join 
		 titles on titles.title_id = sales.title_id inner join 
		 publishers on publishers.pub_id = titles.pub_id 
	group by  pub_name , YEAR(ord_date)
	with rollup

select  isnull( pub_name , 'Sub Total') PabName , YEAR(ord_date) , sum(qty * price ) 
	from sales inner join 
		 titles on titles.title_id = sales.title_id inner join 
		 publishers on publishers.pub_id = titles.pub_id 
	group by  pub_name , YEAR(ord_date)
	with cube
 
 select  pub_name , YEAR(ord_date) , sum(qty * price ) 
	from sales inner join 
		 titles on titles.title_id = sales.title_id inner join 
		 publishers on publishers.pub_id = titles.pub_id 
	group by  pub_name , YEAR(ord_date)
 select * from fnPivot()
 unpivot
 (SaleAmount for year in ([1992], [1993] , [1994])) as f


select * from jobs where job_id = 19

update jobs set job_desc = 'Developer'
 where job_id = 19

 update titles set price = price * 1.1
 where type = 'business'

 update titles set price = case when price > 10 then price * 1.1
											    else price * .95
						   end

update titles set price = case when pub_id in (select pub_id from publishers where state = 'CA') then price * 1.1
																								 else price * .95
						  end

update titles set price = case when state = 'CA' then price * 1.1
												 else price * .95
						  end
from titles inner join 
	 publishers on publishers.pub_id = titles.pub_id 

update titles set price = case when title_id in (select title_id from titleauthor group by title_id having count(*)>1 ) then price * 1.1
																														else price * .95
						  end

update titles set price = case when count(au_id) > 1 then price * 1.1
													 else price * .95
						  end
	from titles inner join titleauthor on titleauthor.title_id = titles.title_id 
select * from Tbl1 
except 
select * from tbl2

select * from Tbl2 
except 
select * from tbl1

select * from Tbl2 
except 
select * from tbl3

select * from Tbl4
intersect
select * from tbl1

select count(*) from 
(select * from Tbl1 
	except 
 select * from Tbl4
 union all
 select * from Tbl4
	except 
  select * from Tbl1) as T

  select CountA  + CountB  from 	
	(select count(*) CountA from 
	  (select * from Tbl1 
		except 
	   select * from Tbl4) as A) as CA
 cross join
	(select count(*) CountB from 
	  (select * from Tbl4 
		except 
	   select * from Tbl1) as B) CB


insert into jobs (job_desc , min_lvl , max_lvl ) values
				 ('SQL Admin' , 150 , 250)


insert into jobs values ('SQL BI' , 150 , 250)
insert into jobs values (150 , 'SQL BI' , 250)
insert into jobs (min_lvl , job_desc , max_lvl ) values (150 , 'SQL BI' , 250)

--create table JobR (jobID int , JobDesc varchar(50) , MinLvl tinyint , MaxLvl tinyint)

insert into JobR select * from jobs where max_lvl > 100


select * from JobR 

select titles.title_id , title , sum(qty*price) as SaleAmount 
into TitleSales
from titles inner join sales on sales.title_id = titles.title_id 
group by titles.title_id , title 

select * from TitleSales 

set identity_insert dbo.jobs on
insert into jobs (job_id , job_desc , min_lvl , max_lvl ) values (17 , 'test' , 50 , 100)
set identity_insert dbo.jobs off

select * from jobs
dbcc checkident  ('jobs' , reseed ,1)
