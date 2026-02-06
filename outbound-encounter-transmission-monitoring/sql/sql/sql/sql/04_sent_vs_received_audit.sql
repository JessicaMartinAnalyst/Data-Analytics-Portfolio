/*
Purpose:
Audit encounters that were sent but never marked as received.
*/


WITH SentEncounters AS (
SELECT
enc.transmissionid,
enc.batchcreationdt,
enc.receiptdt
FROM encounter enc
WHERE enc.batchcreationdt >= DATEADD(day, -12, GETDATE())
AND enc.batchcreationdt < GETDATE()
),
NotReceived AS (
SELECT *
FROM SentEncounters
WHERE receiptdt IS NULL
)
SELECT *
FROM NotReceived
ORDER BY batchcreationdt DESC;
