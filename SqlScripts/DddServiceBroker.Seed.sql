DECLARE @messageBody VARCHAR(MAX)
	
-- Construct the request message 
--set @messageBody = (
--select
--'?Name=' +
--isnull(Name, '') + '&DateLastSent=' +
--isnull(convert(varchar, DateLastSent, 121), '') + '&Status=' +
--isnull([Status], '') + '&TaskID=' +
--isnull(cast(TaskID as varchar), '') + '&ReportCatalogID=' +
--isnull(cast(ReportCatalogID as varchar), '') + '&HasMailButton=' +
--isnull(cast(HasMailButton as varchar), '')
--from Inserted i);
PRINT @messageBody
SET @messageBody = N'Hello from robk'; 
	
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