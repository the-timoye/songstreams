-- Get whuch user played these songs the most

SELECT absolute_date, song.title AS song, SUM(duration) AS total_duration
FROM staging.songs_played AS songs_played
JOIN staging.songs AS song
ON songs_played.song_id = song._id
WHERE songs_played.hour = 14
AND duration <> -404
GROUP BY absolute_date, title
ORDER BY total_duration DESC
