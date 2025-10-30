-- snapshots/amenities_scd.sql
{% snapshot amenities_scd %}
{{
  config(
    target_schema = target.schema,
    unique_key    = 'listing_id',
    strategy      = 'check',
    check_cols    = ['amenity_ac', 'amenity_wifi', 'amenity_tv', 'amenity_heating', 'amenity_kitchen'],
    enabled       = false
  )
}}
select
  listing_id,
  change_date,
  amenity_ac,
  amenity_wifi,
  amenity_tv,
  amenity_heating,
  amenity_kitchen
from {{ ref('stg__amenities_changelog') }}
{% endsnapshot %}