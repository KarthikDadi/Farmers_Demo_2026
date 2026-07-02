{{ config(materialized='table', tags=["m_ABC_AUDIT_WRKFL_RUN_ADD"]) }}

with stg_sq_fdr_lib_fdws_workflows_v as (
    select * from {{ ref('stg_sq_fdr_lib_fdws_workflows_v') }}
),

int_lkp_abc_ctrl_wrkfl_cmpnt_prmtr_wrkfl_id as (
    select * from {{ ref('int_lkp_abc_ctrl_wrkfl_cmpnt_prmtr_wrkfl_id') }}
),

lkp_result as (
    select
        wrkfl_id
    from int_lkp_abc_ctrl_wrkfl_cmpnt_prmtr_wrkfl_id
    where i_workflow_name = '{{ var('WORKFLOW_NAME') }}'
),

trans_exp_defaluts as (
    select
        stg_sq_fdr_lib_fdws_workflows_v.workflow_run_id as workflow_run_id,
        lkp_result.wrkfl_id as o_workflow_id,
        stg_sq_fdr_lib_fdws_workflows_v.start_time as start_time,
        'Running' as status
    from stg_sq_fdr_lib_fdws_workflows_v
    cross join lkp_result
)

select 
    workflow_run_id,
    o_workflow_id,
    start_time,
    status
from trans_exp_defaluts

--End-DBShift