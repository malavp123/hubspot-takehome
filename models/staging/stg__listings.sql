-- models/staging/stg_listings.sql
with src as (
  select * from {{ ref('LISTINGS') }}
)
select
  cast(id as bigint)              as listing_id,
  name,
  cast(host_id as bigint)         as host_id,
  host_name,
  try_cast(host_since as timestamp) as host_since,
  host_location,
  /* host_verifications: keep raw; parse if needed later */
  host_verifications,
  neighborhood,
  property_type,
  room_type,
  cast(accommodates as int)       as accommodates,
  bathrooms_text,
  cast(bedrooms as int)           as bedrooms,
  cast(beds as int)               as beds,
  amenities,                      -- JSON-like string
  {{ as_currency('price') }}      as price_usd_listed,
  cast(number_of_reviews as int)  as number_of_reviews,
  try_cast(first_review as date)  as first_review_date,
  try_cast(last_review as date)   as last_review_date,
  try_cast(review_scores_rating as double) as avg_review_score_reported
from src