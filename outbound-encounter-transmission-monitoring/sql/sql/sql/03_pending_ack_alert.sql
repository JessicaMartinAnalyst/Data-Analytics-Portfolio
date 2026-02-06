/*
Purpose:
Identify outbound files that were sent but are still pending
acknowledgment (disposition 03).
*/


WITH BaseOutbound AS (
SELECT
rec.name AS Receiver,
CONVERT(date, enc.batchcreationdt) AS BatchCreationDate,
t.transmissionfilename,
t.trackingidentifier,
t.dispositionid
FROM encounter enc
INNER JOIN transmission t WITH (NOLOCK)
ON t.trackingidentifier = enc.transmissionid
INNER JOIN filetype ft WITH (NOLOCK)
ON ft.enumid = t.filetypeid
INNER JOIN partyinfo rec WITH (NOLOCK)
ON rec.partyid = enc.receiverpartysid
WHERE ft.description = 'Outbound Encounter'
AND t.dispositionid <> '4'
AND enc.batchcreationdt >= DATEADD(day, -12, GETDATE())
AND enc.batchcreationdt < GETDATE()
)
SELECT
Receiver,
BatchCreationDate,
transmissionfilename,
trackingidentifier,
COUNT(*) AS PendingAckCount
FROM BaseOutbound
WHERE dispositionid = '03'
GROUP BY
Receiver,
BatchCreationDate,
transmissionfilename,
trackingidentifier
ORDER BY PendingAckCount DESC, BatchCreationDate DESC;
