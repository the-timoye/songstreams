{{ config(sort=['month', 'day', 'hour', 'minute', 'second'], dist='user_id') }}

WITH listen_events AS (
    SELECT 
        le.timestamp AS time_stamp,
        le.abs_date AS absolute_date,
        TO_NUMBER(SUBSTRING(le.timestamp, 1,4), 9999) AS year,
        le.month,
        le.day,
        CASE
            WHEN le.day_of_week = 1 THEN 'Sunday'
            WHEN le.day_of_week = 2 THEN 'Monday'
            WHEN le.day_of_week = 3 THEN 'Tueday'
            WHEN le.day_of_week = 4 THEN 'Wednessday'
            WHEN le.day_of_week = 5 THEN 'Thursday'
            WHEN le.day_of_week = 6 THEN 'Friday'
            WHEN le.day_of_week = 7 THEN 'Saturday'
            ELSE 'N/A'
        END AS roman_day_of_week,
        le.hour,
        TO_NUMBER(SUBSTRING(le.timestamp, 15,2), 99) AS minute,
        TO_NUMBER(SUBSTRING(le.timestamp, 18,2), 99) AS second,
        le.day_of_week,
        le.is_weekend,
        (le.day - (le.day_of_week - 1)) AS start_of_week,
        ((le.day - (le.day_of_week - 1)) + 6) AS end_of_week,
        'listen' AS event,
        users._id AS user_id,
        -404 AS duration,
        le.session_id AS session_id,
        le.auth AS auth,
        le.level AS level,
        addresses._id AS address_id,
        le.longitude AS longitude,
        le.latitude AS latitude,
        le.registration AS registration
    FROM {{ source('dev', 'listen_events') }} AS le
    JOIN {{ ref('users') }} AS users
    ON le.user_id = users.user_id
    AND users.user_id <> -404
    JOIN {{ ref('addresses') }} AS addresses
    ON le.city = addresses.city
    AND le.state = addresses.state
    JOIN {{ ref('levels') }} AS levels
    ON le.level = levels.level
),
auth_events AS (
    SELECT
        ae.timestamp AS time_stamp,
        ae.abs_date AS absolute_date,
        TO_NUMBER(SUBSTRING(ae.timestamp, 1,4), 9999) AS year,
        ae.month,
        ae.day,
        CASE
            WHEN ae.day_of_week = 1 THEN 'Sunday'
            WHEN ae.day_of_week = 2 THEN 'Monday'
            WHEN ae.day_of_week = 3 THEN 'Tueday'
            WHEN ae.day_of_week = 4 THEN 'Wednessday'
            WHEN ae.day_of_week = 5 THEN 'Thursday'
            WHEN ae.day_of_week = 6 THEN 'Friday'
            WHEN ae.day_of_week = 7 THEN 'Saturday'
            ELSE 'N/A'
        END AS roman_day_of_week,
        ae.hour,
        TO_NUMBER(SUBSTRING(ae.timestamp, 15,2), 99) AS minute,
        TO_NUMBER(SUBSTRING(ae.timestamp, 18,2), 99) AS second,
        ae.day_of_week,
        ae.is_weekend,
        (ae.day - (ae.day_of_week - 1)) AS start_of_week,
        ((ae.day - (ae.day_of_week - 1)) + 6) AS end_of_week,
        'auth' AS event,
        users._id AS user_id,
        -404 AS duration,
        ae.session_id AS session_id,
        CASE WHEN ae.success = 'true' THEN 'Yes' ELSE 'No' END AS auth,
        ae.level AS level,
        addresses._id AS address_id,
        ae.longitude AS longitude,
        ae.latitude AS latitude,
        ae.registration AS registration
    FROM {{ source('dev', 'auth_events') }} AS ae
    JOIN {{ ref('users') }} AS users
    ON ae.user_id = users.user_id
    AND users.user_id <> -404
    JOIN {{ ref('addresses') }} AS addresses
    ON ae.city = addresses.city
    AND ae.state = addresses.state
    JOIN {{ ref('levels') }} AS levels
    ON ae.level = levels.level
), 
page_view_events AS (
    SELECT
        pve.timestamp AS time_stamp,
        pve.abs_date AS absolute_date,
        TO_NUMBER(SUBSTRING(pve.timestamp, 1,4), 9999) AS year,
        pve.month,
        pve.day,
        CASE
            WHEN pve.day_of_week = 1 THEN 'Sunday'
            WHEN pve.day_of_week = 2 THEN 'Monday'
            WHEN pve.day_of_week = 3 THEN 'Tueday'
            WHEN pve.day_of_week = 4 THEN 'Wednessday'
            WHEN pve.day_of_week = 5 THEN 'Thursday'
            WHEN pve.day_of_week = 6 THEN 'Friday'
            WHEN pve.day_of_week = 7 THEN 'Saturday'
            ELSE 'N/A'
        END AS roman_day_of_week,
        pve.hour,
        TO_NUMBER(SUBSTRING(pve.timestamp, 15,2), 99) AS minute,
        TO_NUMBER(SUBSTRING(pve.timestamp, 18,2), 99) AS second,
        pve.day_of_week,
        pve.is_weekend,
        (pve.day - (pve.day_of_week - 1)) AS start_of_week,
        ((pve.day - (pve.day_of_week - 1)) + 6) AS end_of_week,
        'page_view' AS event,
        users._id AS user_id,
        pve.duration AS duration,
        pve.session_id AS session_id,
        pve.auth AS auth,
        pve.level AS level,
        addresses._id AS address_id,
        pve.longitude AS longitude,
        pve.latitude AS latitude,
        pve.registration AS registration
    FROM {{ source('dev', 'page_view_events') }} AS pve
    JOIN {{ ref('users') }} AS users
    ON pve.user_id = users.user_id
    AND users.user_id <> -404
    JOIN {{ ref('addresses') }} AS addresses
    ON pve.city = addresses.city
    AND pve.state = addresses.state
    JOIN {{ ref('levels') }} AS levels
    ON pve.level = levels.level
    WHERE pve.status = 200
),
all_events AS (
    SELECT *
    FROM page_view_events
    UNION ALL
    SELECT *
    FROM auth_events
    UNION ALL
    SELECT *
    FROM listen_events
)

SELECT *
FROM all_events