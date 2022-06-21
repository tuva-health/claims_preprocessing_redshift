-------------------------------------------------------------------------------
-- Author       Thu Xuan Vu
-- Created      June 2022
-- Purpose      
-- Notes        
-------------------------------------------------------------------------------
-- Modification History
--
-------------------------------------------------------------------------------

with prof_inst_encounter_crosswalk as(
  select 
      f.encounter_id
      ,f.patient_id
      ,f.encounter_type
      ,f.encounter_start_date
      ,f.encounter_end_date
      ,f.facility_npi
      ,d.merge_claim_id
      ,d.original_claim_id
      ,d.claim_start_date
      ,d.claim_end_date
      ,d.encounter_type
      ,case
          when f.encounter_type = 'acute inpatient' and d.encounter_type = 'acute inpatient'
              then 1
          when f.encounter_type = 'hospice ' and d.encounter_type = 'hospice'
              then 1
          when f.encounter_type = 'home health' and d.encounter_type = 'home health'
              then 1
          when f.encounter_type = 'skilled nursing facility' and d.encounter_type = 'skilled nursing facility'
              then 1
          when f.encounter_type = 'ambulatory surgical center' and d.encounter_type = 'ambulatory surgical center'
              then 1
          when f.encounter_type = 'dialysis center' and d.encounter_type = 'dialysis center'
              then 1
          when f.encounter_type = 'mental health center' and d.encounter_type = 'mental health center'
              then 1
          when f.encounter_type = 'emergency department' and d.encounter_type = 'emergency department'
              then 1
          when f.encounter_type = 'outpatient rehabilitation' and d.encounter_type = 'outpatient rehabilitation'
              then 1
                  else 0
       end as link_flag
  from {{ ref('inst_encounter_final')}} f
  inner join {{ ref('encounter_distinct')}} d
      on d.patient_id = f.patient_id
      and d.claim_start_date >= f.encounter_start_date
      and d.claim_start_date <= f.encounter_end_date
  where d.claim_type in ('P','DME')

  )
, ambigous_match as(
  select 
  	merge_claim_id
  from prof_inst_encounter_crosswalk
  where link_flag = 1
  group by merge_claim_id
  having count(*) > 1
)

select 
	encounter_id
    ,c.merge_claim_id
    ,c.original_claim_id
    ,c.patient_id
from prof_inst_encounter_crosswalk c
left join ambigous_match a
	on c.merge_claim_id = a.merge_claim_id
where a.merge_claim_id is null
and c.link_flag = 1
