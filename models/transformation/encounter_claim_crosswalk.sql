-------------------------------------------------------------------------------
-- Author       Thu Xuan Vu
-- Created      June 2022
-- Purpose      Create a crosswalk from encounter_id, to merge_claim_id (claim id after encounter type mapping), to original_claim_id (claim id from source).
-- Notes        
-------------------------------------------------------------------------------
-- Modification History
--
-------------------------------------------------------------------------------

/**  Encounter to institutional claim for merged claims  **/

select
  c.group_claim_id as encounter_id
  ,c.merge_claim_id
  ,d.original_claim_id
from {{ ref('encounter_type_mapping')}} d
inner join {{ ref('inst_merge_crosswalk')}} c
    on d.merge_claim_id = c.merge_claim_id

union

/**  Encounter to institutional claim for nonmerged claims  **/

select
  d.merge_claim_id as encounter_id
  ,d.merge_claim_id
  ,d.original_claim_id
from {{ ref('encounter_type_mapping')}} d
left join {{ ref('inst_merge_crosswalk')}} c
    on d.merge_claim_id = c.merge_claim_id
where d.claim_type = 'I'
and c.merge_claim_id is null

union
/**  Encounter to professional claims for merged claims  **/
select 
  d.merge_claim_id as encounter_id
  ,d.merge_claim_id
  ,d.original_claim_id
from {{ ref('encounter_type_mapping')}} d
inner join {{ ref('prof_merge_crosswalk')}} c
    on d.merge_claim_id = c.merge_claim_id

union
/**  Encounter to professional claim for nonmerged claims  **/
select 
  d.merge_claim_id as encounter_id
  ,d.merge_claim_id
  ,d.original_claim_id
from {{ ref('encounter_type_mapping')}} d
left join {{ ref('prof_merge_crosswalk')}} c
    on d.merge_claim_id = c.merge_claim_id
left join {{ ref('prof_inst_encounter_crosswalk')}} i
    on i.merge_claim_id = d.merge_claim_id
where d.claim_type in ('P','DME')
and c.merge_claim_id is null
and i.merge_claim_id is null

union
/**  Encounter to professional claim for claims that link to merged claims  **/
select 
  encounter_id
  ,merge_claim_id
  ,original_claim_id
from {{ ref('prof_inst_encounter_crosswalk')}}


