-------------------------------------------------------------------------------
-- Author       Thu Xuan Vu
-- Created      June 2022
-- Purpose      For merged claims only, determine encounter level data elements.
-- Notes        
-------------------------------------------------------------------------------
-- Modification History
--
-------------------------------------------------------------------------------


with encounter_dates as(
  select 
    mc.group_claim_id
      ,min(d.claim_start_date) as encounter_start_date
      ,max(d.claim_end_date) as encounter_end_date
      ,sum(paid_amount) as paid_amount
      ,sum(charge_amount) as charge_amount
  from {{ ref('inst_merge_crosswalk')}} mc
  inner join {{ ref('encounter_type_mapping')}} d
    on mc.merge_claim_id = d.merge_claim_id
  group by group_claim_id
  )
  

  select distinct
    d.group_claim_id as encounter_id
    ,m.patient_id
    ,m.encounter_type
    ,d.encounter_start_date
    ,d.encounter_end_date
    ,d.paid_amount
    ,d.charge_amount
  from encounter_dates d
  inner join {{ ref('inst_merge_crosswalk')}}  c
  	on d.group_claim_id = c.group_claim_id
  inner join {{ ref('encounter_distinct')}} m
  	on c.merge_claim_id = m.merge_claim_id
