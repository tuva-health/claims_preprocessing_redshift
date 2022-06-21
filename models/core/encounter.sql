-------------------------------------------------------------------------------
-- Author       Thu Xuan Vu
-- Created      June 2022
-- Purpose      
-- Notes        
-------------------------------------------------------------------------------
-- Modification History
--
-------------------------------------------------------------------------------

with encounter_combined as(
  select 
    encounter_id
    ,min(claim_start_date) as encounter_start_date
    ,max(claim_end_date) as encounter_end_date
    ,sum(paid_amount) as paid_amount
    ,sum(charge_amount) as charge_amount
  from {{ ref('medical_claim_stage')}} mc
  group by
      encounter_id
)
, encounter_stage as(
  select
    mc.encounter_id
    ,mc.patient_id
    ,mc.encounter_type
    ,mc.admit_source_code
    ,mc.admit_source_description
    ,mc.admit_type_code
    ,mc.admit_type_description
    ,mc.discharge_disposition_code
    ,mc.discharge_disposition_description
    ,mc.rendering_npi as physician_npi
    ,cast(null as varchar) as location
    ,mc.facility_npi
    ,mc.ms_drg
    ,cast('cclf' as varchar) as data_source
    ,row_number() over (partition by mc.encounter_id order by mc.claim_line_number, mc.claim_start_date) as row_sequence_first
    ,row_number() over (partition by mc.encounter_id order by mc.claim_line_number, mc.claim_end_date) as row_sequence_last
  from {{ ref('medical_claim_stage')}} mc
)

select distinct
    s.encounter_id
    ,s.patient_id
    ,s.encounter_type
    ,c.encounter_start_date
    ,c.encounter_end_date
    ,first_value(s.admit_source_code) over(partition by s.encounter_id order by s.row_sequence_first rows between unbounded preceding and unbounded following) as admit_source_code
    ,first_value(s.admit_source_description) over(partition by s.encounter_id order by s.row_sequence_first rows between unbounded preceding and unbounded following) as admit_source_description
    ,first_value(s.admit_type_code) over(partition by s.encounter_id order by s.row_sequence_first rows between unbounded preceding and unbounded following) as admit_type_code
    ,first_value(s.admit_type_description) over(partition by s.encounter_id order by s.row_sequence_first rows between unbounded preceding and unbounded following) as admit_type_description
    ,last_value(s.discharge_disposition_code) over(partition by s.encounter_id order by s.row_sequence_last rows between unbounded preceding and unbounded following) as discharge_disposition_code
    ,last_value(s.discharge_disposition_description) over(partition by s.encounter_id order by s.row_sequence_last rows between unbounded preceding and unbounded following) as discharge_disposition_description
    ,first_value(s.physician_npi) over(partition by s.encounter_id order by s.row_sequence_first rows between unbounded preceding and unbounded following) as physician_npi
    ,s.location
    ,first_value(s.facility_npi) over(partition by s.encounter_id order by s.row_sequence_first rows between unbounded preceding and unbounded following) as facility_npi
    ,first_value(s.ms_drg) over(partition by s.encounter_id order by s.row_sequence_first rows between unbounded preceding and unbounded following) as ms_drg
    ,c.paid_amount
    ,c.charge_amount
    ,s.data_source
from encounter_stage s
inner join encounter_combined c
	on s.encounter_id = c.encounter_id