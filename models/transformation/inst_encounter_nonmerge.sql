/** Query to roll up claim line to the encounter level; only for non-merged institutional claims.
		First:  Creating the min and max dates for an encounter based on all claims.  Also summing the dollar fields.
        	This requires data at the claim line level so going back to encounter_type_mapping.
            Excluding claims that have been merged, using the merged_claim_id as the encounter_id since this ID links claims under the new mapping .
        Secondly:  Creating a new claim line id.  Two claims can be merged and have claim_line_number of 1.  Maintin the original line number when possible
        	but otherwise using end date.
        Lastly:  Creating final encounter info by taking data from the first claim
        **/

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

 , encounter_header as(
  select
   row_number() over (partition by d.group_claim_id order by claim_line_number, claim_start_date) as row_sequence
   ,d.group_claim_id as encounter_id
   ,m.patient_id
   ,m.encounter_type
   ,d.encounter_start_date
   ,d.encounter_end_date
   ,m.admit_source_code
   ,m.admit_type_code
   ,m.discharge_disposition_code
   ,m.physician_npi
   ,m.facility_npi
   ,m.ms_drg
   ,d.paid_amount
   ,d.charge_amount
  from encounter_dates d
  inner join {{ ref('encounter_type_mapping')}} m
  	on d.group_claim_id = m.merge_claim_id
)


select distinct
   encounter_id
   ,patient_id
   ,encounter_type
   ,encounter_start_date
   ,encounter_end_date
   ,first_value(admit_source_code) over(partition by encounter_id order by row_sequence rows between unbounded preceding and unbounded following) as admit_source_code
   ,first_value(admit_type_code) over(partition by encounter_id order by row_sequence rows between unbounded preceding and unbounded following) as admit_type_code
   ,last_value(discharge_disposition_code) over(partition by encounter_id order by row_sequence rows between unbounded preceding and unbounded following) as discharge_disposition_code
   ,first_value(physician_npi) over(partition by encounter_id order by row_sequence rows between unbounded preceding and unbounded following) as physician_npi
   ,facility_npi
   ,first_value(ms_drg) over(partition by encounter_id order by row_sequence rows between unbounded preceding and unbounded following) as ms_drg
   ,paid_amount
   ,charge_amount
from encounter_header