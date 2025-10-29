-- models/intermediate/int_revenue_occupancy.sql
with c as (
  select
    listing_id,
    date,
    is_available,
    reservation_id,
    price_usd,
    min_nights,
    max_nights,
    case when reservation_id is not null then 1 else 0 end as is_booked,
    case when reservation_id is not null then price_usd else 0 end as revenue
  from {{ ref('stg__calendar') }}
)
select * from c
