select distinct
    claim_type
  	,merge_claim_id
    ,original_claim_id
    ,patient_id
    ,encounter_type
    ,claim_start_date
    ,claim_end_Date
    ,discharge_disposition_code
    ,facility_npi
  from {{ ref('encounter_type_stage')}}