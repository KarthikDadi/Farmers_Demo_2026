-- models/marts/sales/fct_sales_summary.sql
{{
  config(
    materialized='table',
    tags=['mart', 'sales', 'FACT_SALES_SUMMARY']
  )
}}

with int_sales_details as (

    select * from {{ ref('int_sales_details_joined') }}

),

final_aggregation as (

    select
        companycode,
        companyname,
        statecode,
        statename,
        skucode,
        itemname,
        active_flag,
        promotion_desc,
        effective_date_range_start,
        effective_date_range_end,
        
        sum(volume_actual_case) as total_volumeactualcase,
        sum(plan_qty) as total_plan_qty,
        avg(volume_actual_case) as average_price

    from
        int_sales_details
    group by
        companycode,
        companyname,
        statecode,
        statename,
        skucode,
        itemname,
        active_flag,
        promotion_desc,
        effective_date_range_start,
        effective_date_range_end
)

select * from final_aggregation