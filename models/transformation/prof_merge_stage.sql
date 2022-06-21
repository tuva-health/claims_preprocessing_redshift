-------------------------------------------------------------------------------
-- Author       Thu Xuan Vu
-- Created      June 2022
-- Purpose      Pair institutional claims that are to be merged.  Only inpatient/continuous stay encounter type are considered.
-- Notes        Claims are merged if:
--                - dates overlap and facility is the same
--                - date is off by no more than 1 day, facility is the same, and previous claim has a discharge status of 30 - still a patient
-------------------------------------------------------------------------------
-- Modification History
--
-------------------------------------------------------------------------------

with previous_claim as(
  select distinct 
    m.patient_id
    ,lag(m.merge_claim_id) over (partition by m.patient_id, encounter_type order by row_sequence) as previous_claim_id
    ,m.merge_claim_id
    ,encounter_type
    ,lag(claim_start_date) over (partition by m.patient_id, encounter_type order by row_sequence) as previous_claim_start_date
    ,lag(claim_end_date) over (partition by m.patient_id, encounter_type order by row_sequence) as previous_claim_end_date
    ,claim_start_date
    ,claim_end_date
    ,row_sequence
  from {{ ref('encounter_distinct')}} m
  left join {{ ref('prof_inst_encounter_crosswalk')}} c
  	on m.merge_claim_id = c.merge_claim_id
  where claim_type in ('P','DME')
  and c.merge_claim_id is null
  and encounter_type in ('inpatient psychatiatric','inpatient rehabilitation','acute inpatient','skilled nursing facility','home health','hospice')
  order by patient_id, claim_start_date
)
,merge_criteria as(
  select 
  	patient_id
    ,previous_claim_id
    ,merge_claim_id
    ,encounter_type
    ,previous_claim_start_date
    ,previous_claim_end_date
    ,claim_start_date
    ,claim_end_date
    ,row_sequence
	,case
    	when previous_claim_start_date = claim_start_date
            then 'strict overlap'
  	end as merge_criteria
  from previous_claim
)

select 
	patient_id
    ,merge_criteria
    ,previous_claim_id as claim_id_a
    ,merge_claim_id as claim_id_b
    ,encounter_type
    ,previous_claim_start_date
    ,previous_claim_end_date
    ,claim_start_date
    ,claim_end_date
    ,row_sequence
from merge_criteria
where merge_criteria is not null