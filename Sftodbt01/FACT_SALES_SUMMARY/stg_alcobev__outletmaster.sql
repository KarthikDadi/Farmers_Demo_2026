-- models/staging/stg_alcobev__outletmaster.sql
{{ config(
    materialized='view',
    tags=['staging', 'outletmaster']
) }}

with source_data as (
    select * from {{ source('ALCOBEV', 'OUTLETMASTER') }}
),

renamed_casted as (
    select
        "OUTLET_CODE" as outlet_code,
        "ACTIVE_FLAG" as active_flag
    from source_data
)

select * from renamed_casted;