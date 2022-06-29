select 
  encounter_type
  , count(*) as encounter_count
  , (select count(*) from claims_preprocessing.encounter_type_mapping) as total_count
  , count(*) * 100.0 / (select count(*) from claims_preprocessing.encounter_type_mapping) as percentage
from claims_preprocessing.encounter_type_mapping
group by encounter_type