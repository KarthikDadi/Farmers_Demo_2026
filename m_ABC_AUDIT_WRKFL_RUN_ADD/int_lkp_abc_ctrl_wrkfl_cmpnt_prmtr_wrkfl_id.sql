{{ config(
    materialized='table',
    tags=["m_ABC_AUDIT_WRKFL_RUN_ADD"]
  ) }}

-- lkp_ABC_CTRL_WRKFL_CMPNT_PRMTR_WRKFL_ID
select
  wrkfl_id,
  wrkfl_nm
from {{ source('INFAD', 'ABC_CTRL_WRKFL_PRMTR') }}
where UPPER(WRKFL_NM) = UPPER({{ var('WORKFLOW_NAME') }})
QUALIFY ROW_NUMBER() OVER (PARTITION BY WRKFL_NM ORDER BY (SELECT NULL)) = 1

--End-DBShift