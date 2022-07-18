-------------------------------------------------------------------------------
-- Author       Thu Xuan Vu
-- Created      June 2022
-- Purpose      Find the start of a claim pair set to use as the anchor in a recrusive CTE and add the anchor back to the list of claim pairs.
-- Notes        The output of inst_merge_stage is a list of claims that are to be paired:  Claim A to B, Claim B to C, Claim C to D, Claim S to T.
--              To group pairs under one umbrella, a recurisve CTE is used to link Claim A down to Claim D.  An anchor tells the recursion when a pair set starts.
--              Claim A and Claim S will be pulled out as the anchors and then union'd with the original data set.
-------------------------------------------------------------------------------
-- Modification History
--
-------------------------------------------------------------------------------
 
with master_claim_id as(
    select 
        lag(claim_id_b,1) over (partition by patient_id, encounter_type order by row_sequence) as previous_claim
        ,patient_id
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
)

select 
    cast(patient_id as varchar) as patient_id
    ,cast('anchor' as varchar) as merge_criteria
    ,cast(claim_id_a as varchar) as claim_id_a
    ,cast(NULL as varchar) as claim_id_b
    ,cast(encounter_type as varchar) as encounter_type
    ,cast(NULL as date) as previous_claim_start_date
    ,cast(NULL as date) as previous_claim_end_date
    ,cast(previous_claim_start_date as date) as claim_start_date
    ,cast(previous_claim_end_date as date) as claim_end_date
    ,cast(previous_facility_npi as varchar) as previous_facility_npi
    ,cast(facility_npi as varchar) as facility_npi
    ,cast(previous_discharge_disposition_code as varchar) as previous_discharge_disposition_code
    ,cast(discharge_disposition_code as varchar) as discharge_disposition_code
from master_claim_id
where isnull(previous_claim, 'start') <> claim_id_a

union all 

select 
	cast(patient_id as varchar) as patient_id
    ,cast(merge_criteria as varchar) as merge_criteria
    ,cast(claim_id_a as varchar) as claim_id_a
    ,cast(claim_id_b as varchar) as claim_id_b
    ,cast(encounter_type as varchar) as encounter_type
    ,cast(previous_claim_start_date as date) as previous_claim_start_date
    ,cast(previous_claim_end_date as date) as previous_claim_end_date
    ,cast(claim_start_date as date) as claim_start_date
    ,cast(claim_end_date as date) as claim_end_date
    ,cast(previous_facility_npi as varchar) as previous_facility_npi
    ,cast(facility_npi as varchar) as facility_npi
    ,cast(previous_discharge_disposition_code as varchar) as previous_discharge_disposition_code
    ,cast(discharge_disposition_code as varchar) as discharge_disposition_code
 from {{ ref('inst_merge_stage')}}
  