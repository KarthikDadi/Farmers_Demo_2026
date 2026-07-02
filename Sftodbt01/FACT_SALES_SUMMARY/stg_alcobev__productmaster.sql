-- models/staging/stg_alcobev__productmaster.sql
{{ config(
    materialized='view',
    tags=['staging', 'productmaster']
) }}

with source_data as (
    select * from {{ source('ALCOBEV', 'PRODUCTMASTER') }}
),

renamed_casted as (
    select
        "SKUCODE" as sku_code,
        "ITEMNAME" as item_name
    from source_data
)

select * from renamed_casted;