
WITH T1 as (
  SELECT user_id, song_id, SUM(duration) AS total_duration, COUNT(*) AS stream_amount
  FROM staging.songs_played
  WHERE duration <> -404
  GROUP BY user_id, song_id
  
 )
 
 SELECT u.full_name AS user, S.title AS song, t1.total_duration, T1.stream_amount
 FROM T1
 JOIN staging.users AS u 
 ON t1.user_id = u._id
 JOIN staging.songs AS s 
 ON t1.song_id = s._id
 ORDER BY stream_amount DESC