{% test encounter_type_mapping(model, column_name) %}

/** Returns rows if encounter type mapping does not exist in seed file
    Used custom test to account for unmapped rows.  Do not want to add them to the seed and test passes if they exist.   **/

select {{ column_name }}
from {{ model }} m
left join {{ ref('encounter_type')}} e
    on e.description = m.encounter_type
where m.encounter_type <> 'unmapped'
and e.description is null 

{% endtest %}