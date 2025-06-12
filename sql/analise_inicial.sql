
##########################
# TABELA SOBRE VOOS
##########################

# verificando nulos
SELECT
  COUNTIF(FL_DATE IS NULL) AS nulos_FL_DATE,
  COUNTIF(AIRLINE_CODE IS NULL) AS nulos_AIRLINE_CODE,
  COUNTIF(DOT_CODE IS NULL) AS nulos_DOT_CODE,
  COUNTIF(FL_NUMBER IS NULL) AS nulos_FL_NUMBER,
  COUNTIF(ORIGIN IS NULL) AS nulos_ORIGIN,
  COUNTIF(ORIGIN_CITY IS NULL) AS nulos_ORIGIN_CITY,
  COUNTIF(DEST IS NULL) AS nulos_DEST,
  COUNTIF(DEST_CITY IS NULL) AS nulos_DEST_CITY,
  COUNTIF(CRS_DEP_TIME IS NULL) AS nulos_CRS_DEP_TIME,
  COUNTIF(DEP_TIME IS NULL) AS nulos_DEP_TIME,
  COUNTIF(DEP_DELAY IS NULL) AS nulos_DEP_DELAY,
  COUNTIF(TAXI_OUT IS NULL) AS nulos_TAXI_OUT,
  COUNTIF(WHEELS_OFF IS NULL) AS nulos_WHEELS_OFF,
  COUNTIF(WHEELS_ON IS NULL) AS nulos_WHEELS_ON,
  COUNTIF(TAXI_IN IS NULL) AS nulos_TAXI_IN,
  COUNTIF(CRS_ARR_TIME IS NULL) AS nulos_CRS_ARR_TIME,
  COUNTIF(ARR_TIME IS NULL) AS nulos_ARR_TIME,
  COUNTIF(ARR_DELAY IS NULL) AS nulos_ARR_DELAY,
  COUNTIF(CANCELLED IS NULL) AS nulos_CANCELLED,
  COUNTIF(CANCELLATION_CODE IS NULL) AS nulos_CANCELLATION_CODE,
  COUNTIF(DIVERTED IS NULL) AS nulos_DIVERTED,
  COUNTIF(CRS_ELAPSED_TIME IS NULL) AS nulos_CRS_ELAPSED_TIME,
  COUNTIF(ELAPSED_TIME IS NULL) AS nulos_ELAPSED_TIME,
  COUNTIF(AIR_TIME IS NULL) AS nulos_AIR_TIME,
  COUNTIF(DISTANCE IS NULL) AS nulos_DISTANCE,
  COUNTIF(DELAY_DUE_CARRIER IS NULL) AS nulos_DELAY_DUE_CARRIER,
  COUNTIF(DELAY_DUE_WEATHER IS NULL) AS nulos_DELAY_DUE_WEATHER,
  COUNTIF(DELAY_DUE_NAS IS NULL) AS nulos_DELAY_DUE_NAS,
  COUNTIF(DELAY_DUE_SECURITY IS NULL) AS nulos_DELAYDUESECURITY,
  COUNTIF(DELAY_DUE_LATE_AIRCRAFT IS NULL) AS nulos_DELAY_DUE_LATE_AIRCRAFT
FROM
  `laboratoria-projeto-04.flight_stats_jan2023.flights_202301`;

# verificando hora da partida null se é porque foi cancelado
SELECT
  *
FROM
  `laboratoria-projeto-04.flight_stats_jan2023.flights_202301`
WHERE DEP_TIME IS NOT NULL AND CANCELLED = 1
LIMIT 10;

# 

SELECT 
    FL_DATE,
    AIRLINE_CODE,
    FL_NUMBER,
    ORIGIN,
    DEST,
    CANCELLED,
    DEP_TIME,
    ARR_TIME,
    WHEELS_OFF,
    WHEELS_ON,
    DEP_DELAY,
    ARR_DELAY,
    AIR_TIME,
    ELAPSED_TIME
FROM 
    `laboratoria-projeto-04.flight_stats_jan2023.flights_202301`
WHERE 
    CANCELLED = 1
    AND (
        DEP_TIME IS NOT NULL
        OR ARR_TIME IS NOT NULL
        OR WHEELS_OFF IS NOT NULL
        OR WHEELS_ON IS NOT NULL
        OR DEP_DELAY IS NOT NULL
        OR ARR_DELAY IS NOT NULL
        OR AIR_TIME IS NOT NULL
        OR ELAPSED_TIME IS NOT NULL
    );


# total de voos cancelados
SELECT
  *
FROM
  `laboratoria-projeto-04.flight_stats_jan2023.flights_202301`
WHERE CANCELLED = 1;

# total de voos cancelados
SELECT
  COUNTIF(DIVERTED = 1) AS DIVERTED,
  COUNTIF(DIVERTED = 0) AS NOTDIVERTED,
  COUNTIF(CANCELLED = 1) AS CANCELLED,
  COUNTIF(CANCELLED = 0) AS NOTCANCELLED
