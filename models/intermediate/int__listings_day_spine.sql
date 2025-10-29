-- models/intermediate/int_listing_day_spine.sql
-- Thin daily spine (one row per listing_id, date)
select
  listing_id,
  date
from {{ ref('stg__calendar') }}
