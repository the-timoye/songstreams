WITH T1 AS (
  SELECT DISTINCT user_id, level, address_id
  FROM staging.user_actions
 ), T2 AS (
   SELECT level, COUNT(*) AS total_actions, address_id
	FROM T1
	GROUP BY level, address_id
   )
 SELECT level, total_actions, city, state
 FROM T2, staging.addresses AS  ad
 WHERE T2.address_id = ad._id