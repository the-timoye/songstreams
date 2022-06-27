WITH listen_songs AS (
    SELECT 
        DISTINCT le.song as title,
        le.artist AS artist_name,
        ar._id AS artist_id
    FROM {{source('dev', 'listen_events')}} AS le
    JOIN {{ ref('artists') }} AS ar
    ON ar.name = le.artist
    WHERE song <> 'N/A'
),
page_view_songs AS (
    SELECT 
        DISTINCT song as title,
        le.artist AS artist_name,
        ar._id AS artist_id
    FROM {{ source('dev', 'page_view_events') }} AS le
    JOIN {{ ref('artists') }} AS ar
    ON ar.name = le.artist
    WHERE song <> 'N/A'
),
all_songs AS (
    SELECT * FROM listen_songs
    UNION
    SELECT * FROM page_view_songs
)

SELECT {{ dbt_utils.surrogate_key(
    'title',
    'artist_id'
  ) }} AS _id, title, artist_id, artist_name
FROM all_songs

