/** Need to find the start of linked claim pairs in order to provide anchor in recursive CTE.
 	 The start a claim pair is found when claim_id_a does not exist in the previous paid.
     	The link is broken and indicates the start of a new link.  **/
 
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
  