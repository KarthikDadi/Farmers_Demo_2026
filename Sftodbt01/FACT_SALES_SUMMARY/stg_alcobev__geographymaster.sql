-- models/staging/stg_alcobev__geographymaster.sql
{{ config(
    materialized='view',
    tags=['staging', 'geographymaster']
) }}

with source_data as (
    select * from {{ source('ALCOBEV', 'GEOGRAPHYMASTER') }}
),

renamed_casted as (
    select
        "STATECODE" as state_code,
        "STATENAME" as state_name
    from source_data
)

select * from renamed_casted;