-- models/int/int__reviews_daily.sql
{{ config(materialized='view') }}
/* Align reviews to day/listing without exploding upstream */
select
  listing_id,
  review_date as dt,
  count(*)            as review_count_1d,
  avg(review_score)   as avg_review_score_1d
from {{ ref('stg__generated_reviews') }}
group by 1,2