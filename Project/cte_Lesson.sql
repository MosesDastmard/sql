with cte_Lesson(LessonID, LessonName,lvl , Path)
as
	(select LessonID, LessonName, 1 as lvl , CONVERT(nvarchar(max), LessonName) as Path
		 from Lesson where LessonIDReq is null
	 union all
	 select l.LessonID , l.LessonName , lvl + 1 , Path + '/' + l.LessonName 
	  from Lesson as l inner join cte_Lesson on cte_Lesson.LessonID = l.LessonIDReq )
select * from cte_Lesson 