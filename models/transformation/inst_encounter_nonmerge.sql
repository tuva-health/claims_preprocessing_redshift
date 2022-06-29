-------------------------------------------------------------------------------
-- Author       Thu Xuan Vu
-- Created      June 2022
-- Purpose      For merged claims only, determine encounter level data elements.
-- Notes        Query is the same as inst_encounter_merge except it omits merged claims to create an encounter for non merged institutional claims.
-------------------------------------------------------------------------------
-- Modification History
--
-------------------------------------------------------------------------------

with encounter_dates as(
  select
      d.merge_claim_id as group_claim_id
      ,min(d.claim_start_date) as encounter_start_date
      ,max(d.claim_end_date) as encounter_end_date
      ,sum(paid_amount) as paid_amount
      ,sum(charge_amount) as charge_amount
  from {{ ref('encounter_type_mapping')}} d
  left join {{ ref('inst_merge_crosswalk')}} c
      on d.merge_claim_id = c.merge_claim_id
  where d.claim_type = 'I'
  and c.merge_claim_id is null
  group by d.merge_claim_id

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
inner join {{ ref('encounter_distinct')}} m
    on d.group_claim_id = m.merge_claim_id
