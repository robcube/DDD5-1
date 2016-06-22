--Enabling service broker
USE master
ALTER DATABASE [DDD5-1]
SET ENABLE_BROKER;

use [DDD5-1]
go

/** MESSAGE TYPE **/
--DROP MESSAGE TYPE [DddRequestMessage]
--GO
CREATE MESSAGE TYPE [DddRequestMessage] VALIDATION = NONE
 GO

/** REQUEST QUEUE **/
--DROP QUEUE [dbo].[DddRequestQueue]
--GO
CREATE QUEUE [dbo].[DddRequestQueue] WITH STATUS = ON , RETENTION = OFF , POISON_MESSAGE_HANDLING (STATUS = ON) ON [PRIMARY] 
GO

/** CONTRACT **/
--DROP CONTRACT [DddContract]
--GO
CREATE CONTRACT [DddContract] ([DddRequestMessage] SENT BY ANY)
GO

/** REQUEST SERVICE **/
--DROP SERVICE [DddRequestService]
--GO
CREATE SERVICE [DddRequestService] ON QUEUE [dbo].[DddRequestQueue] ([DddContract])
GO

/** TABLES **/
--drop table MouseCaptures
create table MouseCaptures
(Id int not null identity(1, 1) primary key,
PageName varchar(max) null,
X float null,
Y float null,
AddDate datetime not null default getdate())

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[trigger_MouseCapture] ON [dbo].[MouseCaptures]
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @messageBody VARCHAR(MAX)
	
	-- Construct the request message 
	set @messageBody = (
	select
	'X=' +
	isnull(CONVERT (VARCHAR(max), X, 128), '') + '&AddDate=' +
	isnull(convert(varchar, AddDate, 121), '') + '&Y=' +
	isnull(CONVERT (VARCHAR(max), Y, 128), '') + '&PageName=' +
	isnull(PageName, '')
	from Inserted i);
	--PRINT @messageBody
	--SET @messageBody = N'Hello from robk'; 
	
	-- now put that in service broker queue
	IF @messageBody IS NOT NULL
	BEGIN
		DECLARE @ch UNIQUEIDENTIFIER
		BEGIN DIALOG CONVERSATION @ch 
			FROM SERVICE [DddRequestService] 
			TO SERVICE 'DddRequestService' 
			ON CONTRACT [DddContract] 
			WITH ENCRYPTION = OFF; 
		-- Send the message to the TargetService 
		SEND ON CONVERSATION @ch 
		MESSAGE TYPE [DddRequestMessage] (@messageBody);
	END
END
GO
