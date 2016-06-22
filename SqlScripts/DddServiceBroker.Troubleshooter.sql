-- Message Types
SELECT * 
FROM sys.service_message_types; 
-- Contracts
SELECT * 
FROM sys.service_contracts;

-- Queues
SELECT * 
FROM sys.service_queues;

-- Services
SELECT * 
FROM sys.services;

-- Endpoints
SELECT * 
FROM sys.endpoints;

SELECT conversation_handle, is_initiator, s.name as 'local service', 
far_service, sc.name 'contract', state_desc
FROM sys.conversation_endpoints ce
LEFT JOIN sys.services s
ON ce.service_id = s.service_id
LEFT JOIN sys.service_contracts sc
ON ce.service_contract_id = sc.service_contract_id;

SELECT * 
FROM sys.transmission_queue;

--CLEANUP!
END CONVERSATION 'conversation handle' WITH CLEANUP;