-- macros/fields/type_description.sql
{% macro type_description(attendance_type_column) %}
CASE 
    WHEN {{ attendance_type_column}} = 'Type 1' THEN 'Major A&E'
    WHEN {{ attendance_type_column}} = 'Type 2' THEN 'Minor A&E'
    WHEN {{ attendance_type_column}} = 'Other' THEN 'walk-in Centre'
    ELSE 'Unknown'
END
{% endmacro%}