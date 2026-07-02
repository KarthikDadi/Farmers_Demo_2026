-- stg_sq_fdr_lib_fdws_workflows_v.sql

{{
  config(
    materialized='view',
    tags=['m_ABC_AUDIT_WRKFL_RUN_ADD']
  )
}}

with source_fdws_workflows_v as (
  select
    workflow_run_id,
    start_time,
    end_time,
    status,
    workflow_name,
    subject_area
  from {{ source('INFAD', 'FDWS_WORKFLOWS_V') }}
),

sq_fdr_lib_fdws_workflows_v as (
  select
    w.workflow_run_id,
    w.start_time,
    w.end_time,
    w.status
  from
    source_fdws_workflows_v w
  where
    w.workflow_name = '{{ var('WORKFLOW_NAME') }}'
    and w.subject_area = '{{ var('FOLDER_NAME') }}'
)

select
  workflow_run_id,
  start_time,
  end_time,
  status
from sq_fdr_lib_fdws_workflows_v

--End-DBShift