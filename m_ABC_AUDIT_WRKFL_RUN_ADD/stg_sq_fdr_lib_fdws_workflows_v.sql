-- stg_sq_fdr_lib_fdws_workflows_v.sql
{{ config(materialized='view', tags=["m_ABC_AUDIT_WRKFL_RUN_ADD"]) }}

with source_data as (
    select
        W.WORKFLOW_RUN_ID,
        W.START_TIME,
        W.END_TIME,
        W.STATUS
    from {{ source('INFAD', 'FDWS_WORKFLOWS_V') }} as W
    where W.WORKFLOW_NAME = {{ var('WORKFLOW_NAME') }}
      and W.SUBJECT_AREA = {{ var('FOLDER_NAME') }}
)

select
    WORKFLOW_RUN_ID,
    START_TIME,
    END_TIME,
    STATUS
from source_data

--End-DBShift