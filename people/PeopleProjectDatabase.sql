USE [master];
GO

IF DB_ID(N'TalentMarketplacePractice') IS NULL
    CREATE DATABASE [TalentMarketplacePractice];
GO

USE [TalentMarketplacePractice];
GO

/*
  WARNING:
  Скрипт очищает текущую схему dbo (все таблицы)
  и разворачивает структуру, совместимую с проектом WPF.
*/

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += N'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + N'.' + QUOTENAME(OBJECT_NAME(parent_object_id))
             + N' DROP CONSTRAINT ' + QUOTENAME(name) + N';' + CHAR(10)
FROM sys.foreign_keys;

EXEC sp_executesql @sql;

SET @sql = N'';
SELECT @sql += N'DROP TABLE ' + QUOTENAME(SCHEMA_NAME(schema_id)) + N'.' + QUOTENAME(name) + N';' + CHAR(10)
FROM sys.tables;

EXEC sp_executesql @sql;
GO

CREATE TABLE [dbo].[Roles] (
    [IdRole] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [NameRole] NVARCHAR(50) NOT NULL
);

CREATE TABLE [dbo].[Cities] (
    [IdCity] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [NameCity] NVARCHAR(100) NOT NULL
);

CREATE TABLE [dbo].[Users] (
    [IdUser] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [NameUser] NVARCHAR(50) NOT NULL,
    [IdRole] INT NOT NULL,
    [Password] NVARCHAR(100) NOT NULL,
    [Email] NVARCHAR(100) NOT NULL,
    [IdCity] INT NOT NULL
);

CREATE TABLE [dbo].[Categories] (
    [IdCategory] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [NameCategory] NVARCHAR(100) NOT NULL
);

CREATE TABLE [dbo].[Catalogs] (
    [IdCatalog] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Product] NVARCHAR(120) NOT NULL,
    [Descripton] NVARCHAR(1000) NOT NULL,
    [PhotoPath] NVARCHAR(MAX) NOT NULL,
    [Price] DECIMAL(10,2) NOT NULL,
    [IdCategory] INT NOT NULL
);

CREATE TABLE [dbo].[StatusOrders] (
    [IdStatusOrder] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [NameStatusOrder] NVARCHAR(50) NOT NULL
);

CREATE TABLE [dbo].[Baskets] (
    [IdBasket] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [IdUser] INT NOT NULL,
    [TotalPrice] DECIMAL(18,2) NOT NULL CONSTRAINT [DF_Baskets_TotalPrice] DEFAULT (0),
    [IsOrdered] BIT NOT NULL CONSTRAINT [DF_Baskets_IsOrdered] DEFAULT (0),
    [CreateDate] DATETIME NOT NULL CONSTRAINT [DF_Baskets_CreateDate] DEFAULT (GETDATE())
);

CREATE TABLE [dbo].[BasketsCatalogs] (
    [IdBasketCatalog] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [IdBasket] INT NOT NULL,
    [IdCatalog] INT NOT NULL,
    [Quantity] INT NOT NULL CONSTRAINT [DF_BasketsCatalogs_Quantity] DEFAULT (1)
);

CREATE TABLE [dbo].[Orders] (
    [IdOrder] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [IdUser] INT NOT NULL,
    [IdStatusOrder] INT NOT NULL,
    [Data] DATETIME NOT NULL CONSTRAINT [DF_Orders_Data] DEFAULT (GETDATE()),
    [Price] DECIMAL(10,2) NOT NULL
);

CREATE TABLE [dbo].[OrdersCatalogs] (
    [IdOrderCatalog] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [IdOrder] INT NOT NULL,
    [IdCatalog] INT NOT NULL,
    [Quantity] INT NOT NULL CONSTRAINT [DF_OrdersCatalogs_Quantity] DEFAULT (1)
);
GO

ALTER TABLE [dbo].[Users] ADD CONSTRAINT [FK_Users_Roles]
FOREIGN KEY ([IdRole]) REFERENCES [dbo].[Roles]([IdRole]);

ALTER TABLE [dbo].[Users] ADD CONSTRAINT [FK_Users_Cities]
FOREIGN KEY ([IdCity]) REFERENCES [dbo].[Cities]([IdCity]);

ALTER TABLE [dbo].[Catalogs] ADD CONSTRAINT [FK_Catalogs_Categories]
FOREIGN KEY ([IdCategory]) REFERENCES [dbo].[Categories]([IdCategory]);

ALTER TABLE [dbo].[Baskets] ADD CONSTRAINT [FK_Baskets_Users]
FOREIGN KEY ([IdUser]) REFERENCES [dbo].[Users]([IdUser]);

