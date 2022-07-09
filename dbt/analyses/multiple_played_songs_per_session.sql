WITH t1 AS (
  SELECT
    song.title AS song,
    users.full_name AS user,    
    sp.duration AS duration,
    song.artist_name AS artist,
    sp.session_id,
    RANK() OVER(PARTITION BY session_id, song)
  FROM
      staging.songs_played AS sp
  JOIN staging.songs AS song
  ON sp.song_id = song._id
  JOIN staging.users AS users
  ON sp.user_id = users._id
  WHERE 
      sp.hour BETWEEN 12 AND 15)
)

SELECT * 
FROM t1