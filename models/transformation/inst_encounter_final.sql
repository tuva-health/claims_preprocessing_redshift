select
   encounter_id
   ,patient_id
   ,encounter_type
   ,encounter_start_date
   ,encounter_end_date
   ,admit_source_code
   ,admit_type_code
   ,discharge_disposition_code
   ,physician_npi
   ,facility_npi
   ,ms_drg
   ,paid_amount
   ,charge_amount
from {{ ref('inst_encounter_merge')}}

union all 

select
   encounter_id
   ,patient_id
   ,encounter_type
   ,encounter_start_date
   ,encounter_end_date
   ,admit_source_code
   ,admit_type_code
   ,discharge_disposition_code
   ,physician_npi
   ,facility_npi
   ,ms_drg
   ,paid_amount
   ,charge_amount
from {{ ref('inst_encounter_nonmerge')}}