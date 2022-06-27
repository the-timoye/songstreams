{{ config(sort=['user_id', 'absolute_date'], dist='song_id') }}

SELECT 
    songs._id AS song_id,
    artists._id AS artist_id,
    pve.duration AS duration,
    levels._id as levels_id,
    users._id AS user_id,
    addresses._id AS address_id,
    le.session_id AS session_id,    
    le.longitude,
    le.latitude,
    le.timestamp AS timestamp,
    le.abs_date AS absolute_date,    
    le.item_in_session,
    ae.success as is_authenticated,
    ae.timestamp as auth_at

FROM {{ source('dev', 'listen_events') }} as le
JOIN {{ ref('addresses') }} as addresses
ON le.city = addresses.city
AND le.state = addresses.state
JOIN {{ ref('songs') }} AS songs
ON le.song = songs.title
JOIN {{ ref('artists') }} as artists
ON le.artist = artists.name
JOIN {{ ref('levels') }} AS levels
ON le.level = levels.level
JOIN {{ ref('users') }} AS users
ON le.user_id = users.user_id
JOIN {{ source('dev', 'page_view_events') }} AS pve
ON le.session_id = pve.session_id
AND le.user_id = pve.user_id
JOIN {{ source('dev', 'auth_events') }} AS ae
ON le.session_id = ae.session_id
AND le.user_id = ae.user_id
