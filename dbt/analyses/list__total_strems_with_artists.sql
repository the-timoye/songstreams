-- Most streamed song with artist. Shows total number of streamers and total duration of the stream of that song
WITH table1 AS (SELECT song_id, COUNT(*) as total_streamers, SUM(duration) AS total_duration
FROM staging.songs_played
WHERE duration <> -404
GROUP BY song_id)


SELECT s.title AS song, s.artist_name, table1.total_streamers, table1.total_duration
FROM staging.songs AS s, table1
WHERE s._id = table1.song_id
ORDER BY table1.total_duration DESC