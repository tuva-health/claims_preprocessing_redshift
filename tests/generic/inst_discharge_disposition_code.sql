{% test inst_discharge_disposition_code(model, column_name) %}

/**  Returns rows if institutional claims have a null discharge disposition code  **/

select {{ column_name }}
from {{ model }}
where claim_type = 'I'
and nullif(discharge_disposition_code,'') is null

{% endtest %}