-------------------------------------------------------------------------------
-- Author       Thu Xuan Vu
-- Created      June 2022
-- Purpose      Find the start of a claim pair set to use as anchor in recrusive CTE and add it back to the list of claim pairs.
-------------------------------------------------------------------------------
-- Modification History
--
-------------------------------------------------------------------------------
 
 with master_claim_id as(
 select 
	lag(claim_id_b,1) over (partition by patient_id, encounter_type order by row_sequence) as previous_claim
 ,* 
 from {{ ref('inst_merge_stage')}}

)

select 
	patient_id
    ,'anchor' as merge_criteria
    ,claim_id_a
    ,NULL as claim_id_b
    ,encounter_type
    ,NULL as previous_claim_start_date
    ,NULL as previous_claim_end_date
    ,previous_claim_start_date as claim_start_date
    ,previous_claim_end_date as claim_end_date
    ,previous_facility_npi
    ,facility_npi
    ,previous_discharge_disposition_code
    ,discharge_disposition_code
from master_claim_id
where isnull(previous_claim, 'start') <> claim_id_a

union all 

select 
	patient_id
    ,merge_criteria
    ,claim_id_a
    ,claim_id_b
    ,encounter_type
    ,previous_claim_start_date
    ,previous_claim_end_date
    ,claim_start_date
    ,claim_end_date
    ,previous_facility_npi
    ,facility_npi
    ,previous_discharge_disposition_code
    ,discharge_disposition_code
 from {{ ref('inst_merge_stage')}}
  