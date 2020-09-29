show variables like 'have_query_cache';
SET SQL_SAFE_UPDATES = 0;
Use CrimeReports;
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));


-- Add Constraint

ALTER TABLE Victim
ADD CHECK (0 <=`Victim-age` and `Victim-age`<=120); 

Alter table ;

-- ------ ----

SET SQL_SAFE_UPDATES = 0;
Use CrimeReports;
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- Q8: Return the Status Description of the Crime in which the Are-Name in Foothill
-- joins and use joins with conditions 
-- the worse one is All therefore convert All to ref 
-- not catisean join but the joins on condition
-- how to drop foreign key


drop index Area_Name on `AREA-Dis`;
create index Area_Name on `AREA-Dis`(`Area-Name`);

select `Status-Description`
from `Status-Crime`
where `Status-Code`
IN (select `Status-Code` from Report
where `AREA-ID` 
IN (select `Area-ID` from `AREA-Dis`where  `Area-Name` ='Foothill'));


select distinct`Status-Description` 
from `Status-Crime` as S, Report as R ,`AREA-Dis` as A
where  S.`Status-Code` =R.`Status-Code` AND  R.`AREA-ID`=A.`AREA-ID` And `Area-Name` ='Foothill';

-- Q9: Return the Victim Descent that the Average Crime on them is greater than the minimum average Crime in 2013
--  Return the Victim-Desecent  age that their crime is report in 2013 and month 2
-- Find the number of the victim for each Desecent in the second month of the 2013
-- Then list the Victim Desecent that they count is more than the minimume Number of Victim Descent in 2013


create index victim_d on Victim(`Victim-Desecent'`);
create index victim_id on Victim(DR_number);

explain select `Victim-Desecent'`,count(`Victim-Desecent'`) as V
from Victim
where DR_number IN (select `DR-number`
from Report where YEAR(`new_date_Report`)=2013 AND Month(`new_date_Report`)=2)
group by `Victim-Desecent'`
HAVING V > (select MIN(V) FROM ((select count(`Victim-Desecent'`)/12 as V
from Victim where DR_number 
IN (select `DR-number` from Report where YEAR(`new_date_Report`)=2013) 
group by `Victim-Desecent'`)as t1)) 
order by V DESC
limit 2;

#####
explain select `Victim-Desecent'`,count(`Victim-Desecent'`) as V
from Victim inner join Report on Victim.DR_number= Report.`DR-number`
group by `Victim-Desecent'`
having V > (select MIN(V) FROM ((select count(`Victim-Desecent'`)/12 as V
from Victim where DR_number 
IN (select `DR-number` from Report where YEAR(`new_date_Report`)=2013) 
group by `Victim-Desecent'`)as t1)) 
order by V DESC
limit 2;


### Create View 
create view Victim_Num( Average,`Victim-Desecent'`) as 
select count(`Victim-Desecent'`)/12 as V, `Victim-Desecent'`
from Victim where DR_number 
IN (select `DR-number` from Report where YEAR(`new_date_Report`)=2013) 
group by `Victim-Desecent'`;


#### Optimize with view

select `Victim-Desecent'`,count(`Victim-Desecent'`) as V
from Victim inner join Report on Victim.DR_number= Report.`DR-number`
group by `Victim-Desecent'`
having V > (select MIN(Average) FROM Victim_Num)
order by V DESC
limit 2;

-- -----------------------------------
CREATE  INDEX  Area_Id ON `AREA-Dis`(`AREA-ID`);
CREATE  INDEX  Area_Id1 ON Report(`AREA-ID`);
CREATE  INDEX  Area_Nam ON `AREA-Dis`(`AREA-Name`);


-- Q12: Return The Crime type and the Area that is happened in 2010 and NOt 2013
-- view of Crime table with Crime and AreaId for the Crime of the 2013
-- it is not possible to 


create index `Crime-type` on Crime(`Crime-Description`);
create index Crime_Code on Crime(`Crime-Code`);
drop index `Crime-type` on Crime;



explain SELECT *
from Crimed2010 as C1
WHERE  NOT EXISTS
  (SELECT *
   FROM   Crimed2013 as C2
   WHERE  C1.CrimeCode=C2.CrimeCode);

explain select *
from Crimed2010 as C1 left join Crimed2013 as C2 
on C1.CrimeCode=C2.CrimeCode 
where C2.CrimeCode is null;



create view Crimed2013(Crime,Area,CrimeCode) as 
select  `Crime-Description`,`Area-Name`,R.`Crime-Code`
from `AREA-Dis` as A INNER JOIN Report as R
ON A.`AREA-ID`= R.`AREA-ID` 
INNER JOIN Crime as C on C.`Crime-Code`=R.`Crime-Code`
where YEAR(`new_date_Report`)=2013;

create view Crimed2010(Crime,Area,CrimeCode) as 
select  `Crime-Description`,`Area-Name`,R.`Crime-Code`
from `AREA-Dis` as A INNER JOIN Report as R
ON A.`AREA-ID`= R.`AREA-ID` 
INNER JOIN Crime as C on C.`Crime-Code`=R.`Crime-Code`
where YEAR(`new_date_Report`)=2010;


-- Q1: Return The Number of Victims for each sex that they are less than 18 years old


CREATE  INDEX Age_Id ON Victim(`Victim-age`);


Select `Victim-Sex'`,count(`Victim-Sex'`)
from Victim 
where `Victim-age`<18
group by `Victim-Sex'`;


-- ----------------
drop index `Permise-Description` on Permise;
Alter table `AREA-Dis` ADD FULLTEXT (`Area-Name`);
Alter table Permise ADD FULLTEXT (`Permise-Description`);

explain select *
from Report as R INNER JOIN `AREA-Dis` AS A 
on R.`AREA-ID`=A.`AREA-ID`
where A.`Area-Name` like '%WEST%' 
And `Permise-Code`
NOT IN( select `Permise-Code`  FROM Permise WHERE `Permise-Description` Like('%PARK%') );


explain select *
from Report as R INNER JOIN `AREA-Dis` AS A 
on R.`AREA-ID`=A.`AREA-ID`
where A.`Area-Name` like '%WEST%' 
And `Permise-Code`
NOT IN( select `Permise-Code`  FROM Permise WHERE match(`Permise-Description`) against('%PARK%') );
