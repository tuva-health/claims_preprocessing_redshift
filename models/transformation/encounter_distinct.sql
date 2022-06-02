select distinct
	claim_type
    ,merge_claim_id
    ,patient_id
    ,encounter_type
    ,claim_start_date
    ,claim_end_date
    ,discharge_disposition_code
    ,facility_npi
from {{ ref('encounter_type_mapping')}}