/*
create table JobsLog (Id int primary key identity,
					  job_id int ,
					  job_desc varchar(50),
					  min_lvl tinyint,
					  max_lvl tinyint,
					  ChangeType char(1),
					  Username nvarchar(max),
					  Hostname nvarchar(max),
					  ChangeDate smalldatetime)
*/

alter trigger ti_jobs on jobs
for insert, update , delete 
as
begin
		

	
		insert into JobsLog (job_id , job_desc , min_lvl , max_lvl , ChangeType , ChangeDate , Hostname , Username )
					  select job_id , job_desc , min_lvl , max_lvl , 'd'        , getdate()  , hostname , nt_username 
			from deleted cross join (select hostname , nt_username  from sys.sysprocesses where spid = @@SPID) as d

		insert into JobsLog (job_id , job_desc , min_lvl , max_lvl , ChangeType , ChangeDate , Hostname , Username )
					  select job_id , job_desc , min_lvl , max_lvl , 'i'        , getdate()  , hostname , nt_username 
					    from inserted cross join (select hostname , nt_username  from sys.sysprocesses where spid = @@SPID) as d
end
go

select * from JobsLog 

delete jobs where job_id = 17
insert into jobs values ('Developer123' , 100 , 200)
update jobs set min_lvl = 150 where job_id = 18

create table Factor	   (FactorID int identity(1,1) primary key , 
						FacDate char(8) , 
						CustomerID int ,
						FactSum money default(0) )

create table FactorDet (FactorID_FAC int foreign key references Factor(FactorID) ,	
						ProductID_FAC int ,
						Qty tinyint,
						Price money,
						constraint PK_Fac_Pro primary key (FactorID_FAC,ProductID_FAC))

create trigger tiFactorDet on FactorDet
for insert , update , delete
as
begin

		update Factor set FactSum = FactSum - (Qty * Price)
			from 
			Factor inner join deleted on FactorID = FactorID_FAC 

		update Factor set FactSum = FactSum + (Qty * Price)
			from 
			Factor inner join inserted on FactorID = FactorID_FAC 
	

end
go

insert into Factor (FacDate , CustomerID ) values ('13971125', 1)
insert into Factor (FacDate , CustomerID ) values ('13971125', 2)
insert into Factor (FacDate , CustomerID ) values ('13971125', 3)

select * from Factor 

create trigger tiJobsDelete on jobs
instead of delete
as
begin
	delete jobs where job_id in (select job_id from deleted ) and CheckDelete = 1
	update jobs set CheckDelete = 1 where job_id in (select job_id from deleted)
		
end
go
select * from jobs where CheckDelete = 1
select * from jobs where CheckDelete = 0
delete jobs where job_id = 19