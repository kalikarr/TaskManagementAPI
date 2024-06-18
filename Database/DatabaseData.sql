USE [TaskManagementDB]
GO
DELETE FROM  [dbo].[Tasks]
GO
DELETE FROM [dbo].[Users]
GO
DELETE FROM [dbo].[TaskStatus]
GO
GO
INSERT [dbo].[TaskStatus] ([StatusId], [StatusName]) VALUES (1, N'TODO')
GO
INSERT [dbo].[TaskStatus] ([StatusId], [StatusName]) VALUES (2, N'In Progress')
GO
INSERT [dbo].[TaskStatus] ([StatusId], [StatusName]) VALUES (3, N'On Hold')
GO
INSERT [dbo].[TaskStatus] ([StatusId], [StatusName]) VALUES (4, N'Completed')
GO
INSERT [dbo].[TaskStatus] ([StatusId], [StatusName]) VALUES (5, N'Closed')
GO
SET IDENTITY_INSERT [dbo].[Users] ON 
GO
INSERT [dbo].[Users] ([UserId], [UserName], [Password], [FirstName], [LastName]) VALUES (1, N'john_doe', N'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', N'John', N'Doe')
GO
INSERT [dbo].[Users] ([UserId], [UserName], [Password], [FirstName], [LastName]) VALUES (2, N'jane_smith', N'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', N'Jane', N'Smith')
GO
INSERT [dbo].[Users] ([UserId], [UserName], [Password], [FirstName], [LastName]) VALUES (3, N'alice_jones', N'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', N'Alice', N'Jones')
GO
INSERT [dbo].[Users] ([UserId], [UserName], [Password], [FirstName], [LastName]) VALUES (4, N'bob_brown', N'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', N'Bob', N'Brown')
GO
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
SET IDENTITY_INSERT [dbo].[Tasks] ON 
GO
INSERT [dbo].[Tasks] ([TaskId], [UserId], [TaskName], [TaskDescription], [StatusId], [CreatedByUserId], [LastUpdatedByUserId]) VALUES (1, 1, N'Task 1', N'Description for Task 1', 1, 1, 1)
GO
INSERT [dbo].[Tasks] ([TaskId], [UserId], [TaskName], [TaskDescription], [StatusId], [CreatedByUserId], [LastUpdatedByUserId]) VALUES (2, 2, N'Task 2', N'Description for Task 2', 2, 2, 2)
GO
INSERT [dbo].[Tasks] ([TaskId], [UserId], [TaskName], [TaskDescription], [StatusId], [CreatedByUserId], [LastUpdatedByUserId]) VALUES (3, 3, N'Task 3', N'Description for Task 3', 3, 3, 3)
GO
INSERT [dbo].[Tasks] ([TaskId], [UserId], [TaskName], [TaskDescription], [StatusId], [CreatedByUserId], [LastUpdatedByUserId]) VALUES (4, 4, N'Task 4', N'Description for Task 4', 4, 4, 4)
GO
INSERT [dbo].[Tasks] ([TaskId], [UserId], [TaskName], [TaskDescription], [StatusId], [CreatedByUserId], [LastUpdatedByUserId]) VALUES (5, 2, N'Task 5', N'Description for Task 5', 2, 2, 2)
GO
INSERT [dbo].[Tasks] ([TaskId], [UserId], [TaskName], [TaskDescription], [StatusId], [CreatedByUserId], [LastUpdatedByUserId]) VALUES (6, 3, N'Task 6', N'Description for Task 6', 3, 3, 3)
GO
INSERT [dbo].[Tasks] ([TaskId], [UserId], [TaskName], [TaskDescription], [StatusId], [CreatedByUserId], [LastUpdatedByUserId]) VALUES (7, 2, N'Task 7', N'Description for Task 7', 2, 2, 2)
GO
SET IDENTITY_INSERT [dbo].[Tasks] OFF
GO
