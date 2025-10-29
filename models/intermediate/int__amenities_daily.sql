-- models/intermediate/int_amenities_daily.sql
-- Build amenity "periods" then explode to dates
with periods as (
  select
    listing_id,
    cast(change_at as date) as valid_from,
    lead(cast(change_at as date), 1, date '2999-12-31')
      over (partition by listing_id order by change_at) as valid_to,
    {{ json_array_to_list('amenities_json') }} as amen_list
  from {{ ref('stg__amenities_changelog') }}
),
dates as (
  select listing_id, date
  from {{ ref('int__listings_day_spine') }}
),
expanded as (
  select d.listing_id, d.date, p.amen_list
  from dates d
  join periods p
    on d.listing_id = p.listing_id
   and d.date >= p.valid_from
   and d.date <  p.valid_to
)
select
  listing_id,
  date,
  -- flags we care about for the assessment
  {{ array_contains('amen_list', "'Air conditioning'") }}  as has_air_conditioning,
  {{ array_contains('amen_list', "'Lockbox'") }}           as has_lockbox,
  {{ array_contains('amen_list', "'First aid kit'") }}     as has_first_aid_kit
from expanded
