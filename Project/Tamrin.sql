use University 
select StudentID, StudenFirstname , StudentLastname , count(*)
	from Student inner join 
		 ClassStudent on StudentID_LST = StudentID
	group by StudentID , StudenFirstname , StudentLastname 

select StudentID, StudenFirstname , StudentLastname , sum(LessonUnit)
	from Student inner join 
		 ClassStudent on StudentID_LST = StudentID inner join 
		 Class on ClassID = ClassID_LST inner join Lesson on LessonID = LessonID_CLS  
	group by StudentID , StudenFirstname , StudentLastname 

select * 
	from Teacher 
	where TeacherID not in (select TeacherID_CLS from Class)

select * 
	from Teacher left join 
		 Class on TeacherID_CLS = TeacherID 
	where ClassID  is null

select RANK() over (order by avgStudent desc) , * 
from 
	(select StudentID ,avg (Point) as AvgStudent  
	 from Student inner join ClassStudent on StudentID = StudentID_LST
	 group by StudentID  ) as d

select LessonID , LessonDesc , count(*) 
	from Lesson inner join 
		 Class on LessonID = LessonID_CLS inner join 
		 ClassStudent on ClassID = ClassID_LST 
	group by LessonID , LessonDesc 

select * 
	from Lesson 
	where LessonID not in (select LessonID_CLS from Class where TeacherID_CLS is null) 

select StudentID, StudenFirstname , StudentLastname , count(*)
	from Student inner join 
		 ClassStudent on StudentID_LST = StudentID inner join 
		 Class on ClassID = ClassID_LST inner join Lesson on LessonID = LessonID_CLS  
	where LessonUnit >=3
	group by StudentID , StudenFirstname , StudentLastname 
	having  count(*) >= 3

select  top 1 with ties TeacherID , count(*) CoClass 
	from Teacher inner join 
		 Class on TeacherID_CLS = TeacherID 
	group by TeacherID 
	order by CoClass 
	
 
	
