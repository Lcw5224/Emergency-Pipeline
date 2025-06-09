select  attendance_type
        ,type_description
from {{ ref('lookup') }}