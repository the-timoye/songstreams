WITH auth_addresses AS (
    SELECT DISTINCT city, state
    FROM {{source('dev', 'auth_events')}}
),
listen_addresses AS (
    SELECT DISTINCT city, state
    FROM {{source('dev', 'listen_events')}}
),
page_view_addresses AS (
    SELECT DISTINCT city, state
    FROM {{source('dev', 'page_view_events')}}
),
all_addresses AS (
    SELECT *
    FROM auth_addresses
    UNION
    SELECT *
    FROM listen_addresses
    UNION
    SELECT *
    FROM page_view_addresses
)

SELECT {{ dbt_utils.surrogate_key(
    'city',
    'state'
  ) }} AS _id, city, state
FROM all_addresses