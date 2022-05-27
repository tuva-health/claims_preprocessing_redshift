{% test inst_bill_type_code(model, column_name) %}

/**  Returns rows if institutional claims have a null bill type code  **/

select {{ column_name }}
from {{ model }}
where claim_type = 'I'
and nullif(bill_type_code,'') is null

{% endtest %}