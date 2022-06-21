-------------------------------------------------------------------------------
-- Author       Thu Xuan Vu
-- Created      June 2022
-- Purpose      
-- Notes        
-------------------------------------------------------------------------------
-- Modification History
--
-------------------------------------------------------------------------------

with condition_code as(
  select
    encounter_id
    ,claim_id
    ,patient_id
    ,claim_start_date as condition_date
    ,diagnosis_code_type as code_type
    ,code
    ,cast(replace(diagnosis_rank,'diagnosis_code_','') as int) diagnosis_rank
  from claims_preprocessing.medical_claim_stage
  unpivot(
    code for diagnosis_rank in (diagnosis_code_1
                                ,diagnosis_code_2
                                ,diagnosis_code_3
                                ,diagnosis_code_4
                                ,diagnosis_code_5
                                ,diagnosis_code_6
                                ,diagnosis_code_7
                                ,diagnosis_code_8
                                ,diagnosis_code_9
                                ,diagnosis_code_10
                                ,diagnosis_code_11
                                ,diagnosis_code_12
                                ,diagnosis_code_13
                                ,diagnosis_code_14
                                ,diagnosis_code_15
                                ,diagnosis_code_16
                                ,diagnosis_code_17
                                ,diagnosis_code_18
                                ,diagnosis_code_19
                                ,diagnosis_code_20
                                ,diagnosis_code_21
                                ,diagnosis_code_22
                                ,diagnosis_code_23
                                ,diagnosis_code_24
                                ,diagnosis_code_25)
            )pdx
)
, condition_poa as(
  select 
    claim_id
    ,present_on_admit
    ,cast(replace(diagnosis_rank,'diagnosis_poa_','') as int) as diagnosis_rank
  from claims_preprocessing.medical_claim_stage
  unpivot(
    present_on_admit for diagnosis_rank in (diagnosis_poa_1
                                            ,diagnosis_poa_2
                                            ,diagnosis_poa_3
                                            ,diagnosis_poa_4
                                            ,diagnosis_poa_5
                                            ,diagnosis_poa_6
                                            ,diagnosis_poa_7
                                            ,diagnosis_poa_8
                                            ,diagnosis_poa_9
                                            ,diagnosis_poa_10
                                            ,diagnosis_poa_11
                                            ,diagnosis_poa_12
                                            ,diagnosis_poa_13
                                            ,diagnosis_poa_14
                                            ,diagnosis_poa_15
                                            ,diagnosis_poa_16
                                            ,diagnosis_poa_17
                                            ,diagnosis_poa_18
                                            ,diagnosis_poa_19
                                            ,diagnosis_poa_20
                                            ,diagnosis_poa_21
                                            ,diagnosis_poa_22
                                            ,diagnosis_poa_23
                                            ,diagnosis_poa_24
                                            ,diagnosis_poa_25)
            )ppoa
)
select distinct
  c.encounter_id
  ,c.patient_id
  ,c.condition_date
  ,cast('claim' as varchar) as condition_type
  ,c.code_type
  ,c.code
  ,cast(null as varchar) as description
  ,c.diagnosis_rank
  ,p.present_on_admit
  ,cast('cclf' as varchar) as data_source
from condition_code c
left join condition_poa p
  ON c.claim_id = p.claim_id
  AND c.diagnosis_rank = p.diagnosis_rank
