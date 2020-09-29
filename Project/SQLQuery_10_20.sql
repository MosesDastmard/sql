select * from publishers where        exists    (select * from titles where titles.pub_id = publishers.pub_id)
select * from publishers where pub_id in        (select pub_id from titles)

select * from authors where not exists (select * from titleauthor where titleauthor.au_id = authors.au_id)

select * from publishers where not exists (select * from titles where titles.pub_id = publishers.pub_id and type = 'business')
select * from publishers where pub_id not in (select pub_id from titles where type = 'business')
select * from publishers where pub_id in (select pub_id from titles where type != 'business')
select title_id , title  ,

	case type 
		when 'mod_cook'     then 'Modern Cooking'
		when 'trad_cook'    then 'Tradintional Cooking'
		when 'popular_Comp' then 'Papular Coputer '
							else  type
	end as newType

	from titles 

select title_id , title , price , 
	case when price > 10 then price * 1.1 
						 else price * .95
	end as newPrice 
from titles 

select title_id, title , 
	case when state = 'CA' then price * 1.1 
						   else price * .95
	end as newPrice
from titles inner join publishers on publishers.pub_id = titles.pub_id 

select title_id, title , 
	case when pub_id in (select pub_id from publishers where state = 'CA') then price * 1.1 
																	       else price * .95
	end as newPrice 
from titles 

select titles.title_id , title , 
	case when sum(qty*price) > 500 then price * 1.1
								   else price * .95
	end
from titles inner join 
	 sales on sales.title_id = titles.title_id 
	 group by titles.title_id , title , price 

select * ,
	case when title_id in (select titles.title_id 
							from titles inner join 
								 sales on sales.title_id = titles.title_id 
								 group by titles.title_id 
								 having sum(qty*price) > 500)	then price * 1.1
																else price * .95
	end 

from titles 

select titles.title_id , title , 
	case when count(au_id) > 1 then price * 1.1
							   else price * .95
	end 
from titles inner join titleauthor on titleauthor.title_id = titles.title_id 
	group by titles.title_id , title ,price 

select title_id , title , 
		case when title_id in ( select title_id from titleauthor group by title_id having count(*) > 1 ) then price * 1.1
																										 else price * .95
		end
	 from titles 

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


from titles 

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
		 group by  titles.title_id , title , price , state , CoAu 

select titles.title_id , title , sum(qty*price),
	
	case when sum(qty*price) < 200  then 0
	     when sum(qty*price) < 500  then 0 + (sum(qty*price) - 200 ) * .05 
		 when sum(qty*price) < 800  then 0 + (300 * .05)				  +(sum(qty*price) - 500 ) * .10 
		 when sum(qty*price) < 1000 then 0 + (300 * .05)				  +   (300 * .10 )               +  (sum(qty*price) - 800 ) * .15 
									else 0 + (300 * .05)				  +   (300 * .10 )               +  (200 * .15 )				  + (sum(qty*price) - 1000 ) * .20
	 end
	from titles inner join 
		 sales on sales.title_id = titles.title_id 
		group by titles.title_id , title 

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
		group by titles.title_id , title) as d 


;with cteSale (title_id , title , SaleAmount)
	as	(select titles.title_id , title , sum(qty*price)
		 from sales inner join titles on titles.title_id = sales.title_id
		 group by titles.title_id , title )

select * ,
	case when SaleAmount < 200  then 0
		  when SaleAmount < 500  then 0 +				 (SaleAmount - 200)  * .05
		  when SaleAmount < 800  then 0 + 15 +			 (SaleAmount - 500)  * .10
		  when SaleAmount < 1000 then 0 + 15 + 30 +		 (SaleAmount - 800)  * .15
								 else 0 + 15 + 30 + 30 + (SaleAmount - 1000) * .20   
	end as Tax 

 from cteSale 

;with cteCoAu (title_id , CoAu)
as
	(select title_id , count(*) from titleauthor 
		group by title_id )

select authors.au_id , au_fname , au_lname , sum(qty * price / CoAu) 
	from	   titles 
	inner join sales on sales.title_id = titles.title_id 
	inner join titleauthor on titleauthor.title_id = titles.title_id 
	inner join authors on authors.au_id = titleauthor.au_id 
	inner join cteCoAu on cteCoAu.title_id = titles.title_id 
	group by authors.au_id , au_fname , au_lname

;with cteCoAu(title_id , CoAu)
as
	(select title_id , count(*)
		 from titleauthor group by title_id)
	,cteSale(title_id, SaleAmount)
as
	(select titles.title_id , sum(qty*price)
		  from sales inner join titles on titles.title_id = sales.title_id 
	group by titles.title_id )	


	select authors.au_id , au_fname , au_lname , sum(SaleAmount / CoAu) 
		from cteSale inner join 
			 cteCoAu on cteCoAu.title_id = cteSale.title_id inner join 
			 titleauthor on titleauthor.title_id = cteSale.title_id inner join 
			 authors on authors.au_id = titleauthor.au_id 
	group by authors.au_id , au_fname , au_lname

;with cteNewPrice(title_id ,title , price , State , CoAu , SaleAmount)
as
	(select titles.title_id , title , price , state , CoAu , sum(qty*price)
			   from titles inner join 
					sales on sales.title_id = titles.title_id inner join 
					publishers on publishers.pub_id = titles.pub_id inner join 
					(select title_id , count(*) as CoAu from titleauthor group by title_id) as d on d.title_id = titles.title_id 
					group by titles.title_id , title , price , state ,CoAu)
	
	
select * , 
		 case when State = 'CA'     then price * 1.10 
	else case when CoAu > 1			then price * 1.05
	else case when saleAmount > 200 then price * 1.02
									else price * .99
	end end end as newPrice
from cteNewPrice 	 
	  
				