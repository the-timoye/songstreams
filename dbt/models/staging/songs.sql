WITH listen_songs AS (
    SELECT 
        DISTINCT le.song as title,
        le.artist AS artist_name
    FROM {{source('dev', 'listen_events')}} AS le
),
page_view_songs AS (
    SELECT 
        DISTINCT song as title,
        le.artist AS artist_name
    FROM {{ source('dev', 'page_view_events') }} AS le
),
all_songs AS (
    SELECT * 
    FROM listen_songs
    UNION
    SELECT * FROM page_view_songs
)

SELECT {{ dbt_utils.surrogate_key(
    'title',
    'artist_name'
  ) }} AS _id, title, artist_name
FROM all_songs

