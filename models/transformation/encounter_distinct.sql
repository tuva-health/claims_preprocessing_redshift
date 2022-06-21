-------------------------------------------------------------------------------
-- Author       Thu Xuan Vu
-- Created      June 2022
-- Purpose      Create a list of unique claims based on the encounter type for downstream merging.
-- Notes        Row number over encounter type by patient important creates a consistent order by value.
-------------------------------------------------------------------------------
-- Modification History
--
-------------------------------------------------------------------------------

with unique_encounter as(
    select distinct
        claim_type
        ,merge_claim_id
        ,original_claim_id
        ,patient_id
        ,encounter_type
        ,claim_start_date
        ,claim_end_date
        ,discharge_disposition_code
        ,facility_npi
    from {{ ref('encounter_type_mapping')}}
    where encounter_type <> 'unmapped'
)
select
    claim_type
    ,merge_claim_id
    ,original_claim_id
    ,patient_id
    ,encounter_type
    ,claim_start_date
    ,claim_end_date
    ,discharge_disposition_code
    ,facility_npi
    ,row_number() over (partition by patient_id, encounter_type, claim_type order by claim_start_date, claim_end_date) as row_sequence
from unique_encounter


