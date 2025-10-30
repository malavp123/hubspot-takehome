-- models/stage/stg__generated_reviews.sql
{{ config(materialized='view') }}
select
  id::number           as review_id,
  listing_id::number   as listing_id,
  review_score::number as review_score,       
  try_to_date(review_date) as review_date    
from {{ ref('GENERATED_REVIEWS') }}
