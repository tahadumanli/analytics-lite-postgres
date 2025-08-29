SELECT
  event_time::date AS day,
  COUNT(DISTINCT user_id) AS dau
FROM events
GROUP BY 1
ORDER BY 1;
