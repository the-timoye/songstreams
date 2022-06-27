{{ config(sort=['month', 'day', 'hour'], dist='year') }}

WITH all_times AS (
    SELECT 
        le.abs_date AS absolute_date,
        le.timestamp,
        TO_NUMBER(SUBSTRING(le.timestamp, 1,4), 9999) AS year,
        le.month,
        le.day,
        le.hour,
        TO_NUMBER(SUBSTRING(le.timestamp, 15,2), 99) AS minute,
        TO_NUMBER(SUBSTRING(le.timestamp, 18,2), 99) AS second,
        le.day_of_week,
        le.is_weekend
    FROM {{ source('dev', 'listen_events') }} as le
    UNION
    SELECT 
        ae.abs_date AS absolute_date,
        ae.timestamp,
        SUBSTRING(ae.timestamp, 1,4),
        ae.month,
        ae.day,
        ae.hour,
        SUBSTRING(ae.timestamp, 16,2),
        SUBSTRING(ae.timestamp, 19,2),
        ae.day_of_week,
        ae.is_weekend
    FROM {{source('dev', 'auth_events')}} as ae
    UNION
    SELECT 
        pve.abs_date AS absolute_date,
        pve.timestamp,
        SUBSTRING(pve.timestamp, 1,4),
        pve.month,
        pve.day,
        pve.hour,
        SUBSTRING(pve.timestamp, 16,2),
        SUBSTRING(pve.timestamp, 19,2),
        pve.day_of_week,
        pve.is_weekend
    FROM {{source('dev', 'page_view_events')}} as pve
)


SELECT {{ dbt_utils.surrogate_key(
    'timestamp'
  ) }} AS _id, *
FROM all_times