FROM
  `laboratoria-projeto-04.flight_stats_jan2023.flights_202301`
WHERE 
  ELAPSED_TIME IS NULL AND AIR_TIME IS NULL;

# total de voos cancelados
SELECT
*
FROM
  `laboratoria-projeto-04.flight_stats_jan2023.flights_202301`
WHERE
  (DEP_TIME IS NOT NULL AND WHEELS_OFF IS NULL) OR (TAXI_OUT IS NOT NULL AND WHEELS_OFF IS NULL) ;

# Voos cancelados antes de qualquer procedimento (não saiu do portão)
SELECT COUNT(*) 
FROM `laboratoria-projeto-04.flight_stats_jan2023.flights_202301`
WHERE CANCELLED = 1 AND DEP_TIME IS NULL;

# Voos que saíram do portão, mas não decolaram (cancelados após DEP_TIME, sem WHEELS_OFF)
SELECT COUNT(*)
FROM `laboratoria-projeto-04.flight_stats_jan2023.flights_202301`
WHERE CANCELLED = 1 AND DEP_TIME IS NOT NULL AND WHEELS_OFF IS NULL;

#Voos que decolaram, mas não pousaram (possíveis falhas no dado ou voos interrompidos)
SELECT COUNT(*)
FROM `laboratoria-projeto-04.flight_stats_jan2023.flights_202301`
WHERE WHEELS_OFF IS NOT NULL AND WHEELS_ON IS NULL;

#Verificar se os nulos estão associados a CANCELLED ou DIVERTED
SELECT 
  COUNTIF(CANCELLED = 1) AS Cancelled,
  COUNTIF(DIVERTED = 1) AS Diverted,
  COUNTIF(CANCELLED = 0 AND DIVERTED = 0) AS Normal
FROM `laboratoria-projeto-04.flight_stats_jan2023.flights_202301`
WHERE WHEELS_ON IS NULL AND TAXI_IN IS NULL AND ARR_TIME IS NULL;

#Cruzar todos os nulos dos tempos de voo e entender onde há overlap
SELECT 
  COUNTIF(DEP_TIME IS NULL) AS DEP_TIME_NULO,
  COUNTIF(TAXI_OUT IS NULL) AS TAXI_OUT_NULO,
  COUNTIF(WHEELS_OFF IS NULL) AS WHEELS_OFF_NULO,
  COUNTIF(WHEELS_ON IS NULL) AS WHEELS_ON_NULO,
  COUNTIF(ARR_TIME IS NULL) AS ARR_TIME_NULO
FROM `laboratoria-projeto-04.flight_stats_jan2023.flights_202301`;

# Validar se há voos não cancelados com tempos nulos (problemas de dados)
SELECT COUNT(*)
FROM `laboratoria-projeto-04.flight_stats_jan2023.flights_202301`
WHERE CANCELLED = 0 AND 
      (DEP_TIME IS NULL OR WHEELS_OFF IS NULL OR WHEELS_ON IS NULL OR ARR_TIME IS NULL);

#Verificar se esses são os desviados
SELECT COUNT(*)
FROM `laboratoria-projeto-04.flight_stats_jan2023.flights_202301`
WHERE DIVERTED = 1 AND 
      (DEP_TIME IS NULL OR WHEELS_OFF IS NULL OR WHEELS_ON IS NULL OR ARR_TIME IS NULL);

#Verificar voos desviados (DIVERTED = 1) e se eles explicam parte dos nulos
SELECT COUNT(*)
FROM `laboratoria-projeto-04.flight_stats_jan2023.flights_202301`
WHERE DIVERTED = 1;


SELECT *
FROM `laboratoria-projeto-04.flight_stats_jan2023.flights_202301`
WHERE DEP_TIME IS NOT NULL AND TAXI_OUT IS NULL;

SELECT
  FL_NUMBER,
  FL_DATE
FROM `laboratoria-projeto-04.flight_stats_jan2023.flights_202301`
ORDER BY FL_NUMBER;

# verificando campos duplicados por informações que realmente discrimiram um voos
SELECT
  FL_DATE,
  AIRLINE_CODE,
  DOT_CODE,
  FL_NUMBER,
  ORIGIN,
  ORIGIN_CITY,
  DEST,
  DEST_CITY,
  COUNT(*) AS duplicados
FROM laboratoria-projeto-04.flight_stats_jan2023.flights_202301
GROUP BY
  FL_DATE,
  AIRLINE_CODE,
  DOT_CODE,
  FL_NUMBER,
  ORIGIN,
  ORIGIN_CITY,
  DEST,
  DEST_CITY
HAVING COUNT(*) > 1
ORDER BY duplicados DESC;

