-------------------------------------------------------------------------------
-- Author       Thu Xuan Vu
-- Created      June 2022
-- Purpose      
-- Notes        
-------------------------------------------------------------------------------
-- Modification History
--
-------------------------------------------------------------------------------

select 
  claim_id
  ,claim_line_number
  ,claim_type
  ,encounter_id
  ,patient_id
  ,claim_start_date
  ,claim_end_date
  ,claim_line_start_date
  ,claim_line_end_date
  ,bill_type_code
  ,bill_type_description
  ,place_of_service_code
  ,place_of_service_description
  ,revenue_center_code
  ,revenue_center_description
  ,service_unit_quantity
  ,paid_date
  ,paid_amount
  ,hcpcs_code
  ,hcpcs_modifier_1
  ,hcpcs_modifier_2
  ,hcpcs_modifier_3
  ,hcpcs_modifier_4
  ,hcpcs_modifier_5
  ,rendering_npi
  ,billing_npi
  ,facility_npi
  ,discharge_disposition_code
  ,discharge_disposition_description
  ,charge_amount
  ,data_source
from {{ ref('medical_claim_stage')}}
