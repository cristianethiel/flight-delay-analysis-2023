CREATE OR REPLACE TABLE
  laboratoria-projeto-04.flight_stats_jan2023.flights_202301_final AS

# primeiro precisamos corrigir o formato dos campos que registram horários

WITH
  base AS (
        SELECT
            fli.*,
            dot.description AS dot_description,
            air.description AS airline_description,
            ccd.description AS cancellation_description,

# transformações de horário

CASE
  WHEN fli.crs_dep_time IS NOT NULL THEN 
    PARSE_TIME(
      "%H:%M:%S", 
      FORMAT(
        '%02d:%02d:00',
        CASE WHEN CAST(fli.crs_dep_time / 100 AS INT64) = 24 THEN 0 
             ELSE CAST(fli.crs_dep_time / 100 AS INT64) 
        END,
        MOD(fli.crs_dep_time, 100)
      )
    )
  ELSE NULL
END AS crs_dep_time_parsed,

CASE
  WHEN fli.dep_time IS NOT NULL THEN 
    PARSE_TIME(
      "%H:%M:%S", 
      FORMAT(
        '%02d:%02d:00',
        CASE WHEN CAST(fli.dep_time / 100 AS INT64) = 24 THEN 0 
             ELSE CAST(fli.dep_time / 100 AS INT64) 
        END,
        MOD(fli.dep_time, 100)
      )
    )
  ELSE NULL
END AS dep_time_parsed,

CASE
  WHEN fli.wheels_off IS NOT NULL THEN 
    PARSE_TIME(
      "%H:%M:%S", 
      FORMAT(
        '%02d:%02d:00',
        CASE WHEN CAST(fli.wheels_off / 100 AS INT64) = 24 THEN 0 
             ELSE CAST(fli.wheels_off / 100 AS INT64) 
        END,
        MOD(fli.wheels_off, 100)
      )
    )
  ELSE NULL
END AS wheels_off_parsed,

CASE
  WHEN fli.wheels_on IS NOT NULL THEN 
    PARSE_TIME(
      "%H:%M:%S", 
      FORMAT(
        '%02d:%02d:00',
        CASE WHEN CAST(fli.wheels_on / 100 AS INT64) = 24 THEN 0 
             ELSE CAST(fli.wheels_on / 100 AS INT64) 
        END,
        MOD(fli.wheels_on, 100)
      )
    )
  ELSE NULL
END AS wheels_on_parsed,

CASE
  WHEN fli.crs_arr_time IS NOT NULL THEN 
    PARSE_TIME(
      "%H:%M:%S", 
      FORMAT(
        '%02d:%02d:00',
        CASE WHEN CAST(fli.crs_arr_time / 100 AS INT64) = 24 THEN 0 
             ELSE CAST(fli.crs_arr_time / 100 AS INT64) 
        END,
        MOD(fli.crs_arr_time, 100)
      )
    )
  ELSE NULL
END AS crs_arr_time_parsed,

CASE
  WHEN fli.arr_time IS NOT NULL THEN 
    PARSE_TIME(
      "%H:%M:%S", 
      FORMAT(
        '%02d:%02d:00',
        CASE WHEN CAST(fli.arr_time / 100 AS INT64) = 24 THEN 0 
             ELSE CAST(fli.arr_time / 100 AS INT64) 
        END,
        MOD(fli.arr_time, 100)
      )
    )
  ELSE NULL
END AS arr_time_parsed


FROM
    laboratoria-projeto-04.flight_stats_jan2023.flights_202301 fli
LEFT JOIN
    laboratoria-projeto-04.flight_stats_jan2023.dot_code_dictionary dot ON (fli.dot_code = dot.code)
LEFT JOIN
    laboratoria-projeto-04.flight_stats_jan2023.airline_code_dictionary air ON (fli.airline_code = air.code)
LEFT JOIN
    laboratoria-projeto-04.flight_stats_jan2023.cancellation_code_dictionary ccd ON (fli.cancellation_code = ccd.code) )

# depois dos horários com formatos corrigidos, começamos a montar a tabela final

