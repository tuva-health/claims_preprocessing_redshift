-------------------------------------------------------------------------------
-- Author       Thu Xuan Vu
-- Created      June 2022
-- Purpose      List of patients and demographics
-- Notes        Need row number to select most recent demographic information for a patient.
-------------------------------------------------------------------------------
-- Modification History
--
-------------------------------------------------------------------------------

with patient_stage as(
    select
        patient_id
        ,gender
        ,birth_date
        ,race
        ,zip_code
        ,state
        ,deceased_flag
        ,death_date
        ,row_number() over (partition by patient_id order by year DESC) as row_sequence
    from {{ var('eligibility')}}
)

select
    patient_id
    ,gender
    ,birth_date
    ,race
    ,zip_code
    ,state
    ,deceased_flag
    ,death_date
from patient_stage
where row_sequence = 1