with population as(
  select distinct
  	merge_claim_id
  	,original_claim_id
  	,patient_id
  	,encounter_type
  	,claim_start_date
 	,claim_end_date
  	,facility_npi
  from {{ ref('encounter_type')}} e
  where claim_type ='I'
)
  
, strict_overlap as(  
  select distinct 
  	e.merge_claim_id as merge_claim_id_a
    ,e.original_claim_id as original_claim_id_a
    ,e.patient_id as patient_id_a
    ,e.encounter_type as encounter_type_a
    ,e.claim_start_date as claim_start_date_a
    ,e.claim_end_date as claim_end_date_a
  	,e2.merge_claim_id as merge_claim_id_b
    ,e2.original_claim_id as original_claim_id_b
    ,e2.encounter_type as encounter_type_b
    ,e2.claim_start_date as claim_start_date_b
    ,e2.claim_end_date as claim_end_date_b
  from population e
  inner join population e2
    on e.patient_id = e2.patient_id
    and e.encounter_type = e2.encounter_type
    and e.merge_claim_id <> e2.merge_claim_id
  	and e.facility_npi = e2.facility_npi
  where 1=1
  and e2.claim_start_date >= e.claim_start_date
  and e2.claim_start_date <= e.claim_end_date
  and e2.claim_end_date >= e.claim_start_date
  and e2.claim_end_date <= e.claim_end_date
)
, start_overlap as(
    select
  	e.merge_claim_id as merge_claim_id_a
    ,e.original_claim_id as original_claim_id_a
    ,e.patient_id as patient_id_a
    ,e.encounter_type as encounter_type_a
    ,e.claim_start_date as claim_start_date_a
    ,e.claim_end_date as claim_end_date_a
  	,e2.merge_claim_id as merge_claim_id_b
    ,e2.original_claim_id as original_claim_id_b
    ,e2.encounter_type as encounter_type_b
    ,e2.claim_start_date as claim_start_date_b
    ,e2.claim_end_date as claim_end_date_b
  from population e
  inner join population e2
    on e.patient_id = e2.patient_id
    and e.encounter_type = e2.encounter_type
    and e.merge_claim_id <> e2.merge_claim_id
  	and e.facility_npi = e2.facility_npi
  where 1=1
  and e2.claim_start_date >= e.claim_start_date
  and e2.claim_start_date <= e.claim_end_date
  )
, end_overlap as(
    select
  	e.merge_claim_id as merge_claim_id_a
    ,e.original_claim_id as original_claim_id_a
    ,e.patient_id as patient_id_a
    ,e.encounter_type as encounter_type_a
    ,e.claim_start_date as claim_start_date_a
    ,e.claim_end_date as claim_end_date_a
  	,e2.merge_claim_id as merge_claim_id_b
    ,e2.original_claim_id as original_claim_id_b
    ,e2.encounter_type as encounter_type_b
    ,e2.claim_start_date as claim_start_date_b
    ,e2.claim_end_date as claim_end_date_b
  from population e
  inner join population e2
    on e.patient_id = e2.patient_id
    and e.encounter_type = e2.encounter_type
    and e.merge_claim_id <> e2.merge_claim_id
  	and e.facility_npi = e2.facility_npi
  where 1=1
  and e2.claim_end_date >= e.claim_start_date
  and e2.claim_end_date <= e.claim_end_date
   )
   
   
   select 
   merge_claim_id_a
   ,merge_claim_id_b
   ,original_claim_id_a
   ,original_claim_id_b
   ,'1' as link_flag
   from strict_overlap
   union all
   select
   merge_claim_id_a
   ,merge_claim_id_b
   ,original_claim_id_a
   ,original_claim_id_b
    ,'1' as link_flag
   from start_overlap
   union all 
   select
   merge_claim_id_a
   ,merge_claim_id_b
   ,original_claim_id_a
   ,original_claim_id_b
    ,'1' as link_flag
   from end_overlap
   