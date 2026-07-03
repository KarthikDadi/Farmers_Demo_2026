{{ config(materialized='view', tags=["m_ABC_AUDIT_WRKFL_RUN_ADD"]) }}

-- SQ_FDR_LIB_FDWS_WORKFLOWS_V
with source_data as (
    SELECT W.WORKFLOW_RUN_ID, W.START_TIME, W.END_TIME, W.STATUS 
FROM
{{ source('INFAD', 'FDWS_WORKFLOWS_V') }} W
WHERE W.WORKFLOW_NAME = {{ var('WORKFLOW_NAME') }}
AND W.SUBJECT_AREA={{ var('FOLDER_NAME') }}
)

select * from source_data

--End-DBShift