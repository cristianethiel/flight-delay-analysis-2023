CREATE OR REPLACE TABLE `laboratoria-projeto-04.flight_stats_jan2023.dot_code_dictionary` AS
SELECT
  Code,
  Description
FROM
  `laboratoria-projeto-04.flight_stats_jan2023.dot_code_dictionary`
WHERE
  Description IS NOT NULL
  AND NOT ( (Code = 22120 AND Description = 'SPARFELL MALTA LTD: QFX')
         OR (Code = 22121 AND Description = 'HAUTE AVIATION: HUQ')
         OR (Code = 22122 AND Description = 'AXIS AVIATION SWITZERLAND AG: XQQ')
         OR (Code = 22123 AND Description = 'WESTERN AIR LTD: WU') );
