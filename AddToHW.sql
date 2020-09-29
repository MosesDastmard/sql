use pubs;




create table JobR (jobID int Primary Key, JobDesc varchar(50) unique, MinLvl tinyint not null, MaxLvl tinyint not null);
insert into JobR select * from jobs where max_lvl > 100;
select * from JobR;



select ROW_NUMBER() over (order by au_id) ,  au_id , au_fname , au_lname 
 from authors;
select  ROW_NUMBER() over (partition by type order by title_id) as Id ,title_id , title  , type
	from titles;
select  rank() over (order by price desc) as Id ,title_id , title  , type ,price 
	from titles;
select  DENSE_RANK() over (order by price desc) as Id ,title_id , title  , type ,price 
	from titles;







## explane/index

create view vwSaleTitle
as
	select titles.title_id, title , pub_id , type , price , sum(qty*price) SaleAmount
	 from titles inner join 
		  sales on sales.title_id = titles.title_id 
		  group  by titles.title_id, title , pub_id , type , price;
select * from vwSaleTitle inner join publishers on publishers.pub_id = vwSaleTitle.pub_id where SaleAmount > 800; ##(publishers and titles sold more than 800)
select sum(SaleAmount) from vwSaleTitle; ## total sale (all books)

