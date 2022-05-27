{% test prof_place_of_service_code(model, column_name) %}

/**  Returns rows if profession claims have a null place of service  **/

select {{ column_name }}
from {{ model }}
where claim_type = 'P'
and nullif(place_of_service_code,'') is null

{% endtest %}