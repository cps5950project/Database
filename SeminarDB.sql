USE [master]
GO
/****** Object:  Database [SeminarDB]    Script Date: 11/8/2018 9:27:45 PM ******/
CREATE DATABASE [SeminarDB] ON  PRIMARY 
( NAME = N'SeminarDB', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL10.SQLEXPRESS\MSSQL\DATA\SeminarDB.mdf' , SIZE = 2048KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SeminarDB_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL10.SQLEXPRESS\MSSQL\DATA\SeminarDB_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [SeminarDB] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SeminarDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SeminarDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SeminarDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SeminarDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SeminarDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SeminarDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [SeminarDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SeminarDB] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [SeminarDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SeminarDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SeminarDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SeminarDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SeminarDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SeminarDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SeminarDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SeminarDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SeminarDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SeminarDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SeminarDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SeminarDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SeminarDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SeminarDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SeminarDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SeminarDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SeminarDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [SeminarDB] SET  MULTI_USER 
GO
ALTER DATABASE [SeminarDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SeminarDB] SET DB_CHAINING OFF 
GO
USE [SeminarDB]
GO
/****** Object:  StoredProcedure [dbo].[CencelEnrollment]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[CencelEnrollment]
@enroll_id as bigint = Null

AS
Begin
	Set NoCount On		

	Set @enroll_id = NullIf(@enroll_id, 0)		
	
	Update SeminarEnrollment Set	 
	seminar_id=-1
	
	where enroll_id=@enroll_id
	
		
End

GO
/****** Object:  StoredProcedure [dbo].[DeleteSeminar]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[DeleteSeminar]
@seminar_id as bigint = Null

AS
Begin
	Set NoCount On		

	Set @seminar_id = NullIf(@seminar_id, 0)		
	
	Update Seminar Set	 
	
	deleted='true'      
	where seminar_id=@seminar_id
	
		
End

GO
/****** Object:  StoredProcedure [dbo].[GetDeptAll]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[GetDeptAll]

AS
Begin
	Set NoCount On

	-----------------Get Users

	select department_id, department_name, deleted
	from [dbo].[Department] where isnull(Deleted,'0') =0
	

	
	
	End

GO
/****** Object:  StoredProcedure [dbo].[GetSeminar_EnrollAll]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSeminar_EnrollAll]
@UserID as bigint = Null
AS
Begin
	Set NoCount On
	Set @UserID = NullIf(@UserID, 0)		

	-------------------

	select seminar_id, seminar_title, organizar_name, place, Seminartime,
	 
	 (CONVERT(datetime, CONVERT(varchar, seminar_date, 100))) as seminar_date,
	   department_id, TermID, active, deleted
	   ,isnull((select top 1 enroll_id from SeminarEnrollment where seminar_id=Seminar.seminar_id and UserID=@UserID),'-1') as EnrollStatus_enroll_id
	    ,(select top 1 department_name from Department where department_id=Seminar.department_id ) as department_name
		,(select top 1 TermName from Term where TermID=Seminar.TermID ) as TermName


	from [dbo].[Seminar]
	 where isnull(Deleted,'0') =0
	order by seminar_date desc

	
	
	End

GO
/****** Object:  StoredProcedure [dbo].[GetSeminar_EnrollByCriteria]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSeminar_EnrollByCriteria]
@UserID as bigint = Null,
@TermID as bigint = Null,
@department_id as bigint = Null

AS
Begin
	Set NoCount On
	Set @UserID = NullIf(@UserID, 0)		

	-------------------

	select seminar_id, seminar_title, organizar_name, place, Seminartime,
	 
	 (CONVERT(datetime, CONVERT(varchar, seminar_date, 100))) as seminar_date,
	   department_id, TermID, active, deleted
	   ,isnull((select top 1 enroll_id from SeminarEnrollment where seminar_id=Seminar.seminar_id and UserID=@UserID),'-1') as EnrollStatus_enroll_id
	    ,(select top 1 department_name from Department where department_id=Seminar.department_id ) as department_name
		,(select top 1 TermName from Term where TermID=Seminar.TermID ) as TermName


	from [dbo].[Seminar]
	 where isnull(Deleted,'0') =0
and department_id=@department_id
and TermID=@TermID
	order by seminar_date desc

	
	
	End

GO
/****** Object:  StoredProcedure [dbo].[GetSeminarAll]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSeminarAll]

AS
Begin
	Set NoCount On

	-------------------

	select seminar_id, seminar_title, organizar_name, place, Seminartime,
	 
	 (CONVERT(datetime, CONVERT(varchar, seminar_date, 100))) as seminar_date,
	   department_id, TermID, active, deleted
	from [dbo].[Seminar]
	 where isnull(Deleted,'0') =0
	order by seminar_date desc

	
	
	End

GO
/****** Object:  StoredProcedure [dbo].[GetSeminarByCat]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSeminarByCat]

AS
Begin
	Set NoCount On

	-------------------

	select seminar_id, seminar_title, organizar_name, place, Seminartime,
	 
	 (CONVERT(datetime, CONVERT(varchar, seminar_date, 100))) as seminar_date,
	   department_id, TermID, active, deleted
	   ,isnull((select top 1 enroll_id from SeminarEnrollment where seminar_id=Seminar.seminar_id ),'-1') as EnrollStatus_enroll_id
	    ,(select top 1 department_name from Department where department_id=Seminar.department_id ) as department_name
		,(select top 1 TermName from Term where TermID=Seminar.TermID ) as TermName


	from [dbo].[Seminar]
	 where isnull(Deleted,'0') =0
	order by seminar_date desc

	
	
	End

GO
/****** Object:  StoredProcedure [dbo].[GetSeminarForEdit]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[GetSeminarForEdit]
@seminar_id as bigint = Null
AS
Begin
	Set NoCount On
	
	select seminar_id, seminar_title, organizar_name, place, Seminartime, seminar_date, department_id, TermID, active, deleted
	 
	 from Seminar where isnull(Deleted,'0') =0
	 and seminar_id=@seminar_id
	
	End

GO
/****** Object:  StoredProcedure [dbo].[GetTermAll]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[GetTermAll]

AS
Begin
	Set NoCount On

	

	select TermID, TermName
	from [dbo].[Term] where isnull(Deleted,'0') =0
	

	
	
	End

GO
/****** Object:  StoredProcedure [dbo].[SaveSeminar]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveSeminar]
@seminar_id as bigint = Null,
@seminar_title as varchar(300) = Null,
@organizar_name As varchar(200) = Null

,@place As varchar(50) = Null
,@Seminartime As varchar(50) = Null
,@seminar_date As varchar(50) = Null
,@department_id as bigint = Null
,@TermID as bigint = Null

,@active as bit=Null
AS
Begin
	Set NoCount On
		

	Set @seminar_id = NullIf(@seminar_id, 0)	
	
	
	Set @seminar_title = NullIf(@seminar_title, '')	
	Set @organizar_name = Nullif(@organizar_name, '')
	
	Set @place = Nullif(@place, '')
	Set @Seminartime = Nullif(@Seminartime, '')
	Set @seminar_date = Nullif(@seminar_date, '')
	
	Set @department_id = NullIf(@department_id, '')
	Set @TermID = NullIf(@TermID, '')
	
	


If (@seminar_id Is Null)
	Begin
	
	--insert into  table
		Set @seminar_id = (Select IsNull(Max(seminar_id), 0) + 1 From Seminar)
		Insert Into Seminar
		(
			seminar_id, 
			seminar_title,
			organizar_name, 
			place, 
			Seminartime,
			seminar_date, 
			department_id, 
			TermID, 
			active,
			deleted
			
			
		
			
		)
		Values
		(
			

			@seminar_id, 
			@seminar_title,
			@organizar_name, 
			@place, 
			@Seminartime,
			@seminar_date, 
			@department_id, 
			@TermID, 
			@active,
			'false'
			
			
		)
		
		End
	Else
	Begin
		--Update 
		
		Update Seminar Set
		seminar_title=@seminar_title
		,organizar_name=@organizar_name
		
		,place=@place
		,Seminartime=@Seminartime
		,seminar_date=@seminar_date		
		,department_id=@department_id
		,TermID=@TermID
		,active=@active
		,Deleted='false'
		
		where seminar_id=@seminar_id
		end
		
End

GO
/****** Object:  StoredProcedure [dbo].[SaveSeminar_Enrollment]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveSeminar_Enrollment]
@enroll_id as bigint = Null,
@seminar_id as bigint = Null,
@UserID as bigint = Null

AS
Begin
	Set NoCount On
		

	Set @enroll_id = NullIf(@enroll_id, 0)	
	Set @seminar_id = NullIf(@seminar_id, 0)	
	Set @UserID = NullIf(@UserID, 0)	
	
	


If (@enroll_id Is Null)
	Begin
	
	--insert into  table
		Set @enroll_id = (Select IsNull(Max(enroll_id), 0) + 1 From SeminarEnrollment)
		Insert Into SeminarEnrollment
		(
			enroll_id, 
			seminar_id,
			UserID, 
			
			active,
			deleted
			
			
		
			
		)
		Values
		(
			

			@enroll_id, 
			@seminar_id,
			@UserID, 
			'true',	
			'false'
			
			
		)
		
		End
	Else
	Begin
		--Update 

		Update SeminarEnrollment Set
		seminar_id=@seminar_id,
	    UserID=@UserID
		
		where enroll_id=@enroll_id


		end
		
End

GO
/****** Object:  StoredProcedure [dbo].[sp_spDeleteUser]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_spDeleteUser]
@UserID as bigint = Null

AS
Begin
	Set NoCount On		

	Set @UserID = NullIf(@UserID, 0)		
	
	Update users Set	 
	
	deleted='true'      
	where UserID=@UserID
	
		
End

GO
/****** Object:  StoredProcedure [dbo].[sp_spGetLoginInfo]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_spGetLoginInfo]
@login_name As varchar(50) = Null
,@Password As varchar(50) = Null

AS
Begin
	Set NoCount On

	-----------------Get Users
	select UserID,login_name,Password,role_id,last_name,first_name,UserEmail from Users where isnull(Deleted,'0') =0
	and isnull(active,'1') =1
	and login_name=@login_name and Password=@Password
	
	--------------Get roles
	select role_id,role_name from Roles
	
	End

GO
/****** Object:  StoredProcedure [dbo].[sp_spGetRoles]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_spGetRoles]

AS
Begin
	Set NoCount On
	
	select role_id,role_name from Roles where isnull(Deleted,'0') =0
	
	End

GO
/****** Object:  StoredProcedure [dbo].[sp_spGetUserDataForGrid]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_spGetUserDataForGrid]

AS
Begin
	Set NoCount On
	
	select UserID,first_name,last_name,login_name,active from Users where isnull(Deleted,'0') =0
	
	End

GO
/****** Object:  StoredProcedure [dbo].[sp_spGetUserForEdit]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_spGetUserForEdit]
@UserID as bigint = Null
AS
Begin
	Set NoCount On
	
	select UserID, role_id,
	 first_name, last_name, phone, login_name, 
	 [Password] as [Password], isnull(active,'1') as active,UserEmail
	 from Users where isnull(Deleted,'0') =0
	 and UserID=@UserID
	
	End

GO
/****** Object:  StoredProcedure [dbo].[sp_spSaveUser]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_spSaveUser]
@UserID as bigint = Null,
@first_name as varchar(50) = Null,
@last_name As varchar(50) = Null,
@UserEmail As varchar(50) = Null

,@phone As varchar(50) = Null
,@login_name As varchar(50) = Null
,@Password As varchar(50) = Null
,@role_id as bigint = Null
,@active as bit=Null
AS
Begin
	Set NoCount On
		

	Set @UserID = NullIf(@UserID, 0)	
	
	
	Set @first_name = NullIf(@first_name, '')	
	Set @last_name = Nullif(@last_name, '')
	Set @UserEmail = Nullif(@UserEmail, '')
	
	Set @phone = Nullif(@phone, '')
	Set @login_name = Nullif(@login_name, '')
	Set @Password = Nullif(@Password, '')
	
	Set @role_id = NullIf(@role_id, '')
	
	


If (@UserID Is Null)
	Begin
	
	--insert into user table
		Set @UserID = (Select IsNull(Max(UserID), 0) + 1 From Users)
		Insert Into Users
		(
			UserID,first_name,last_name
			,UserEmail
			,phone
			,login_name
			,Password
			,role_id
			,active
			,Deleted
			
		)
		Values
		(
			@UserID,@first_name,@last_name
			,@UserEmail
			,@phone
			,@login_name
			,@Password
			,@role_id
			,@active
			,'false'
			
			
		)
		
		End
	Else
	Begin
		--Update Users
		
		Update Users Set
		first_name=@first_name
		,last_name=@last_name
		,UserEmail=@UserEmail
		,phone=@phone
		,login_name=@login_name
		,role_id=@role_id		
		,Password=@Password
		,active=@active
		,Deleted='false'
		
		where UserID=@UserID
		end
		
End

GO
/****** Object:  Table [dbo].[Department]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Department](
	[department_id] [bigint] NOT NULL,
	[department_name] [varchar](100) NULL,
	[deleted] [bit] NULL,
 CONSTRAINT [PK_department] PRIMARY KEY CLUSTERED 
(
	[department_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Roles](
	[role_id] [int] NOT NULL,
	[role_name] [varchar](50) NULL,
	[Deleted] [bit] NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Seminar]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Seminar](
	[seminar_id] [bigint] NULL,
	[seminar_title] [nvarchar](300) NULL,
	[organizar_name] [nvarchar](200) NULL,
	[place] [nvarchar](50) NULL,
	[Seminartime] [nvarchar](50) NULL,
	[seminar_date] [datetime] NULL,
	[department_id] [bigint] NULL,
	[TermID] [bigint] NULL,
	[active] [bit] NULL,
	[deleted] [bit] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SeminarEnrollment]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SeminarEnrollment](
	[enroll_id] [bigint] NOT NULL,
	[seminar_id] [bigint] NULL,
	[UserID] [bigint] NULL,
	[deleted] [bit] NULL,
	[active] [bit] NULL,
 CONSTRAINT [PK_SeminarEnrollment] PRIMARY KEY CLUSTERED 
(
	[enroll_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Term]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Term](
	[TermID] [bigint] NOT NULL,
	[TermName] [nvarchar](50) NULL,
	[Deleted] [bit] NULL,
 CONSTRAINT [PK_Term] PRIMARY KEY CLUSTERED 
(
	[TermID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 11/8/2018 9:27:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [bigint] NOT NULL,
	[role_id] [int] NULL,
	[first_name] [varchar](50) NULL,
	[last_name] [varchar](50) NULL,
	[phone] [varchar](50) NULL,
	[login_name] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
	[active] [bit] NULL,
	[Deleted] [bit] NULL,
	[UserEmail] [nvarchar](50) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[Department] ([department_id], [department_name], [deleted]) VALUES (1, N'CS', 0)
INSERT [dbo].[Department] ([department_id], [department_name], [deleted]) VALUES (2, N'
Math', 0)
INSERT [dbo].[Department] ([department_id], [department_name], [deleted]) VALUES (3, N'Business', 0)
INSERT [dbo].[Department] ([department_id], [department_name], [deleted]) VALUES (4, N'Nursing', 0)
INSERT [dbo].[Roles] ([role_id], [role_name], [Deleted]) VALUES (1, N'student', 0)
INSERT [dbo].[Roles] ([role_id], [role_name], [Deleted]) VALUES (2, N'admin', 0)
INSERT [dbo].[Roles] ([role_id], [role_name], [Deleted]) VALUES (3, N'organizer', 0)
INSERT [dbo].[Seminar] ([seminar_id], [seminar_title], [organizar_name], [place], [Seminartime], [seminar_date], [department_id], [TermID], [active], [deleted]) VALUES (1, N'seminar title', N'organizar', N'place', N'seminar title', CAST(0x0000A98D00000000 AS DateTime), 1, 1, 1, 1)
INSERT [dbo].[Seminar] ([seminar_id], [seminar_title], [organizar_name], [place], [Seminartime], [seminar_date], [department_id], [TermID], [active], [deleted]) VALUES (2, N'Publishing Information while Preserving Data Privacy', N'Dr. Javam C. Machado', N'Central King Building (CKB) Room 116', N'2:30 PM - 3:30 PM', CAST(0x0000A9B500000000 AS DateTime), 1, 1, 1, 0)
INSERT [dbo].[Seminar] ([seminar_id], [seminar_title], [organizar_name], [place], [Seminartime], [seminar_date], [department_id], [TermID], [active], [deleted]) VALUES (3, N'Network Virtual and Augmented Reality: The New Frontier', N'Dr. Jacob Chakareski University of Alabama', N'Central King Building (CKB) Room 116', N'2:30 PM - 4:00 PM', CAST(0x0000A9A700000000 AS DateTime), 1, 2, 1, 0)
INSERT [dbo].[Seminar] ([seminar_id], [seminar_title], [organizar_name], [place], [Seminartime], [seminar_date], [department_id], [TermID], [active], [deleted]) VALUES (4, N'b', NULL, NULL, NULL, NULL, 1, 1, 1, 1)
INSERT [dbo].[Seminar] ([seminar_id], [seminar_title], [organizar_name], [place], [Seminartime], [seminar_date], [department_id], [TermID], [active], [deleted]) VALUES (5, N'Engineering Practical End-To-End Verifiable Voting Systems', N'Dr. Richard Carback', N'GITC 4415', N'2:30 PM - 3:30 PM', CAST(0x0000A9B500000000 AS DateTime), 1, 1, 1, 0)
INSERT [dbo].[Seminar] ([seminar_id], [seminar_title], [organizar_name], [place], [Seminartime], [seminar_date], [department_id], [TermID], [active], [deleted]) VALUES (6, N'Mining Big Data Using Kernel', N'Dr. Kai Zhang', N'GITC 4415', N'2:30 PM - 3:30 PM', CAST(0x0000A9B400000000 AS DateTime), 2, 1, 1, 0)
INSERT [dbo].[Seminar] ([seminar_id], [seminar_title], [organizar_name], [place], [Seminartime], [seminar_date], [department_id], [TermID], [active], [deleted]) VALUES (7, N'Do You Have What It Takes To Become An Entrepreneur?', N'Michael Skarzynski, CEO Intera Group, Inc', N'GITC 4415', N'2:30 PM - 3:30 Pm', CAST(0x0000A99A00000000 AS DateTime), 3, 2, 1, 0)
INSERT [dbo].[SeminarEnrollment] ([enroll_id], [seminar_id], [UserID], [deleted], [active]) VALUES (1, -1, 5, 0, 1)
INSERT [dbo].[SeminarEnrollment] ([enroll_id], [seminar_id], [UserID], [deleted], [active]) VALUES (2, -1, 5, 0, 1)
INSERT [dbo].[SeminarEnrollment] ([enroll_id], [seminar_id], [UserID], [deleted], [active]) VALUES (3, -1, 5, 0, 1)
INSERT [dbo].[SeminarEnrollment] ([enroll_id], [seminar_id], [UserID], [deleted], [active]) VALUES (4, 5, 5, 0, 1)
INSERT [dbo].[SeminarEnrollment] ([enroll_id], [seminar_id], [UserID], [deleted], [active]) VALUES (5, 6, 5, 0, 1)
INSERT [dbo].[SeminarEnrollment] ([enroll_id], [seminar_id], [UserID], [deleted], [active]) VALUES (6, -1, 5, 0, 1)
INSERT [dbo].[SeminarEnrollment] ([enroll_id], [seminar_id], [UserID], [deleted], [active]) VALUES (7, 7, 5, 0, 1)
INSERT [dbo].[SeminarEnrollment] ([enroll_id], [seminar_id], [UserID], [deleted], [active]) VALUES (8, 5, 6, 0, 1)
INSERT [dbo].[SeminarEnrollment] ([enroll_id], [seminar_id], [UserID], [deleted], [active]) VALUES (9, 3, 6, 0, 1)
INSERT [dbo].[Term] ([TermID], [TermName], [Deleted]) VALUES (1, N'Fall 2018', NULL)
INSERT [dbo].[Term] ([TermID], [TermName], [Deleted]) VALUES (2, N'Spring 2019', NULL)
INSERT [dbo].[Term] ([TermID], [TermName], [Deleted]) VALUES (3, N'Sumper 2019', NULL)
INSERT [dbo].[Users] ([UserID], [role_id], [first_name], [last_name], [phone], [login_name], [Password], [active], [Deleted], [UserEmail]) VALUES (1, 1, N'amir', N'rashee', NULL, N'sss', N'sss', 1, 1, NULL)
INSERT [dbo].[Users] ([UserID], [role_id], [first_name], [last_name], [phone], [login_name], [Password], [active], [Deleted], [UserEmail]) VALUES (2, 2, N'Doe', N'John', NULL, N'a', N'a', 1, 0, N'seminarenrollmentsystem@gmail.com')
INSERT [dbo].[Users] ([UserID], [role_id], [first_name], [last_name], [phone], [login_name], [Password], [active], [Deleted], [UserEmail]) VALUES (3, 3, N'John', N'Smith', NULL, N'o', N'o', 1, 0, N'seminarenrollmentsystem@gmail.com')
INSERT [dbo].[Users] ([UserID], [role_id], [first_name], [last_name], [phone], [login_name], [Password], [active], [Deleted], [UserEmail]) VALUES (4, 3, N'First Name1', N'Last Name1', N'319-827-301', N'Login Name1', N'Password1', 1, 1, NULL)
INSERT [dbo].[Users] ([UserID], [role_id], [first_name], [last_name], [phone], [login_name], [Password], [active], [Deleted], [UserEmail]) VALUES (5, 1, N'Guiling', N'Wang', N'217-466-4942', N's', N's', 1, 0, N'seminarenrollmentsystem@gmail.com')
INSERT [dbo].[Users] ([UserID], [role_id], [first_name], [last_name], [phone], [login_name], [Password], [active], [Deleted], [UserEmail]) VALUES (6, 1, N'Reynosa', N'Alison', N'510-897-6797', N's2', N's2', 1, 0, N'seminarenrollmentsystem@gmail.com')
USE [master]
GO
ALTER DATABASE [SeminarDB] SET  READ_WRITE 
GO
