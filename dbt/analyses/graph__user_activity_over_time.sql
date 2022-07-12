SELECT hour, COUNT(*) as total_actions
FROM staging.user_actions
GROUP BY hour
ORDER BY total_actions DESC