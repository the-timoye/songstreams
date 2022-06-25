WITH listen_users AS 
(
    SELECT
     DISTINCT le.user_id,
        le.first_name,
        le.last_name,
        le.first_name || ' ' || le.last_name AS full_name,
        le.gender,
        ad.city AS city,
        ad.state AS state,
        ad._id AS address_id,
        le.latitude,
        le.longitude
    FROM {{source('dev', 'listen_events')}} le
    JOIN {{ref('addresses')}} AS ad
    ON le.city = ad.city
    AND le.state = ad.state
),

auth_users AS (
    SELECT 
    DISTINCT le.user_id,
        le.first_name,
        le.last_name,
        le.first_name || ' ' || le.last_name AS full_name,
        le.gender,
        ad.city AS city,
        ad.state AS state,
        ad._id AS address_id,
        le.latitude,
        le.longitude
    FROM {{source('dev', 'auth_events')}} AS le
    JOIN {{ref('addresses')}} AS ad
    ON le.city = ad.city
    AND le.state = ad.state
),

page_view_users AS (
    SELECT 
    DISTINCT le.user_id,
        le.first_name,
        le.last_name,
        le.first_name || ' ' || le.last_name AS full_name,
        le.gender,
        ad.city AS city,
        ad.state AS state,
        ad._id AS address_id,
        le.latitude,
        le.longitude
    FROM {{source('dev', 'page_view_events')}} AS le
    JOIN {{ref('addresses')}} AS ad
    ON le.city = ad.city
    AND le.state = ad.state
),

all_users AS (
    SELECT *
    FROM listen_users
    UNION
    SELECT *
    FROM auth_users
    UNION 
    SELECT *
    FROM page_view_users
)

SELECT {{ dbt_utils.surrogate_key(
    'user_id',
    'latitude',
    'longitude'
  ) }} AS _id, *
FROM all_users
