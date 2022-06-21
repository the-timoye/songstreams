
with listen_events_artists as (
    SELECT DISTINCT(le.artist)
    FROM {{source('dev', 'listen_events')}} AS le
),

page_view_events_artists AS (
    SELECT DISTINCT(artist)
    FROM {{source('dev', 'page_view_events')}}
),

all_artists AS (
    SELECT artist
    FROM listen_events_artists
    UNION
    SELECT artist
    FROM page_view_events_artists
)

SELECT *
FROM all_artists