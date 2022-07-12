
WITH T1 AS (
  SELECT DISTINCT user_id, level
  FROM staging.user_actions
 )
 
 SELECT level, COUNT(*) AS total
 FROM T1
 GROUP BY level
 ORDER BY total