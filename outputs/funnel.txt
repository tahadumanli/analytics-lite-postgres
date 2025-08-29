WITH firsts AS (
  SELECT
    user_id,
    MIN(event_time) FILTER (WHERE event_name = 'signup')   AS s_ts,
    MIN(event_time) FILTER (WHERE event_name = 'purchase') AS p_ts
  FROM events
  GROUP BY user_id
)
SELECT
  COUNT(*) FILTER (WHERE s_ts IS NOT NULL)                   AS signed_up,
  COUNT(*) FILTER (WHERE p_ts > s_ts)                        AS purchased_after_signup
FROM firsts;
