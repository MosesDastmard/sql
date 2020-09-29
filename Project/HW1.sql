use pubs;

create table JobR (jobID int , JobDesc varchar(50) , MinLvl tinyint , MaxLvl tinyint);
insert into JobR select * from jobs where max_lvl > 100;





select * from publishers where        exists    (select * from titles where titles.pub_id = publishers.pub_id);
select * from publishers where pub_id in        (select pub_id from titles);
select * from authors where not exists (select * from titleauthor where titleauthor.au_id = authors.au_id);




select * from publishers where not exists (select * from titles where titles.pub_id = publishers.pub_id and type = 'business');
select * from publishers where pub_id not in (select pub_id from titles where type = 'business');
select * from publishers where pub_id in (select pub_id from titles where type != 'business');
select title_id , title  ,

	case type 
		when 'mod_cook'     then 'Modern Cooking'
		when 'trad_cook'    then 'Tradintional Cooking'
		when 'popular_Comp' then 'Papular Coputer '
							else  type
	end as newType

	from titles ;

select title_id , title , price , 
	case when price > 10 then price * 1.1 
						 else price * .95
	end as newPrice 
from titles ;

select title_id, title , 
	case when state = 'CA' then price * 1.1 
						   else price * .95
	end as newPrice
from titles inner join publishers on publishers.pub_id = titles.pub_id ;

select title_id, title , 
	case when pub_id in (select pub_id from publishers where state = 'CA') then price * 1.1 
																	       else price * .95
	end as newPrice 
from titles ;

select titles.title_id , title , 
	case when sum(qty*price) > 500 then price * 1.1
								   else price * .95
	end
from titles inner join 
	 sales on sales.title_id = titles.title_id 
	 group by titles.title_id , title , price ;

select * ,
	case when title_id in (select titles.title_id 
							from titles inner join 
								 sales on sales.title_id = titles.title_id 
								 group by titles.title_id 
								 having sum(qty*price) > 500)	then price * 1.1
																else price * .95
	end 

from titles ;

select titles.title_id , title , 
	case when count(au_id) > 1 then price * 1.1
							   else price * .95
	end 
from titles inner join titleauthor on titleauthor.title_id = titles.title_id 
	group by titles.title_id , title ,price ;

select title_id , title , 
		case when title_id in ( select title_id from titleauthor group by title_id having count(*) > 1 ) then price * 1.1
																										 else price * .95
		end
	 from titles ;

select title_id , title  , 
	
		 case when pub_id in   (select pub_id from publishers where state = 'CA')							then price * 1.1 
	else case when title_id in (select title_id from titleauthor group by title_id having count(*) > 1) then price * 1.05
	else case when title_id in (select titles.title_id 
									from titles inner join 
								 sales on sales.title_id = titles.title_id 
								 group by titles.title_id 
								 having sum(qty*price) > 200)											then price * 1.02
																										else price * .99
	end end end as newPrice


from titles ;

select titles.title_id , title ,
		  case when state = 'CA'	   then price * 1.10
	 else case when CoAu > 1	       then price * 1.05
	 else case when sum(qty*price)>200 then price * 1.02
									   else price * .99
	end end end 
	from titles inner join 
		 publishers on publishers.pub_id = titles.pub_id inner join 
		 sales on sales.title_id = titles.title_id inner join 
		 (select titleauthor.title_id , count(*) as CoAu from titleauthor group by title_id ) as tblCoAu on titles.title_id = tblCoAu.title_id 
		 group by  titles.title_id , title , price , state , CoAu ;

select titles.title_id , title , sum(qty*price),
	
	case when sum(qty*price) < 200  then 0
	     when sum(qty*price) < 500  then 0 + (sum(qty*price) - 200 ) * .05 
		 when sum(qty*price) < 800  then 0 + (300 * .05)				  +(sum(qty*price) - 500 ) * .10 
		 when sum(qty*price) < 1000 then 0 + (300 * .05)				  +   (300 * .10 )               +  (sum(qty*price) - 800 ) * .15 
									else 0 + (300 * .05)				  +   (300 * .10 )               +  (200 * .15 )				  + (sum(qty*price) - 1000 ) * .20
	 end
	from titles inner join 
		 sales on sales.title_id = titles.title_id 
		group by titles.title_id , title ;

	 select * ,
	 case when SaleAmount < 200  then 0
		  when SaleAmount < 500  then 0 +				 (SaleAmount - 200)  * .05
		  when SaleAmount < 800  then 0 + 15 +			 (SaleAmount - 500)  * .10
		  when SaleAmount < 1000 then 0 + 15 + 30 +		 (SaleAmount - 800)  * .15
								 else 0 + 15 + 30 + 30 + (SaleAmount - 1000) * .20   
	end as Tax 

	 from 
		(select titles.title_id , title , sum(qty*price) as SaleAmount
		from sales inner join titles on titles.title_id = sales.title_id 
		group by titles.title_id , title) as d ;
select  pub_name , YEAR(ord_date) , sum(qty * price ) 
	from sales inner join 
		 titles on titles.title_id = sales.title_id inner join 
		 publishers on publishers.pub_id = titles.pub_id 
	group by  pub_name , YEAR(ord_date)
	with rollup;

select  isnull( pub_name , 'Sub Total') PabName , YEAR(ord_date) , sum(qty * price ) 
	from sales inner join 
		 titles on titles.title_id = sales.title_id inner join 
		 publishers on publishers.pub_id = titles.pub_id 
	group by  pub_name , YEAR(ord_date)
	with cube;
 
 select  pub_name , YEAR(ord_date) , sum(qty * price ) 
	from sales inner join 
		 titles on titles.title_id = sales.title_id inner join 
		 publishers on publishers.pub_id = titles.pub_id 
	group by  pub_name , YEAR(ord_date);

select * from jobs where job_id = 19;

update jobs set job_desc = 'Developer'
 where job_id = 19;

 update titles set price = price * 1.1
 where type = 'business';

 update titles set price = case when price > 10 then price * 1.1
											    else price * .95
						   end;

update titles set price = case when pub_id in (select pub_id from publishers where state = 'CA') then price * 1.1
																								 else price * .95
						  end;

update titles set price = case when state = 'CA' then price * 1.1
												 else price * .95
						  end
from titles inner join 
	 publishers on publishers.pub_id = titles.pub_id; 

update titles set price = case when title_id in (select title_id from titleauthor group by title_id having count(*)>1 ) then price * 1.1
																														else price * .95
						  end;

update titles set price = case when count(au_id) > 1 then price * 1.1
													 else price * .95
						  end
	from titles inner join titleauthor on titleauthor.title_id = titles.title_id ;
    
    insert into jobs (job_desc , min_lvl , max_lvl ) values
				 ('SQL Admin' , 150 , 250);


insert into jobs values ('SQL BI' , 150 , 250);
insert into jobs values (150 , 'SQL BI' , 250);
insert into jobs (min_lvl , job_desc , max_lvl ) values (150 , 'SQL BI' , 250);

create table JobR (jobID int , JobDesc varchar(50) , MinLvl tinyint , MaxLvl tinyint);

insert into JobR select * from jobs where max_lvl > 100;


select * from JobR ;

select titles.title_id , title , sum(qty*price) as SaleAmount 
into TitleSales
from titles inner join sales on sales.title_id = titles.title_id 
group by titles.title_id , title ;

select * from TitleSales ;

DECLARE @StartTime datetime;
@EndTime datetime;
SELECT @StartTime=GETDATE();
select * from TitleSales ;
set statistics time off


