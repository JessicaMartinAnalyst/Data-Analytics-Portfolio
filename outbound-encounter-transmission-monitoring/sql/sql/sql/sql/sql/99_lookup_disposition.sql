/*
Purpose:
Reference mapping for disposition codes used in reporting.
*/


SELECT '01' AS dispositionid, 'Accepted' AS disposition_description
UNION ALL
SELECT '02', 'Rejected'
UNION ALL
SELECT '03', 'Pending Acknowledgment';
