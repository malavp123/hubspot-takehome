-- models/staging/stg_amenities_changelog.sql
with src as (
  select * from {{ ref('AMENITIES_CHANGELOG') }}
)
select
  cast(listing_id as bigint)       as listing_id,
  try_cast(change_at as timestamp) as change_at,
  amenities                        as amenities_json
from src
