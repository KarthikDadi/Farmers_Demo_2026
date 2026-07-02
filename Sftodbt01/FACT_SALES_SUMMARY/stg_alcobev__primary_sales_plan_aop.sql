-- models/staging/stg_alcobev__primary_sales_plan_aop.sql
{{ config(
    materialized='view',
    tags=['staging', 'primary_sales_plan_aop']
) }}

with source_data as (
    select * from {{ source('ALCOBEV', 'PRIMARY_SALES_PLAN_AOP') }}
),

renamed_casted as (
    select
        "STATECODE" as state_code,
        "SKUCODE" as sku_code,
        "PLAN_QTY" as plan_qty
    from source_data
)

select * from renamed_casted;