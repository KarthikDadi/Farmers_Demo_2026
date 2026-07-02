-- models/intermediate/sales/int_sales_details_joined.sql
{{
  config(
    materialized='ephemeral',
    tags=['intermediate', 'sales', 'FACT_SALES_SUMMARY']
  )
}}

with primary_sales_actuals as (

    select * from {{ ref('PRIMARY_SALES_ACTUALS') }}

),

companymaster as (

    select * from {{ ref('COMPANYMASTER') }}

),

geographymaster as (

    select * from {{ ref('GEOGRAPHYMASTER') }}

),

productmaster as (

    select * from {{ ref('PRODUCTMASTER') }}

),

primary_sales_plan_aop as (

    select * from {{ ref('PRIMARY_SALES_PLAN_AOP') }}

),

outletmaster as (

    select * from {{ ref('OUTLETMASTER') }}

),

activationmaster as (

    select * from {{ ref('ACTIVATIONMASTER') }}

),

int_recent_promotions as (

    select * from {{ ref('int_recent_promotions') }}

),

joined_and_transformed as (

    select
        -- Transformations for GROUP BY keys and aggregations
        iff(psa.companycode is null or psa.companycode = 'NULL', 'UNKNOWN', upper(trim(replace(psa.companycode, ' ', '')))) as companycode,
        iff(cm.companyname is null or cm.companyname = 'NULL', 'UNKNOWN', concat(left(trim(cm.companyname), 3), '***')) as companyname,
        iff(psa.statecode is null or psa.statecode = 'NULL', 'UNKNOWN', ltrim(rtrim(psa.statecode))) as statecode,
        iff(gm.statename is null or gm.statename = 'NULL', 'UNKNOWN', lower(trim(gm.statename))) as statename,
        iff(psa.skucode is null or psa.skucode = 'NULL', 'UNKNOWN', substring(ltrim(rtrim(psa.skucode)), 1, 10)) as skucode,
        iff(pm.itemname is null or pm.itemname = 'NULL', 'UNKNOWN', replace(trim(pm.itemname), ' ', '_')) as itemname,
        
        case
            when om.active_flag = 1 then 'YES'
            else 'NO'
        end as active_flag,

        iff(am.promotiondescription is null or am.promotiondescription = 'NULL', 'NO PROMOTION', concat('Promo: ', ltrim(rtrim(am.promotiondescription)))) as promotion_desc,
        iff(am.effectivefrom is null or am.effectivefrom = 'NULL', '1900-01-01', to_date(am.effectivefrom, 'yyyy-MM-dd')) as effective_date_range_start,
        iff(am.effectiveto is null or am.effectiveto = 'NULL', current_date, to_date(am.effectiveto, 'yyyy-MM-dd')) as effective_date_range_end,
        
        -- Measures to be aggregated
        coalesce(try_cast(trim(psa.volumeactualcase) as float), 0) as volume_actual_case,
        coalesce(try_cast(trim(psp.plan_qty) as float), 0) as plan_qty

    from
        primary_sales_actuals as psa
    left join
        companymaster as cm on psa.companycode = cm.companycode
    left join
        geographymaster as gm on psa.statecode = gm.statecode
    left join
        productmaster as pm on psa.skucode = pm.skucode
    left join
        primary_sales_plan_aop as psp on psa.statecode = psp.statecode and psa.skucode = psp.skucode
    left join
        outletmaster as om on psa.customercode = om.outlet_code
    left join
        activationmaster as am on psa.skucode = am.productlevelcode
    left join
        int_recent_promotions as amr
            on psa.skucode = amr.productlevelcode
            and am.effectivefrom = amr.max_effective_from
    where
        -- Apply filter early to reduce data volume before aggregation
        coalesce(try_cast(ltrim(rtrim(psa.volumeactualcase)) as float), 0) > 0
)

select * from joined_and_transformed