with 
	cte_Path(ID, Name , lvl , Path)
	as
	(select ID, Name , 1 lvl , CONVERT(varchar(max) , name) Path
		 from Geo where ParentID is null
	 union all
	 select Geo.ID , Geo.Name , lvl +1 , Path + '/' + Geo.Name 
	  from Geo inner join cte_Path on Geo.ParentID = cte_Path.ID)

select * from cte_Path 