SELECT
  fl_date AS flight_date,
  # dia da semana
  FORMAT_DATE('%A', fl_date) AS weekday_name,
  airline_code,
  airline_description,
  dot_code,
  dot_description,
  fl_number AS flight_number,
  # concatena companhia e voo para ficar mais fácil a visualização
  CONCAT(airline_code, ' ', fl_number) AS flight_id,
  # concatena origem e destino para ficar mais fácil a visualização
  CONCAT(origin, ' to ', dest) AS route_id,
  origin,
  origin_city,
  dest AS destination,
  dest_city AS destination_city,
  crs_dep_time_parsed AS crs_dep_time,
  dep_time_parsed AS dep_time,
  dep_delay,
  taxi_out,
  wheels_off_parsed AS wheels_off,
  wheels_on_parsed AS wheels_on,
  taxi_in,
  # tempo total de taxiamento = partida + chegada
  (taxi_out + taxi_in) AS taxi_time_total,
  crs_arr_time_parsed AS crs_arr_time,
  arr_time_parsed AS arr_time,
  arr_delay,
CASE 
  WHEN arr_delay IS NOT NULL AND arr_delay >=15 THEN 1
  ELSE 0
END AS delayed,
  cancelled,
  cancellation_code,
  cancellation_description AS cancellation_cause,
  diverted,
  crs_elapsed_time,
  elapsed_time,
  # o tempo de voo foi maior ou menor que o previsto? ganhamos tempo?
  (crs_elapsed_time - elapsed_time) AS schedule_time_gain,
  (dep_delay - arr_delay) AS delay_recovery,
  air_time,
  distance,
  delay_due_carrier,
  delay_due_weather,
  delay_due_nas,
  delay_due_security,
  delay_due_late_aircraft,

# determinando as causas de atraso 
CASE 
    WHEN delay_due_carrier >= GREATEST(
        delay_due_carrier, delay_due_weather, delay_due_nas, delay_due_security, delay_due_late_aircraft) THEN 'Carrier'
    WHEN delay_due_weather >= GREATEST(
        delay_due_carrier, delay_due_weather, delay_due_nas, delay_due_security, delay_due_late_aircraft) THEN 'Weather'
    WHEN delay_due_nas >= GREATEST(
        delay_due_carrier, delay_due_weather, delay_due_nas, delay_due_security, delay_due_late_aircraft) THEN 'NAS'
    WHEN delay_due_security >= GREATEST(
        delay_due_carrier, delay_due_weather, delay_due_nas, delay_due_security, delay_due_late_aircraft) THEN 'Security'
    WHEN delay_due_late_aircraft >= GREATEST(
        delay_due_carrier, delay_due_weather, delay_due_nas, delay_due_security, delay_due_late_aircraft) THEN 'Late Aircraft'
    ELSE 'No Delay Cause'
END AS main_delay_cause,

# esse tipo de atraso é o que gera atrasos em cascata
CASE 
    WHEN delay_due_late_aircraft > 0 THEN 1 
    ELSE 0 
END AS cascade_delay_flag,
  
# cria quartis para atrasos na partida
NTILE(4) OVER (ORDER BY dep_delay) AS dep_delay_quartile,

# cria quartis para tempo de taxiamento na partida
NTILE(4) OVER (ORDER BY taxi_out) AS taxi_out_quartile,

# cria quartis para tempo de taxiamento na chegada
NTILE(4) OVER (ORDER BY taxi_in) AS taxi_in_quartile,

# cria quartis para distancia
NTILE(4) OVER (ORDER BY distance) AS distance_quartile,

# cria quartis para atrasos na chegada
NTILE(4) OVER (ORDER BY arr_delay) AS arr_delay_quartile,
  
# faixas manuais para atraso na chegada
CASE
    WHEN arr_delay BETWEEN 15 AND 50 THEN 'Delay 15-50 min'
    WHEN arr_delay BETWEEN 51 AND 120 THEN 'Delay 51-120 min'
    WHEN arr_delay BETWEEN 121 AND 360 THEN 'Delay 121-360 min'
    WHEN arr_delay > 360 THEN 'Delay >360 min'
    ELSE 'On Time or Earlier'
END AS range_arr_delay,
  
# período da partida programada
CASE
    WHEN EXTRACT(HOUR FROM crs_dep_time_parsed) BETWEEN 5 AND 11 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM crs_dep_time_parsed) BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN EXTRACT(HOUR FROM crs_dep_time_parsed) BETWEEN 18 AND 23 THEN 'Night'
    ELSE 'Red-Eye'
END AS scheduled_dep_period

FROM
  base;