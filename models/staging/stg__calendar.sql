-- models/stage/stg__calendar.sql
{{ config(materialized='view') }}
select
  listing_id::number                        as listing_id,
  try_to_date(date)                         as dt,                         -- daily grain
  case when lower(available) = 't' then 1 else 0 end as is_available,     -- 't' / 'f' → 1/0  :contentReference[oaicite:4]{index=4}
  reservation_id::number                    as reservation_id,            -- occupied if not null  :contentReference[oaicite:5]{index=5}
  try_to_number(regexp_replace(price, '[^0-9.]', '')) as price_usd,       -- varchar → numeric  :contentReference[oaicite:6]{index=6}
  minimum_nights::number                    as min_nights,
  maximum_nights::number                    as max_nights
from {{ ref('CALENDAR') }}
