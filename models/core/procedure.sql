-------------------------------------------------------------------------------
-- Author       Thu Xuan Vu
-- Created      June 2022
-- Purpose      
-- Notes        
-------------------------------------------------------------------------------
-- Modification History
--
-------------------------------------------------------------------------------

with procedure_code as(
  select
	encounter_id
	,claim_id
	,patient_id
	,procedure_code_type as code_type
	,code
  	,rendering_npi as physician_npi
	,cast(replace(procedure,'procedure_code_','') as int) as procedure_sequence
  from claims_preprocessing.medical_claim_stage
  unpivot(
    code for procedure in (procedure_code_1
							,procedure_code_2
							,procedure_code_3
							,procedure_code_4
							,procedure_code_5
							,procedure_code_6
							,procedure_code_7
							,procedure_code_8
							,procedure_code_9
							,procedure_code_10
							,procedure_code_11
							,procedure_code_12
							,procedure_code_13
							,procedure_code_14
							,procedure_code_15
							,procedure_code_16
							,procedure_code_17
							,procedure_code_18
							,procedure_code_19
							,procedure_code_20
							,procedure_code_21
							,procedure_code_22
							,procedure_code_23
							,procedure_code_24
							,procedure_code_25)
            )pdx
)
, procedure_date as(
  select 
    claim_id
    ,procedure_date
    ,cast(replace(procedure,'procedure_date_','') as int) as procedure_sequence
  from claims_preprocessing.medical_claim_stage
  unpivot(
    procedure_date for procedure in (procedure_date_1
                                            ,procedure_date_2
                                            ,procedure_date_3
                                            ,procedure_date_4
                                            ,procedure_date_5
                                            ,procedure_date_6
                                            ,procedure_date_7
                                            ,procedure_date_8
                                            ,procedure_date_9
                                            ,procedure_date_10
                                            ,procedure_date_11
                                            ,procedure_date_12
                                            ,procedure_date_13
                                            ,procedure_date_14
                                            ,procedure_date_15
                                            ,procedure_date_16
                                            ,procedure_date_17
                                            ,procedure_date_18
                                            ,procedure_date_19
                                            ,procedure_date_20
                                            ,procedure_date_21
                                            ,procedure_date_22
                                            ,procedure_date_23
                                            ,procedure_date_24
                                            ,procedure_date_25)
            )ppoa
)
select distinct 
	encounter_id
	,patient_id
	,procedure_date
	,code_type
	,code
	,null as description
	,physician_npi
	,'cclf' as data_source
from procedure_code c
left join procedure_date d
  ON c.claim_id = d.claim_id
  AND c.procedure_sequence = d.procedure_sequence
