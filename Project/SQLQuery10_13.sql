/*
select  count( distinct title_id ) from sales 

select (select count(*) from titles ) -  count( distinct title_id ) from sales 
select 18 -  count( distinct title_id ) from sales 
select  count( titles.title_id ) 
	from sales right join titles on titles.title_id = sales.title_id 
where sales.title_id is null

select count(distinct title_id)  from titleauthor 

select * from publishers where pub_id in (select pub_id , pub_name  from titles)
select * from publishers where pub_id in ('1389','0736','0877')

select * from authors where au_id not in (select au_id from titleauthor)
select * from authors left join titleauthor on titleauthor.au_id = authors.au_id 
where title_id is null


select * from titles  where title_id not in (select title_id from sales)
select * from titles  where title_id  in (select title_id from sales)

select top(1) * from titles order by price desc


select * from titles where price in (select max(price) from titles)
select * from titles where price in (select distinct top(1) price from titles order by price desc )

select * from titles where price =
	(select min (price) from
	 (select  distinct top(5) price from titles order by price desc) as d)


select type , count(*)
 from titles 
 group by type

 select type , avg(price)
 from titles 
 group by type

select sum(qty) from sales 

select title_id ,  sum(qty) 
	from sales 
	group by title_id 


select titles.title_id , title , sum(qty) 
	from titles inner join 
		 sales on sales.title_id = titles.title_id 
		 group by  titles.title_id , title


select  sum(qty*price) 
	from titles inner join 
		 sales on sales.title_id = titles.title_id 

select titles.title_id , title , sum(qty*price) 
	from titles inner join 
		 sales on sales.title_id = titles.title_id 
		 group by  titles.title_id , title


select pub_id , sum (qty*price)
	 from titles inner join 
	 sales on sales.title_id = titles.title_id 
group by pub_id 

select title_id , count(*)
	 from titleauthor 
	group by title_id 

select titles.title_id , title , Count(au_id) as CountAu
	from titles 
		left join titleauthor  on titleauthor.title_id = titles.title_id 
group by titles.title_id , title 
order by 3


select authors.au_id , au_fname , au_lname , COUNT(title_id)
	from titleauthor 
		right join authors on authors.au_id = titleauthor.au_id 
		group by authors.au_id , au_fname , au_lname 


select titles.title_id , title , sum(qty*price) 
	from titles inner join 
		 sales on sales.title_id = titles.title_id 
		 group by  titles.title_id , title
		 having sum(qty*price) > 200


select titles.title_id , title , sum(qty*price) 
	from titles inner join 
		 sales on sales.title_id = titles.title_id 
		 where type = 'business'
		 group by  titles.title_id , title
	
select titles.title_id , title , sum(qty*price) 
	from titles inner join 
		 sales on sales.title_id = titles.title_id 
		 group by  titles.title_id , title , type
		 having type = 'business'


select titles.title_id , title , Count(au_id) as CountAu
	from titles 
		inner join titleauthor  on titleauthor.title_id = titles.title_id 
group by titles.title_id , title 
having  Count(au_id) > 1
order by 3	 

select authors.au_id , au_fname , au_lname , sum(qty*price/CoAu) 
	from	   titles 
	inner join sales on sales.title_id = titles.title_id 
	inner join titleauthor on titleauthor.title_id = titles.title_id 
	inner join authors on authors.au_id = titleauthor.au_id 
	inner join (select title_id , Count(*) as CoAu from titleauthor group by title_id ) as tblCoAu on tblCoAu.title_id = titles.title_id 
	group by authors.au_id , au_fname , au_lname 


select authors.au_id , au_fname , au_lname , TiCo 
	from authors 
	inner join (select au_id , count(*) as TiCo from titleauthor group by au_id) as tblTiCo on tblTiCo.au_id = authors.au_id 


select title_id , title , price -(select  avg(price) from titles)
	 from titles 

select title_id , title , price - AvgTi , AvgTi 
	from titles cross join (select avg(price) as AvgTi from titles ) as f


select (select count(*) from authors as B where A.au_id >= B.au_id) , au_id , au_fname , au_lname 
	from authors as A
	order by 1 


select ROW_NUMBER() over (order by au_id) ,  au_id , au_fname , au_lname 
 from authors 

 select  ROW_NUMBER() over (partition by type order by title_id) as Id ,title_id , title  , type
	from titles 

 select  rank() over (order by price desc) as Id ,title_id , title  , type ,price 
	from titles 

 select  DENSE_RANK() over (order by price desc) as Id ,title_id , title  , type ,price 
	from titles 


select * 
from
	(select rank() over (order by price desc) as Rank , title_id , title , price  
	 from titles ) as d
	where Rank = 5 

select * 
	from 
	(select rank() over (partition by type order by price desc) RankPrice , title_id , title , type , price  
	 from titles) as d
	 where RankPrice = 1
*/
select top(5) with ties  title_id , title , price 
	from titles
	order by price  desc

select * from authors where state in ( select state from authors where au_fname = 'livia' and au_lname = 'karsen')

select * from publishers where pub_id not in (select distinct pub_id from titles where type = 'business')
select * from publishers where pub_id  in (select distinct pub_id from titles where type != 'business')