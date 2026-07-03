-- models/staging/stg_alcobev__activationmaster.sql
{{ config(
    materialized='view',
    tags=['staging', 'activationmaster']
) }}

with source_data as (
    select * from {{ source('ALCOBEV', 'ACTIVATIONMASTER') }}
),

renamed_casted as (
    select
        "PRODUCTLEVELCODE" as product_level_code,
        "PROMOTIONDESCRIPTION" as promotion_description,
        "EFFECTIVEFROM" as effective_from,
        "EFFECTIVETO" as effective_to
    from source_data
)

select * from renamed_casted;