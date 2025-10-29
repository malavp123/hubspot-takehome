-- models/staging/stg_calendar.sql
with src as (
  select * from {{ ref('CALENDAR') }}
),
norm as (
  select
    cast(listing_id as bigint)    as listing_id,
    try_cast(date as date)        as date,
    case lower(available)
      when 't' then true
      when 'f' then false
      else null end               as is_available,
    cast(reservation_id as bigint) as reservation_id,
    {{ as_currency('price') }}    as price_usd,
    cast(minimum_nights as int)   as min_nights,
    cast(maximum_nights as int)   as max_nights
  from src
)
select * from norm