ALTER TABLE [dbo].[BasketsCatalogs] ADD CONSTRAINT [FK_BasketsCatalogs_Baskets]
FOREIGN KEY ([IdBasket]) REFERENCES [dbo].[Baskets]([IdBasket]);

ALTER TABLE [dbo].[BasketsCatalogs] ADD CONSTRAINT [FK_BasketsCatalogs_Catalogs]
FOREIGN KEY ([IdCatalog]) REFERENCES [dbo].[Catalogs]([IdCatalog]);

ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [FK_Orders_StatusOrders]
FOREIGN KEY ([IdStatusOrder]) REFERENCES [dbo].[StatusOrders]([IdStatusOrder]);

ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [FK_Orders_Users]
FOREIGN KEY ([IdUser]) REFERENCES [dbo].[Users]([IdUser]);

ALTER TABLE [dbo].[OrdersCatalogs] ADD CONSTRAINT [FK_OrdersCatalogs_Orders]
FOREIGN KEY ([IdOrder]) REFERENCES [dbo].[Orders]([IdOrder]);

ALTER TABLE [dbo].[OrdersCatalogs] ADD CONSTRAINT [FK_OrdersCatalogs_Catalogs]
FOREIGN KEY ([IdCatalog]) REFERENCES [dbo].[Catalogs]([IdCatalog]);
GO

CREATE INDEX [IX_Users_IdRole] ON [dbo].[Users]([IdRole]);
CREATE INDEX [IX_Users_IdCity] ON [dbo].[Users]([IdCity]);
CREATE INDEX [IX_Catalogs_IdCategory] ON [dbo].[Catalogs]([IdCategory]);
CREATE INDEX [IX_Baskets_IdUser] ON [dbo].[Baskets]([IdUser]);
CREATE INDEX [IX_BasketsCatalogs_IdBasket] ON [dbo].[BasketsCatalogs]([IdBasket]);
CREATE INDEX [IX_BasketsCatalogs_IdCatalog] ON [dbo].[BasketsCatalogs]([IdCatalog]);
CREATE INDEX [IX_Orders_IdUser] ON [dbo].[Orders]([IdUser]);
CREATE INDEX [IX_Orders_IdStatusOrder] ON [dbo].[Orders]([IdStatusOrder]);
CREATE INDEX [IX_OrdersCatalogs_IdOrder] ON [dbo].[OrdersCatalogs]([IdOrder]);
CREATE INDEX [IX_OrdersCatalogs_IdCatalog] ON [dbo].[OrdersCatalogs]([IdCatalog]);
GO

INSERT INTO [dbo].[Roles] ([NameRole]) VALUES
(N'Покупатель'),
(N'Администратор');

INSERT INTO [dbo].[Cities] ([NameCity]) VALUES
(N'Москва'),
(N'Санкт-Петербург'),
(N'Казань'),
(N'Екатеринбург'),
(N'Новосибирск');

INSERT INTO [dbo].[StatusOrders] ([NameStatusOrder]) VALUES
(N'Новая'),
(N'В работе'),
(N'Закрыта');

INSERT INTO [dbo].[Categories] ([NameCategory]) VALUES
(N'.NET разработка'),
(N'Frontend разработка'),
(N'QA тестирование'),
(N'Аналитика данных');

INSERT INTO [dbo].[Users] ([NameUser], [IdRole], [Password], [Email], [IdCity]) VALUES
(N'admin', 2, N'admin123', N'admin@practice.local', 1),
(N'manager1', 1, N'user1234', N'manager1@practice.local', 1),
(N'user1', 1, N'user1234', N'user1@practice.local', 2),
(N'user2', 1, N'user1234', N'user2@practice.local', 3);

INSERT INTO [dbo].[Catalogs] ([Product], [Descripton], [PhotoPath], [Price], [IdCategory]) VALUES
(N'Илья Кузнецов (Junior .NET)', N'Опыт C#, SQL, WPF. Готов к офисному формату.', N'profile1.png', 120000.00, 1),
(N'Елена Орлова (Frontend)', N'JavaScript, HTML/CSS, SPA. Опыт 3 года.', N'profile2.png', 160000.00, 2),
(N'Дмитрий Васильев (QA)', N'Ручное тестирование, SQL, Postman.', N'profile3.png', 140000.00, 3),
(N'Светлана Иванова (Data Analyst)', N'Power BI, SQL, Python. Опыт 4 года.', N'profile4.png', 180000.00, 4);
GO
