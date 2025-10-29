-- models/staging/stg_reviews.sql
with src as (
  select * from {{ ref('GENERATED_REVIEWS') }}
)
select
  cast(id as bigint)             as review_id,
  cast(listing_id as bigint)     as listing_id,
  cast(review_score as int)      as review_score,
  try_cast(review_date as date)  as review_date
from src
