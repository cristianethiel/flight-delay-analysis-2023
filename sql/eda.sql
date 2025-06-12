SELECT
  COUNTIF (cancelled = 0) AS naocancelado,
  COUNTIF (diverted = 0) AS naodesviado,
  COUNTIF (delayed = 0) AS naoatrasado
FROM 
  `laboratoria-projeto-04.flight_stats_jan2023.flights_202301_final`;


SELECT 
  route_id,
  COUNT(*) AS total_voos,
  SUM(CASE WHEN arr_delay > 15 THEN 1 ELSE 0 END) AS total_atrasos,
  ROUND(SUM(CASE WHEN arr_delay > 15 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS percentual_atrasos
FROM 
  laboratoria-projeto-04.flight_stats_jan2023.flights_202301_final
GROUP BY 
  route_id
ORDER BY 
  percentual_atrasos DESC;

SELECT 
  route_id,
  COUNT(*) AS total_voos,
  SUM(CASE WHEN cancelled = 1 THEN 1 ELSE 0 END) AS total_cancelados,
  ROUND(SUM(CASE WHEN cancelled = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS percentual_cancelados
FROM 
  laboratoria-projeto-04.flight_stats_jan2023.flights_202301_final
GROUP BY 
  route_id
ORDER BY 
  percentual_cancelados DESC;

  SELECT 
  airline_code,
  airline_description,
  dot_code,
  dot_description,
  origin,
  origin_city,
  destination,
  destination_city,
  route_id
FROM `laboratoria-projeto-04.flight_stats_jan2023.flights_202301_final` 
LIMIT 100;


