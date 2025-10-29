with calendar as (
    select *
    from {{ ref('CALENDAR') }}
)

select * from calendar
