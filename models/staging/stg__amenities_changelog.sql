-- models/stage/stg__amenities_changelog.sql
{{ config(materialized='view') }}
-- Keep change grain; parse array → a few booleans we actually need (case-insensitive)
with base as (
  select
    listing_id::number            as listing_id,
    try_to_timestamp(change_at)   as change_at,      
    parse_json(amenities)         as amenities_json  
  from {{ ref('AMENITIES_CHANGELOG') }}
),
flags as (
  select
    b.listing_id, b.change_at, b.amenities_json,
    iff(count_if(lower(f.value::string) in ('air conditioning','ac')) > 0, 1, 0) as amenity_air_conditioning,
    iff(count_if(lower(f.value::string) in ('lockbox','lock box')) > 0, 1, 0) as amenity_lockbox,
    iff(count_if(lower(f.value::string) = 'first aid kit') > 0, 1, 0) as amenity_first_aid_kit
  from base b,
    lateral flatten(input => b.amenities_json) f
  group by b.listing_id, b.change_at, b.amenities_json
)
select * from flags
