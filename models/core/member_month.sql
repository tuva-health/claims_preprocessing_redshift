-------------------------------------------------------------------------------
-- Author       Thu Xuan Vu
-- Created      June 2022
-- Purpose      Provide member enrollment at a month/year grain
-------------------------------------------------------------------------------
-- Modification History
--
-------------------------------------------------------------------------------

select
	patient_id
    ,payer
    ,month
    ,year
    ,dual_status
    ,medicare_status
from core.eligibility