-- for listen events from user events table
SELECT event, address_id, longitude, latitude, COUNT(*) AS total
FROM staging.user_actions ua
WHERE event = 'listen'
GROUP BY address_id, longitude, latitude, event
ORDER BY total DESC

-- for listen events from songs played table
SELECT address_id, longitude, latitude, COUNT(*) AS total
FROM staging.songs_played
GROUP BY address_id, longitude, latitude
ORDER BY total DESC