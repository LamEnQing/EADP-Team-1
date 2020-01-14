﻿CREATE TABLE [dbo].[User] (
    [Id]           INT         IDENTITY (1, 1) NOT NULL,
    [Username]     NCHAR (20)  NOT NULL,
    [EmailAddress] NCHAR (30)  NOT NULL,
    [Password]     NCHAR (256) NULL,
    [Name]         NCHAR (20)  NOT NULL,
    [Bio]          TEXT        NULL,
    [Latitude]     FLOAT (53)  NULL,
    [Longitude]    FLOAT (53)  NULL,
    [ProfileImage] IMAGE       NULL,
    [HeaderImage]  IMAGE       NULL,
    [IsLoggedIn]   BIT         DEFAULT ((0)) NOT NULL,
    [IsPrivileged] BIT         DEFAULT ((0)) NOT NULL,
    [IsDeleted]    BIT         DEFAULT ((0)) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([EmailAddress] ASC),
    UNIQUE NONCLUSTERED ([Username] ASC)
);


-- Circle Table (may change later)
CREATE TABLE [dbo].[Circle] (
    [Id]   INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (30) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


-- UserCircle Table (also may change)
CREATE TABLE [dbo].[UserCircles] (
    [Id]       INT NOT NULL,
    [UserId]   INT NOT NULL,
    [CircleId] INT NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_UserCircles_ToUser] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([Id]),
    CONSTRAINT [FK_UserCircles_ToCircle] FOREIGN KEY ([CircleId]) REFERENCES [dbo].[Circle] ([Id])
);


-- POST Table
CREATE TABLE [dbo].[Post] (
    [Id]      INT         IDENTITY (1, 1) NOT NULL,
    [Content] NCHAR (120) NOT NULL,
    [Picture] IMAGE       NULL,
    [Comment] NCHAR (20)  NOT NULL,
    [UserId]  INT         NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_POST_ToUser] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([Id])
);


-- Notification Table
CREATE TABLE [dbo].[Notification] (
    [Id]        INT        IDENTITY (1, 1) NOT NULL,
    [Type]      NCHAR (10) NOT NULL,
    [Title]     NCHAR (20) NULL,
    [Content]   TEXT       NOT NULL,
    [IsRead]    BIT        NOT NULL,
    [CreatedAt] DATETIME   NOT NULL,
    [UserId]    INT        NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Notification_ToUser] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([Id])
);


-- Follow Table
CREATE TABLE [dbo].[Follow] (
    [Id]          INT      IDENTITY (1, 1) NOT NULL,
    [IsDeleted]   BIT      NOT NULL,
    [CreatedAt]   DATETIME NOT NULL,
    [FollowerId]  INT      NOT NULL,
    [FollowingId] INT      NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Follower_ToUser] FOREIGN KEY ([FollowerId]) REFERENCES [dbo].[User] ([Id]),
    CONSTRAINT [FK_Following_ToUser] FOREIGN KEY ([FollowingId]) REFERENCES [dbo].[User] ([Id])
);


-- Mutuals Table
CREATE TABLE [dbo].[Mutual] (
    [Id]      INT IDENTITY (1, 1) NOT NULL,
    [User1Id] INT NOT NULL,
    [User2Id] INT NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Mutual1_ToUser] FOREIGN KEY ([User1Id]) REFERENCES [dbo].[User] ([Id]),
    CONSTRAINT [FK_Mutual2_ToUser] FOREIGN KEY ([User2Id]) REFERENCES [dbo].[User] ([Id])
);


-- Event Table
CREATE TABLE [dbo].[Event] (
    [eventId]          INT        IDENTITY (1, 1) NOT NULL,
    [eventName]        NCHAR (50) NULL,
    [eventDescription] NCHAR (50) NULL,
    [eventStartDate]   NCHAR (50) NULL,
    [eventEndDate]     NCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([eventId] ASC)
);