-- models/intermediate/sales/int_recent_promotions.sql
{{
  config(
    materialized='view',
    tags=['intermediate', 'sales', 'FACT_SALES_SUMMARY']
  )
}}

with source_activation_master as (

    select * from {{ ref('ACTIVATIONMASTER') }}

),

most_recent_promotion as (

    select
        productlevelcode,
        max(effectivefrom) as max_effective_from
    from
        source_activation_master
    group by
        productlevelcode
)

select * from most_recent_promotion