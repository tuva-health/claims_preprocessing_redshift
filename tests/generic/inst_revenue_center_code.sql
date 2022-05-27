{% test inst_revenue_center_code(model, column_name) %}

/**  Returns rows if institutional claims have a null revenue center code  **/

select {{ column_name }}
from {{ model }}
where claim_type = 'I'
and nullif(revenue_center_code,'') is null

{% endtest %}