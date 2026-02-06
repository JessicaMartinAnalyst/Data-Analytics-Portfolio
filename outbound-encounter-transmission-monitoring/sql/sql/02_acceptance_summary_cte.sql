/*
Purpose:
Generate file-level acceptance, rejection, and pending ACK metrics
with acceptance percentage.
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
),
Agg AS (
SELECT
Receiver,
BatchCreationDate,
transmissionfilename,
trackingidentifier,
COUNT(*) AS EncounterCount,
SUM(CASE WHEN dispositionid = '01' THEN 1 ELSE 0 END) AS Accepted,
SUM(CASE WHEN dispositionid = '02' THEN 1 ELSE 0 END) AS Rejected,
SUM(CASE WHEN dispositionid = '03' THEN 1 ELSE 0 END) AS SentPendingAck
FROM BaseOutbound
GROUP BY
Receiver,
BatchCreationDate,
transmissionfilename,
trackingidentifier
)
SELECT
*,
CAST(
CASE WHEN EncounterCount = 0 THEN 0
ELSE (Accepted * 100.0 / EncounterCount)
END AS decimal(5,2)
) AS AcceptancePct
FROM Agg
ORDER BY BatchCreationDate DESC, Receiver;
