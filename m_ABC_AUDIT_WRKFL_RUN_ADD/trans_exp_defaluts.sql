{{ config(materialized='table', tags=['m_ABC_AUDIT_WRKFL_RUN_ADD']) }}

-- trans_exp_defaluts.sql
with sq_fdr_lib_fdws_workflows_v as (
    select * from {{ ref('stg_sq_fdr_lib_fdws_workflows_v') }}
),

lkp_lkp_abc_ctrl_wrkfl_cmpnt_prmtr_wrkfl_id as (
    select * from {{ ref('int_lkp_abc_ctrl_wrkfl_cmpnt_prmtr_wrkfl_id') }}
),

trans_exp_defaluts as (
    select
        sq.workflow_run_id as workflow_run_id,
        lkp.wrkfl_id as o_workflow_id,
        sq.start_time as start_time,
        'Running' as status
    from sq_fdr_lib_fdws_workflows_v sq
    left join lkp_lkp_abc_ctrl_wrkfl_cmpnt_prmtr_wrkfl_id lkp
    on UPPER(lkp.wrkfl_nm) = UPPER({{ var('WORKFLOW_NAME') }})
)

select * from trans_exp_defaluts

--End-DBShift