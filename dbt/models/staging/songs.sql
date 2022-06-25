WITH listen_songs AS (
    SELECT 
        DISTINCT song as title,
        le.artist AS artist_name,
        ar._id AS artist_id
    FROM {{source('dev', 'listen_events')}} AS le
    JOIN {{ ref('artists') }} AS ar
    ON ar.name = le.artist
),
page_view_songs AS (
    SELECT 
        DISTINCT song as title,
        le.artist AS artist_name,
        ar._id AS artist_id
    FROM {{ source('dev', 'page_view_events') }} AS le
    JOIN {{ ref('artists') }} AS ar
    ON ar.name = le.artist
),
all_songs AS (
    SELECT * FROM listen_songs
    UNION
    SELECT * FROM page_view_songs
)

SELECT {{ dbt_utils.surrogate_key(
    'artist'
  ) }} AS _id, *
FROM all_songs

