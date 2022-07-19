{{ config(sort=['user_id', 'year', 'month', 'day'], dist='song_id') }}

SELECT 
    ROW_NUMBER() OVER() AS _id,
    songs._id AS song_id,
    pve.duration AS duration,
    levels._id as levels_id,
    users._id AS user_id,
    addresses._id AS address_id,
    le.session_id AS session_id,    
    le.longitude,
    le.latitude,
    le.timestamp AS timestamp,
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
    ((le.day - (le.day_of_week - 1)) + 7) AS end_of_week,
    le.item_in_session

FROM {{ source('dev', 'listen_events') }} as le
JOIN {{ ref('addresses') }} as addresses
ON le.city = addresses.city
AND le.state = addresses.state
JOIN {{ ref('songs') }} AS songs
ON le.song = songs.title
AND songs.title <> 'N/A'
JOIN {{ ref('levels') }} AS levels
ON le.level = levels.level
JOIN {{ ref('users') }} AS users
ON le.user_id = users.user_id
AND users.user_id <> -404
JOIN {{ source('dev', 'page_view_events') }} AS pve
ON le.session_id = pve.session_id
AND le.user_id = pve.user_id