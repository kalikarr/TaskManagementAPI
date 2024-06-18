USE [master]
GO
/****** Object:  Database [TaskManagementDB]    Script Date: 6/18/2024 3:26:47 PM ******/
CREATE DATABASE [TaskManagementDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TaskManagementDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\TaskManagementDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'TaskManagementDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\TaskManagementDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [TaskManagementDB] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TaskManagementDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TaskManagementDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TaskManagementDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TaskManagementDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TaskManagementDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TaskManagementDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [TaskManagementDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TaskManagementDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TaskManagementDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TaskManagementDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TaskManagementDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TaskManagementDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TaskManagementDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TaskManagementDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TaskManagementDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TaskManagementDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [TaskManagementDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TaskManagementDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TaskManagementDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TaskManagementDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TaskManagementDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TaskManagementDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TaskManagementDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TaskManagementDB] SET RECOVERY FULL 
GO
ALTER DATABASE [TaskManagementDB] SET  MULTI_USER 
GO
ALTER DATABASE [TaskManagementDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TaskManagementDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TaskManagementDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TaskManagementDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TaskManagementDB] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'TaskManagementDB', N'ON'
GO
ALTER DATABASE [TaskManagementDB] SET QUERY_STORE = OFF
GO
USE [TaskManagementDB]
GO
/****** Object:  Table [dbo].[AuditTrail]    Script Date: 6/18/2024 3:26:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditTrail](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[TaskId] [int] NULL,
	[ActionById] [int] NULL,
	[Action] [nvarchar](150) NULL,
	[Timestamp] [datetime] NULL,
 CONSTRAINT [PK__AuditTral_Id] PRIMARY KEY CLUSTERED 
(
	[AuditId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tasks]    Script Date: 6/18/2024 3:26:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tasks](
	[TaskId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[TaskName] [nvarchar](100) NOT NULL,
	[TaskDescription] [nvarchar](1000) NOT NULL,
	[StatusId] [int] NOT NULL,
	[CreatedByUserId] [int] NOT NULL,
	[LastUpdatedByUserId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TaskId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TaskStatus]    Script Date: 6/18/2024 3:26:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaskStatus](
	[StatusId] [int] NOT NULL,
	[StatusName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TaskStatus] PRIMARY KEY CLUSTERED 
(
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 6/18/2024 3:26:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](150) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AuditTrail] ADD  CONSTRAINT [DF_AuditTrail_Timestamp]  DEFAULT (getdate()) FOR [Timestamp]
GO
ALTER TABLE [dbo].[Tasks] ADD  CONSTRAINT [DF_Tasks_StatusId]  DEFAULT ((1)) FOR [StatusId]
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD FOREIGN KEY([LastUpdatedByUserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD FOREIGN KEY([StatusId])
REFERENCES [dbo].[TaskStatus] ([StatusId])
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
/****** Object:  StoredProcedure [dbo].[AuthenticateUser]    Script Date: 6/18/2024 3:26:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- User Authentication
CREATE PROCEDURE [dbo].[AuthenticateUser]
    @UserName NVARCHAR(50),
    @Password NVARCHAR(150)
AS
BEGIN
    SELECT UserId, FirstName +' '+ LastName AS FullName, UserName
	FROM Users 
	WHERE UserName = @UserName AND Password = @Password
END
GO
/****** Object:  StoredProcedure [dbo].[CreateTask]    Script Date: 6/18/2024 3:26:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreateTask]
    @UserId INT,
    @TaskName NVARCHAR(100),
    @TaskDescription NVARCHAR(500),
	@StatusId INT,
	@CreatedByUserId INT
AS
BEGIN
    INSERT INTO Tasks (UserId, TaskName, TaskDescription, StatusId, CreatedByUserId, LastUpdatedByUserId ) 
	VALUES (@UserId, @TaskName, @TaskDescription,@StatusId, @CreatedByUserId, @CreatedByUserId)
    DECLARE @TaskId INT = SCOPE_IDENTITY()

END
 
GO
/****** Object:  StoredProcedure [dbo].[DeleteTask]    Script Date: 6/18/2024 3:26:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DeleteTask]
    @TaskId INT,
	@UserId INT
AS
BEGIN

 BEGIN TRY
    BEGIN TRANSACTION;
   
    DELETE FROM Tasks WHERE TaskId = @TaskId;

  
    INSERT INTO [dbo].[AuditTrail] (TaskId, ActionById, Action)
    VALUES (@TaskId, @UserId, 'Deleted Task');
 
    COMMIT;
END TRY
BEGIN CATCH
    
    ROLLBACK;

  
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
      
       
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllTasksStatus]    Script Date: 6/18/2024 3:26:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetAllTasksStatus]
AS
BEGIN
    SELECT StatusId, StatusName
	FROM TaskStatus 
	ORDER BY  StatusId
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllUsers]    Script Date: 6/18/2024 3:26:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetAllUsers]
AS
BEGIN
    SELECT UserId, FirstName + ' '+LastName AS FullName
	FROM Users 
	ORDER BY  FullName
END
GO
/****** Object:  StoredProcedure [dbo].[GetTask]    Script Date: 6/18/2024 3:26:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetTask]
    @UserId INT,
	@TaskId INT
AS
BEGIN
    SELECT TaskId, t.UserId, StatusId,TaskName, TaskDescription
	FROM Tasks t
	WHERE t.UserId = @UserId 
		AND TaskId = @TaskId
END
GO
/****** Object:  StoredProcedure [dbo].[GetTaskCountByUser]    Script Date: 6/18/2024 3:26:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetTaskCountByUser]
    
AS
BEGIN
    SELECT t.UserId, u.FirstName + ' '  + u.LastName AS FullName, COUNT(TaskId) AS TaskCount
	FROM Tasks t
	INNER JOIN Users u ON t.UserId = u.UserId
	GROUP BY t.UserId, u.FirstName, u.LastName
END
GO
/****** Object:  StoredProcedure [dbo].[GetTasks]    Script Date: 6/18/2024 3:26:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetTasks]
    @UserId INT
AS
BEGIN
	SELECT TaskId, TaskName, t.UserId, t.StatusId , u.FirstName +' ' + u.LastName AS AssignTo, StatusName , TaskDescription
	FROM Tasks t
	INNER JOIN Users u ON t.UserId= u.UserId
	INNER JOIN TaskStatus ts ON t.StatusId= ts.StatusId
	WHERE t.UserId = @UserId
	ORDER By TaskId DESC
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateTask]    Script Date: 6/18/2024 3:26:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpdateTask]
    @TaskId INT,
	@UserId INT,
    @TaskName NVARCHAR(100),
    @TaskDescription NVARCHAR(500),
	@StatusId INT,
	@LastUpdatedByUserId INT
AS
BEGIN
    UPDATE Tasks 
	SET TaskName = @TaskName, 
		UserId = @UserId,
		TaskDescription = @TaskDescription,
		StatusId = @StatusId,
		LastUpdatedByUserId = @LastUpdatedByUserId
	WHERE TaskId = @TaskId
    
   
END
GO
/****** Object:  Trigger [dbo].[trg_AuditTrail_Insert]    Script Date: 6/18/2024 3:26:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_AuditTrail_Insert]
ON [dbo].[Tasks]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [dbo].[AuditTrail] (TaskId, ActionById, Action)
    SELECT 
        i.TaskId, 
        i.CreatedByUserId, 
        'Inserted Task'
    FROM 
        inserted i;
END;
GO
ALTER TABLE [dbo].[Tasks] ENABLE TRIGGER [trg_AuditTrail_Insert]
GO
/****** Object:  Trigger [dbo].[trg_AuditTrail_Update]    Script Date: 6/18/2024 3:26:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_AuditTrail_Update]
ON [dbo].[Tasks]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [dbo].[AuditTrail] (TaskId, ActionById, Action)
    SELECT 
        i.TaskId, 
        i.LastUpdatedByUserId, 
        'Updated Task'
    FROM 
        inserted i;
END;
GO
ALTER TABLE [dbo].[Tasks] ENABLE TRIGGER [trg_AuditTrail_Update]
GO
USE [master]
GO
ALTER DATABASE [TaskManagementDB] SET  READ_WRITE 
GO
