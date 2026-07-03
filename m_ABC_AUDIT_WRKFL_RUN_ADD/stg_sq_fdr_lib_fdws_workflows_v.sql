{{
  config(
    materialized = "table",
    alias = "FDR_LIB_FDWS_WORKFLOWS_V"
  )
}}

SELECT
    W.WORKFLOW_RUN_ID,
    W.START_TIME,
    W.END_TIME,
    W.STATUS
FROM
    {{ source('INFAD', 'FDWS_WORKFLOWS_V') }} AS W
WHERE
    W.WORKFLOW_NAME = {{ var('WORKFLOW_NAME') }}
    AND W.SUBJECT_AREA = {{ var('FOLDER_NAME') }}
--End-DB-Content
-- Staging model for lkp_FDR_LIB_ABC_CTRL_WRKFL_CMPNT_PRMTR_WRKFL_ID
-- The 'lkp_FDR_LIB_ABC_CTRL_WRKFL_CMPNT_PRMTR_WRKFL_ID' lookup transformation is not used in the provided mapping, so a model is not generated for it.
--End-DB-Content
-- Staging model for FDR_LIB_ABC_AUDIT_WRKFL_RUN
-- The 'FDR_LIB_ABC_AUDIT_WRKFL_RUN' target definition is not a source, so a model is not generated for it.
--End-DB-Content
-- Staging model for exp_DEFALUTS
-- The 'exp_DEFALUTS' expression transformation is not a source, so a model is not generated for it.
--End-DB-Content
{{ config(
    materialized = 'view',
    tags = ['m_ABC_AUDIT_WRKFL_RUN_ADD']
) }}

with
sq_fdr_lib_fdws_workflows_v as (
    select
        w.workflow_run_id as WORKFLOW_RUN_ID,
        w.start_time as START_TIME,
        w.end_time as END_TIME,
        w.status as STATUS
    from
        {{ source('INFAD', 'FDWS_WORKFLOWS_V') }} as w
    where
        w.workflow_name = {{ var('WORKFLOW_NAME') }}
        and w.subject_area = {{ var('FOLDER_NAME') }}
)

select
    WORKFLOW_RUN_ID,
    START_TIME,
    END_TIME,
    STATUS
from
    sq_fdr_lib_fdws_workflows_v
--End-DBShift