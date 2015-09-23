-- SQL Manager 2005 for SQL Server (2.6.0.1)
-- ---------------------------------------
-- Host      : beehive
-- Database  : Movies
-- Version   : Microsoft SQL Server  8.00.2039


CREATE DATABASE [MoiveLibrary]
COLLATE SQL_Latin1_General_CP1_CI_AS
GO

USE [MoiveLibrary]
GO

--
-- Definition for table Formats : 
--

CREATE TABLE [dbo].[Formats] (
  [ID]int IDENTITY(1, 1) NOT NULL,
  [Name]varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
ON [PRIMARY]
GO

--
-- Definition for table Locations : 
--

CREATE TABLE [dbo].[Locations] (
  [ID]int IDENTITY(1, 1) NOT NULL,
  [Name]varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
ON [PRIMARY]
GO

--
-- Definition for table Movies : 
--

CREATE TABLE [dbo].[Movies] (
  [ID]int IDENTITY(1, 1) NOT NULL,
  [FormatID]int NOT NULL,
  [LocationID]int NULL,
  [Name]varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [IMDBLink]varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [DateInserted]datetime DEFAULT getdate() NULL,
  [NumberOfDiscs]int DEFAULT 1 NULL
)
ON [PRIMARY]
GO

--
-- Data for table Formats  (LIMIT 0,500)
--

SET IDENTITY_INSERT [dbo].[Formats] ON
GO

INSERT INTO [dbo].[Formats] ([ID], [Name])
VALUES 
  (1, 'DVD')
GO

INSERT INTO [dbo].[Formats] ([ID], [Name])
VALUES 
  (2, 'PC')
GO

--
-- 2 record(s) inserted to [dbo].[Formats]
--

SET IDENTITY_INSERT [dbo].[Formats] OFF
GO

--
-- Data for table Locations  (LIMIT 0,500)
--

SET IDENTITY_INSERT [dbo].[Locations] ON
GO

INSERT INTO [dbo].[Locations] ([ID], [Name])
VALUES 
  (1, 'Shelf')
GO

INSERT INTO [dbo].[Locations] ([ID], [Name])
VALUES 
  (2, 'Crate A')
GO

INSERT INTO [dbo].[Locations] ([ID], [Name])
VALUES 
  (3, 'Crate B')
GO

INSERT INTO [dbo].[Locations] ([ID], [Name])
VALUES 
  (4, 'Crate C')
GO

INSERT INTO [dbo].[Locations] ([ID], [Name])
VALUES 
  (5, 'PC')
GO

INSERT INTO [dbo].[Locations] ([ID], [Name])
VALUES 
  (6, 'Unfiled')
GO

--
-- 8 record(s) inserted to [dbo].[Locations]
--



SET IDENTITY_INSERT [dbo].[Locations] OFF
GO

--
-- Data for table Movies  (LIMIT 0,500)
--

SET IDENTITY_INSERT [dbo].[Movies] ON
GO

INSERT INTO [dbo].[Movies] ([ID], [FormatID], [LocationID], [Name], [IMDBLink], [DateInserted], [NumberOfDiscs])
VALUES 
  (1, 1, 2, 'Accepted', NULL, '20070305 20:09:07.827', 1)
GO

INSERT INTO [dbo].[Movies] ([ID], [FormatID], [LocationID], [Name], [IMDBLink], [DateInserted], [NumberOfDiscs])
VALUES 
  (2, 1, 2, 'Children of Men', NULL, '20070305 20:09:07.827', 1)
GO

INSERT INTO [dbo].[Movies] ([ID], [FormatID], [LocationID], [Name], [IMDBLink], [DateInserted], [NumberOfDiscs])
VALUES 
  (3, 1, 2, 'Fearless', NULL, '20070305 20:09:07.827', 1)
GO

--
-- Definition for indices : 
--

ALTER TABLE [dbo].[Formats]
ADD CONSTRAINT [PK__MovieFormats__78B3EFCA] 
PRIMARY KEY CLUSTERED ([ID])
ON [PRIMARY]
GO

ALTER TABLE [dbo].[Locations]
ADD PRIMARY KEY CLUSTERED ([ID])
ON [PRIMARY]
GO

ALTER TABLE [dbo].[Movies]
ADD PRIMARY KEY CLUSTERED ([ID])
ON [PRIMARY]
GO

--
-- Definition for stored procedure GetDuplicateMovies : 
--

CREATE	procedure dbo.GetDuplicateMovies
as

select		m.ID, m.Name as MovieName, m.IMDBLink,
		m.NumberOfDiscs,
		m.DateInserted,
		f.Name as FormatName,
		l.Name as LocationName
from		dbo.Movies as m
		inner join
		dbo.Formats as f
		on
		m.FormatID = f.ID
		inner join
		dbo.Locations as l
		on
		m.LocationID = l.ID
where	m.Name in (
	select		m.Name as MovieName
	from		dbo.Movies as m
	group by	m.Name
	having		count(m.Name) > 1
)
GO

--
-- Definition for stored procedure GetDuplicateMoviesByFormat : 
--

CREATE	proc dbo.GetDuplicateMoviesByFormat
	@formatName varchar(255)
as

select		m.ID, m.Name as MovieName, m.IMDBLink,
		m.NumberOfDiscs,
		m.DateInserted,
		f.Name as FormatName,
		l.Name as LocationName
from		dbo.Movies as m
		inner join
		dbo.Formats as f
		on
		m.FormatID = f.ID
		inner join
		dbo.Locations as l
		on
		m.LocationID = l.ID
where	m.Name in (
	select		m.Name as MovieName
	from		dbo.Movies as m
	where		FormatID = (select id from dbo.Formats where name = @formatName)
	group by	m.Name
	having		count(m.Name) > 1
)
GO

--
-- Definition for stored procedure GetMovies : 
--

--
-- Definition for stored procedure GetMovies : 
--

CREATE	procedure dbo.GetMovies
	@nameStartsWith varchar(100) = 'a',
	@orderBy varchar(50) = 'MovieName',
	@orderDirection varchar(4) = 'asc'
as

declare @sql varchar(8000)


set @sql = '
select		m.ID, m.Name as MovieName, m.IMDBLink,
		m.NumberOfDiscs,
		m.DateInserted,
		f.Name as FormatName,
		l.Name as LocationName
from		dbo.Movies as m
		inner join
		dbo.Formats as f
		on
		m.FormatID = f.ID
		inner join
		dbo.Locations as l
		on
		m.LocationID = l.ID
where		m.Name like ''' + @nameStartsWith + '%''
order by	' + @orderBy + ' ' +@orderDirection

exec(@sql)
GO
