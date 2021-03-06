CREATE TABLE [dbo].[Lesson](
	[LessonID] [tinyint] NOT NULL,
	[LessonName] [nvarchar](50) NOT NULL,
	[LessonIDReq] [tinyint] NULL,
	[LessonTime] [tinyint] NULL) ON [PRIMARY]

GO
INSERT [dbo].[Lesson] ([LessonID], [LessonName], [LessonIDReq], [LessonTime]) VALUES (1, N'.Net', NULL, 3)
GO
INSERT [dbo].[Lesson] ([LessonID], [LessonName], [LessonIDReq], [LessonTime]) VALUES (2, N'C# 1', 1, 2)
GO
INSERT [dbo].[Lesson] ([LessonID], [LessonName], [LessonIDReq], [LessonTime]) VALUES (3, N'C# 2', 2, 3)
GO
INSERT [dbo].[Lesson] ([LessonID], [LessonName], [LessonIDReq], [LessonTime]) VALUES (4, N'Sql', 3, 3)
GO
INSERT [dbo].[Lesson] ([LessonID], [LessonName], [LessonIDReq], [LessonTime]) VALUES (5, N'Reporting', 4, 2)
GO
INSERT [dbo].[Lesson] ([LessonID], [LessonName], [LessonIDReq], [LessonTime]) VALUES (6, N'SSIS', 4, 2)
GO
