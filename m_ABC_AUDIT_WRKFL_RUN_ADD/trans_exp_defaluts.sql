-- trans_exp_defaluts.sql
{{ config(materialized='view', tags=["m_ABC_AUDIT_WRKFL_RUN_ADD"]) }}

with stg_sq_fdr_lib_fdws_workflows_v as (
    select * from {{ ref('stg_sq_fdr_lib_fdws_workflows_v') }}
),
int_lkp_abc_ctrl_wrkfl_cmpnt_prmtr_wrkfl_id as (
    select * from {{ ref('int_lkp_abc_ctrl_wrkfl_cmpnt_prmtr_wrkfl_id') }}
),
trans_exp_defaluts as (
    select 
        stg_sq_fdr_lib_fdws_workflows_v.WORKFLOW_RUN_ID,
        int_lkp_abc_ctrl_wrkfl_cmpnt_prmtr_wrkfl_id.WRKFL_ID as o_WORKFLOW_ID,
        stg_sq_fdr_lib_fdws_workflows_v.START_TIME,
        'Running' as STATUS
    from stg_sq_fdr_lib_fdws_workflows_v
    left join int_lkp_abc_ctrl_wrkfl_cmpnt_prmtr_wrkfl_id on stg_sq_fdr_lib_fdws_workflows_v.WORKFLOW_NAME = int_lkp_abc_ctrl_wrkfl_cmpnt_prmtr_wrkfl_id.WRKFL_NM
)
select * from trans_exp_defaluts
--End-DBShift