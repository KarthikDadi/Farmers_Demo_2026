-- models/staging/stg_alcobev__companymaster.sql
{{ config(
    materialized='view',
    tags=['staging', 'companymaster']
) }}

with source_data as (
    select * from {{ source('ALCOBEV', 'COMPANYMASTER') }}
),

renamed_casted as (
    select
        "COMPANYCODE" as company_code,
        "COMPANYNAME" as company_name
    from source_data
)

select * from renamed_casted;