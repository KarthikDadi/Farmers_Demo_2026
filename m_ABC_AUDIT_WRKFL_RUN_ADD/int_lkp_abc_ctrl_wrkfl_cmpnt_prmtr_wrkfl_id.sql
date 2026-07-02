{{ config(
    materialized='table',
    tags=["m_ABC_AUDIT_WRKFL_RUN_ADD"]
  ) }}

-- lkp_ABC_CTRL_WRKFL_CMPNT_PRMTR_WRKFL_ID
select
  WRKFL_ID,
  WRKFL_NM
from {{ source('INFAD', 'ABC_CTRL_WRKFL_PRMTR') }}
WHERE WRKFL_NM = '{{ var('WORKFLOW_NAME') }}'
QUALIFY ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) = 1

--End-DBShift