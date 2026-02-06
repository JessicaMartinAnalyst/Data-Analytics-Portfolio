/*
Purpose:
Create a clean base dataset of outbound encounter transmissions
for the last 12 days, excluding cancelled/invalid dispositions.
*/


WITH BaseOutbound AS (
SELECT
rec.name AS Receiver,
CONVERT(date, enc.batchcreationdt) AS BatchCreationDate,
t.transmissionfilename,
t.trackingidentifier,
t.dispositionid,
t.totalbizitemlevel1count
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
SELECT *
FROM BaseOutbound;
