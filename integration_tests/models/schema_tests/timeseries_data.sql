with dates as (

    select * from {{ ref('timeseries_base') }}

),
add_row_values as (

    select
        date_day,
        cast(date_day as {{ dbt_expectations.type_datetime() }}) as date_datetime,
        cast(date_day as {{ type_timestamp() }}) as date_timestamp,
        cast(abs({{ dbt_expectations.rand() }}) as {{ type_float() }}) as row_value
    from
        dates

),
add_logs as (

    select
        *,
        {{ dbt_expectations.log_natural('nullif(row_value, 0)') }} as row_value_log
    from
        add_row_values
)
select *
from
    add_logs
