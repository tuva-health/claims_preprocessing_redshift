-------------------------------------------------------------------------------
-- Author       Thu Xuan Vu
-- Created      June 2022
-- Purpose      A copy of the claims input layer with merged claims and encounters.  Will power the core layer
-- Notes        Created this table to allow for validation and as an easier way to pass through claim fields from input layer to output layer.
-------------------------------------------------------------------------------
-- Modification History
--
-------------------------------------------------------------------------------
select 
  c.merge_claim_id as claim_id
  ,m.claim_line_number
  ,m.claim_type
  ,c.encounter_id
  ,e.encounter_type
  ,m.patient_id
  ,m.claim_start_date
  ,m.claim_end_date
  ,m.claim_line_start_date
  ,m.claim_line_end_date
  ,m.bill_type_code
  ,null bill_type_description
  ,m.place_of_service_code
  ,pos.description as place_of_service_description
  ,m.revenue_center_code
  ,rev.description as revenue_center_description
  ,m.admit_type_code
  ,at.description as admit_type_description
  ,m.admit_source_code
  ,asrc.description as admit_source_description
  ,m.service_unit_quantity
  ,m.paid_date
  ,m.paid_amount
  ,m.hcpcs_code
  ,m.hcpcs_modifier_1
  ,m.hcpcs_modifier_2
  ,m.hcpcs_modifier_3
  ,m.hcpcs_modifier_4
  ,m.hcpcs_modifier_5
  ,m.rendering_npi
  ,m.billing_npi
  ,m.facility_npi
  ,m.ms_drg
  ,m.discharge_disposition_code
  ,dd.description as discharge_disposition_description
  ,m.charge_amount
  ,m.diagnosis_code_1
  ,m.diagnosis_code_2
  ,m.diagnosis_code_3
  ,m.diagnosis_code_4
  ,m.diagnosis_code_5
  ,m.diagnosis_code_6
  ,m.diagnosis_code_7
  ,m.diagnosis_code_8
  ,m.diagnosis_code_9
  ,m.diagnosis_code_10
  ,m.diagnosis_code_11
  ,m.diagnosis_code_12
  ,m.diagnosis_code_13
  ,m.diagnosis_code_14
  ,m.diagnosis_code_15
  ,m.diagnosis_code_16
  ,m.diagnosis_code_17
  ,m.diagnosis_code_18
  ,m.diagnosis_code_19
  ,m.diagnosis_code_20
  ,m.diagnosis_code_21
  ,m.diagnosis_code_22
  ,m.diagnosis_code_23
  ,m.diagnosis_code_24
  ,m.diagnosis_code_25
  ,m.diagnosis_poa_1
  ,m.diagnosis_poa_2
  ,m.diagnosis_poa_3
  ,m.diagnosis_poa_4
  ,m.diagnosis_poa_5
  ,m.diagnosis_poa_6
  ,m.diagnosis_poa_7
  ,m.diagnosis_poa_8
  ,m.diagnosis_poa_9
  ,m.diagnosis_poa_10
  ,m.diagnosis_poa_11
  ,m.diagnosis_poa_12
  ,m.diagnosis_poa_13
  ,m.diagnosis_poa_14
  ,m.diagnosis_poa_15
  ,m.diagnosis_poa_16
  ,m.diagnosis_poa_17
  ,m.diagnosis_poa_18
  ,m.diagnosis_poa_19
  ,m.diagnosis_poa_20
  ,m.diagnosis_poa_21
  ,m.diagnosis_poa_22
  ,m.diagnosis_poa_23
  ,m.diagnosis_poa_24
  ,m.diagnosis_poa_25
  ,m.diagnosis_code_type
  ,m.procedure_code_type
  ,m.procedure_code_1
  ,m.procedure_code_2
  ,m.procedure_code_3
  ,m.procedure_code_4
  ,m.procedure_code_5
  ,m.procedure_code_6
  ,m.procedure_code_7
  ,m.procedure_code_8
  ,m.procedure_code_9
  ,m.procedure_code_10
  ,m.procedure_code_11
  ,m.procedure_code_12
  ,m.procedure_code_13
  ,m.procedure_code_14
  ,m.procedure_code_15
  ,m.procedure_code_16
  ,m.procedure_code_17
  ,m.procedure_code_18
  ,m.procedure_code_19
  ,m.procedure_code_20
  ,m.procedure_code_21
  ,m.procedure_code_22
  ,m.procedure_code_23
  ,m.procedure_code_24
  ,m.procedure_code_25
  ,m.procedure_date_1
  ,m.procedure_date_2
  ,m.procedure_date_3
  ,m.procedure_date_4
  ,m.procedure_date_5
  ,m.procedure_date_6
  ,m.procedure_date_7
  ,m.procedure_date_8
  ,m.procedure_date_9
  ,m.procedure_date_10
  ,m.procedure_date_11
  ,m.procedure_date_12
  ,m.procedure_date_13
  ,m.procedure_date_14
  ,m.procedure_date_15
  ,m.procedure_date_16
  ,m.procedure_date_17
  ,m.procedure_date_18
  ,m.procedure_date_19
  ,m.procedure_date_20
  ,m.procedure_date_21
  ,m.procedure_date_22
  ,m.procedure_date_23
  ,m.procedure_date_24
  ,m.procedure_date_25
  ,'cclf' as data_source
from {{ var('medical_claim')}} m
inner join {{ ref('encounter_type_mapping')}} e
	on m.claim_id = e.original_claim_id
    and m.claim_line_number = e.claim_line_number
inner join {{ ref('encounter_claim_crosswalk')}} c
	on e.merge_claim_id = c.merge_claim_id
left join {{ ref('admit_type')}} at
	on m.admit_type_code = at.admit_type_code
left join {{ ref('admit_source')}} asrc
	on m.admit_source_code = asrc.admit_source_code
left join {{ ref('revenue_center')}} rev
	on m.revenue_center_code = rev.revenue_center_code
left join {{ ref('place_of_service')}} pos
	on m.place_of_service_code = pos.place_of_service_code
left join {{ ref('discharge_disposition')}} dd
	on m.discharge_disposition_code = dd.discharge_disposition_code
where isnull(m.revenue_center_code,'') <> '0001'