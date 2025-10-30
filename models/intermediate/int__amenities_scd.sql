-- models/int/int__amenities_scd.sql
{{ config(materialized='view') }}
/* Build SCD-like windows from change log (no dbt snapshot needed) */
with ordered as (
  select
    listing_id,
    change_at::date as valid_from,
    lead(change_at::date) over (partition by listing_id order by change_at) as valid_to,
    amenity_air_conditioning,
    amenity_lockbox,
    amenity_first_aid_kit
  from {{ ref('stg__amenities_changelog') }}
)
select
  listing_id,
  valid_from,
  valid_to,  -- null = open-ended current state
  amenity_air_conditioning,
  amenity_lockbox,
  amenity_first_aid_kit
from ordered
