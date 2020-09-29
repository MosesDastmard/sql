## Course: Data Managment for Data Science
## DMDS HW2
## Group members: Melika Parpinchi, 1880156, Mousaalreza Dastmard, 1852433
## Dataset info: https://relational.fit.cvut.cz/dataset/Pubs

##-------------------------------------------------------------------------------------------------------------------
## adding integrity constraints to one or more tables
## Creating new Table and defining integrty constrain for columns 
create table JobR (jobID int Primary Key, JobDesc varchar(50) unique, MinLvl tinyint not null, MaxLvl tinyint not null);
## filling the new table, JobR using the data in jobs table
insert into JobR select * from jobs where max_lvl > 100;
select * from JobR;

##-------------------------------------------------------------------------------------------------------------------
## rewriting the SQL query (without changing its meaning) (Qi-j for all j have the same meaning for query i)
## Q2-1-1: List of publishers that don't have business book
create index i_type on titles(type);
select * 
from publishers 
where not exists 
	(select * 
	 from titles 
     where titles.pub_id = publishers.pub_id and type = 'business');
## Q2-1-2: List of publishers that don't have business book
create view business_pub_ids as 
select pub_id 
    from titles 
    where type = 'business';
select * 
from publishers 
where pub_id not in 
	(select * 
    from business_pub_ids 
);
## Q2-1-3: List of publishers that don't have business book
select * 
from publishers 
where pub_id in 
	(select pub_id 
	from titles 
    where type != 'business');
##***************************************
## Q2-2-1: Total sale of business books

select titles.title_id , title , sum(qty*price) as TotalSale 
	from titles inner join 
		 sales on sales.title_id = titles.title_id 
		 where type = 'business'
		 group by  titles.title_id , title;
## Q2-2-2: Total sale of business books
select titles.title_id , title , sum(qty*price) as TotalSale
	from titles inner join 
		 sales on sales.title_id = titles.title_id 
		 group by  titles.title_id , title , type
		 having type = 'business';
##*********************************
## Q2-3-1: List of books, their price and average price and its diffrence
Select title, price, ta, price-ta 
from titles
Cross join 
	(Select avg (price) as ta 
    from titles) k;
## Q2-3-2: List of books, their price and average price and its diffrence
Select title, price, (Select avg (price) from titles),
Price-(Select avg (price) from titles) from titles;
##*********************************
## Q2-4-1: Pricing book based of various conditions:
## if publisher located in California then increase price by 10% 
## if the book has more than 1 authors then increase price by 5%
## if the book is sold more than 200$ then increase price by 2%
## else decrease price by 1%  
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
## Q2-4-2: Pricing book based of various conditions:
## if publisher located in California then increase price by 10% 
## if the book has more than 1 authors then increase price by 5%
## if the book is sold more than 200$ then increase price by 2%
## else decrease price by 1%  

create view titleauthor_view as
select title_id from titleauthor group by title_id having count(*) > 1;
create view title_view as  
select titles.title_id 
									from titles inner join 
								 sales on sales.title_id = titles.title_id 
								 group by titles.title_id 
								 having sum(qty*price) > 200;
                                 
select title_id , title  , 
		 case when pub_id in   (select pub_id from publishers where state = 'CA')							then price * 1.1 
	else case when title_id in (select * from titleauthor_view) then price * 1.05
	else case when title_id in (select * from title_view)											then price * 1.02
																										else price * .99
	end end end as newPrice
from titles ;
##-------------------------------------------------------------------------------------------------------------------
## Q2-5: adding indices to one or more tables
create index i_composite ON authors(au_fname, au_lname);
drop index i_composite ON authors;
select * from authors where au_lname like "%t%" and au_fname like "%n%";
## adding index for those columns that mostly appear in where
##-------------------------------------------------------------------------------------------------------------------
## Q2-6: Modifying employee table in order to have boss of each employee  
SET SQL_SAFE_UPDATES = 0;
alter table employee ADD 
    boss varchar(50) check (boss in ('Maria Pontes','Maria Pontes'))
    AFTER lname;
alter table employee drop boss;
alter table employee modify hire_date date;
drop view boss_view;
create view boss_view as
select emp_id, fname, minit, lname,
case when job_lvl > 150 then 'Maria Pontes'
						else 'Francisco Chang'
	end as boss, job_id, job_lvl, pub_id, hire_date
from employee;
select * from boss_view;

update employee
SET  boss = 'Maria Pontes'
WHERE job_lvl > 150;
update employee
SET boss = 'Francisco Chang'
WHERE job_lvl <= 150;

select * from employee;

##--------------------------------------------------------------------------------------------------------------------
## Q2-7: Migrating the jobs data into JobR which has integrity constraints and hope to make query faster from JobR  
create table JobR (jobID int Primary Key, JobDesc varchar(50) unique, MinLvl tinyint not null, MaxLvl tinyint not null);
insert into JobR select * from jobs where max_lvl > 100;
select * from JobR;