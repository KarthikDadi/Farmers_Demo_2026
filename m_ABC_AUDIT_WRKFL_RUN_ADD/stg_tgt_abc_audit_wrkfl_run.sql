{{ config(
    materialized='incremental',
    tags=['m_ABC_AUDIT_WRKFL_RUN_ADD']
) }}

-- target: ABC_AUDIT_WRKFL_RUN
with exp_defaluts as (
    select * from {{ ref('trans_exp_defaluts') }}
),

stg_tgt_abc_audit_wrkfl_run as (
    select
        exp_defaluts.workflow_run_id as wrkfl_run_id,
        exp_defaluts.o_workflow_id as wrkfl_id,
        exp_defaluts.start_time as wrkfl_strt_tmsp,
        exp_defaluts.status as wrkfl_stat,
        cast(null as timestamp_ntz) as wrkfl_end_tmsp
    from exp_defaluts
)

select * from stg_tgt_abc_audit_wrkfl_run

--End-DBShift