#####################################
# TABELA COM CÓDIGO DAS CIAS AEREAS
#####################################

SELECT
  COUNTIF(Code IS NULL) AS Code,
  COUNTIF(Description IS NULL) AS Description,
FROM `laboratoria-projeto-04.flight_stats_jan2023.airline_code_dictionary`;

SELECT
  Code AS Code,
  Description AS Description,
  COUNT(*) AS duplicados
FROM `laboratoria-projeto-04.flight_stats_jan2023.airline_code_dictionary`
GROUP BY
  Code,
  Description
HAVING COUNT(*) > 1
ORDER BY duplicados DESC;


SELECT
  COUNT(Code) AS Qtd_Code,
  COUNT(Description) AS Qtd_Description,
  COUNT(DISTINCT Code) AS Qtd_Code_Diferentes,
  COUNT(DISTINCT Description) AS Qtd_Description_Diferentes
FROM `laboratoria-projeto-04.flight_stats_jan2023.airline_code_dictionary`;



SELECT 
  LOWER(REGEXP_REPLACE(Description, r'[^a-zA-Z0-9]', '')) AS descricao_normalizada,
  COUNT(*) AS qtd,
  STRING_AGG(Description, ' | ') AS descricoes_variantes
FROM `laboratoria-projeto-04.flight_stats_jan2023.airline_code_dictionary`
GROUP BY descricao_normalizada
HAVING COUNT(*) > 1
ORDER BY qtd DESC;


########################################################
# TABELA COM  CÓDIGO DOT (Department of Transportation)
########################################################


SELECT
  COUNTIF(Code IS NULL) AS Code,
  COUNTIF(Description IS NULL) AS Description
FROM `laboratoria-projeto-04.flight_stats_jan2023.dot_code_dictionary`;

SELECT
  Code AS Code,
  Description AS Description
FROM `laboratoria-projeto-04.flight_stats_jan2023.dot_code_dictionary`
WHERE Description IS NULL;

SELECT
  Code AS Code,
  Description AS Description,
  COUNT(*) AS duplicados
FROM `laboratoria-projeto-04.flight_stats_jan2023.dot_code_dictionary`
GROUP BY
  Code,
  Description
HAVING COUNT(*) > 1
ORDER BY duplicados DESC;


# analisando duplicidades e relações entre as colunas

SELECT
  COUNT(Code) AS Qtd_Code,
  COUNT(Description) AS Qtd_Description,
  COUNT(DISTINCT Code) AS Qtd_Code_Diferentes,
  COUNT(DISTINCT Description) AS Qtd_Description_Diferentes
FROM `laboratoria-projeto-04.flight_stats_jan2023.dot_code_dictionary`;



### para verificar quais são os códigos que aparacem mais de uma vez 

SELECT
  Code,
  COUNT(*) AS qtd_registros
FROM
  `laboratoria-projeto-04.flight_stats_jan2023.dot_code_dictionary`
GROUP BY
  Code
HAVING
  COUNT(*) > 1
ORDER BY
  qtd_registros DESC;


# visualizar valores desses codigos repetidos 

SELECT
  Code,
  Description
FROM
  `laboratoria-projeto-04.flight_stats_jan2023.dot_code_dictionary`
WHERE Code IN (22114, 22115, 22116, 22117, 22120, 22121, 22122, 22123);


# onde estao as duplicidades nas descrições

SELECT 
    Code,
    COUNT(DISTINCT Description) AS qtd_descriptions,
    STRING_AGG(DISTINCT Description, ' | ') AS descriptions # extrai as descrições separadas por |
FROM 
    `laboratoria-projeto-04.flight_stats_jan2023.dot_code_dictionary`
GROUP BY 
    Code
HAVING 
    COUNT(DISTINCT Description) > 1
ORDER BY 
    Code;


# descriçoes repetidas?

SELECT 
  LOWER(REGEXP_REPLACE(Description, r'[^a-zA-Z0-9]', '')) AS descricao_normalizada,
  COUNT(*) AS qtd,
  STRING_AGG(Description, ' | ') AS descricoes_variantes
FROM `laboratoria-projeto-04.flight_stats_jan2023.dot_code_dictionary`
GROUP BY descricao_normalizada
HAVING COUNT(*) > 1
ORDER BY qtd DESC;






###################################################
#verificar se campos faltantes estao na tabela voos
###################################################

SELECT
  *
FROM
  `laboratoria-projeto-04.flight_stats_jan2023.flights_202301`
  
WHERE DOT_CODE = 22114 OR DOT_CODE = 22115 OR DOT_CODE = 22116 OR DOT_CODE = 22117;


#################################################
# quais são os códigos de motivo de cancelamento
#################################################

SELECT
  CANCELLATION_CODE
FROM
  `laboratoria-projeto-04.flight_stats_jan2023.flights_202301`
GROUP BY CANCELLATION_CODE;


















