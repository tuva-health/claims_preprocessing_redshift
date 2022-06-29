{% test inst_facility_npi(model, column_name) %}

/**  Returns rows if institutional claims have a null facility npi  **/

select {{ column_name }}
from {{ model }}
where claim_type = 'I'
and nullif(facility_npi,'') is null

{% endtest %}