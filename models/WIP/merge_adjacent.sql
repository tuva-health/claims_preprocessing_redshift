/**  Creating a list of patient's dates that include both from and thru to compare dates and determine days since last visit  **/
with date_union as(
  select
	patient_id
  	,merge_claim_id
  	,original_claim_id
    ,claim_start_date as claim_date
  	,claim_start_date 
  	,claim_end_date
  	,1 as claim_start_date_flag
    ,0 as claim_end_date_flag
    ,facility_npi
    ,discharge_disposition_code
  from {{ ref('encounter_type')}} e
  where claim_type = 'I'

union all
  
  select
	patient_id
  	,merge_claim_id
  	,original_claim_id
    ,claim_end_date as claim_date
  	,claim_start_date 
  	,claim_end_date
  	,0 as claim_start_date_flag
    ,1 as claim_end_date_flag
    ,facility_npi
    ,discharge_disposition_code
  from {{ ref('encounter_type')}} e
  where claim_type = 'I'

)
/** Numbering claims is enable sequential ordering  **/ 
,sort_date_union as(
  select 
  *
  ,row_number() over (partition by patient_id order by claim_end_date) AS row_sequence
  from date_union
 
)
/**  Using lag function to find the previous claims thru date, status, facility and claim  **/
,date_lag as(
  select 
    lag(claim_date) over (partition by patient_id order by row_sequence) as previous_thru_date
  	,lag(discharge_disposition_code) over (partition by patient_id order by row_sequence) as previous_bene_status
  	,lag(facility_npi) over (partition by patient_id order by row_sequence) as previous_facility
    ,lag(merge_claim_id) over (partition by patient_id order by row_sequence) as previous_claim
    ,*
  from sort_date_union
)
/** Performing date diff on previous thru date to current from date.  Filtering on from dates only to avoid date diff between same claim (i.e. LOS)  **/
 , date_last_visit as(
select 
  datediff(day, previous_thru_date, claim_date) as days_since_last_visit
  ,* 
from date_lag
where 1=1
and claim_end_date_flag = 1
and previous_claim <> merge_claim_id
)
select
	previous_claim as merge_claim_a
    ,merge_claim_id as merge_claim_b
    ,'1' as link_flag
from date_last_visit 
where 1=1
and days_since_last_visit = 1
/** status of previous claim: 'still a patient'  **/
and previous_bene_status = '30'
/** eliminates transfers to diff facility  **/
and previous_facility = facility_npi