Analytics Lite (PostgreSQL-only)

Stores “user X did Y at time T” and answers three things: Daily users, Funnel, Retention. No app code. SQL only.

Tables

users

user_id (text, PK)

signup_date (timestamptz, UTC)

events

event_id (bigserial, PK)

user_id (text)

event_name (text) → page_view, click, signup, verify_email, purchase

event_time (timestamptz, UTC)

extra_info (jsonb)


Quick start

Create empty DB (e.g., analytics).

Load schema

pgAdmin: Tools → Query Tool → open schema/schema.sql → Run.

psql: psql -h localhost -U postgres -d analytics -f schema/schema.sql

(Optional) Import samples

pgAdmin: right-click table → Import/Export → CSV → pick samples/*.csv.

Run queries

pgAdmin: open each file in queries/ → Run.

psql: psql -h localhost -U postgres -d analytics -f queries/daily_active_users.sql (same for others).

If a query has from/to dates inside, edit them first.

What each query returns

daily_active_users.sql → one row per day with distinct user count.

funnel.sql (signup → verify_email → purchase) → three numbers: users who signed up, then verified, then purchased (within N days).

retention.sql → per signup day: cohort size and users who returned on day +1, +7, +14 (and %).

Conventions

UTC only for all timestamps.

Event names are fixed; spelling matters.

No real PII in samples. Do not commit live data.

Validate fast

SELECT COUNT(*) FROM events; → not zero.

SELECT MIN(event_time), MAX(event_time) FROM events; → inside your test window.

SELECT DISTINCT event_name FROM events; → expected names only.

Pick one user, sort by event_time, confirm signup → verify → purchase order.

Troubleshooting

Empty results → wrong date window or event names; check UTC.

“relation already exists” → DB isn’t fresh; drop tables or use a new DB.

Owner/permission errors → remove OWNER/GRANT lines in schema.sql or run as that owner.
