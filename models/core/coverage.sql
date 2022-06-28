-------------------------------------------------------------------------------
-- Author       Thu Xuan Vu
-- Created      June 2022
-- Purpose      Populate patient coverage details.
-------------------------------------------------------------------------------
-- Modification History
--
-------------------------------------------------------------------------------


select 
    cast(patient_id as varchar) as patient_id
    ,cast(min(cast(month as varchar) + '-01-' + cast(year as varchar)) as date) as coverage_start_date
    ,cast(max(cast(month as varchar) + '-01-' + cast(year as varchar)) as date) as coverage_end_date
    ,cast(payer as varchar) as payer
    ,cast(payer_type as varchar) as payer_type
    ,cast('{{ var('data_set')}}' as varchar) as data_source
from {{ var('eligibility')}}
group by 
    patient_id
    ,payer
    ,payer_type