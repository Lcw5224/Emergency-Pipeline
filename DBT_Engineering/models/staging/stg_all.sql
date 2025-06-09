{{
    config(
        materialized='view'
    )
}}

with source as (
    SELECT * 
    FROM {{ source("staging", "all") }}
)


SELECT
  {{ dbt_utils.generate_surrogate_key(['Org_Code', 'Parent_Org', 'Org_name']) }} as id,
  Org_Code,
  Parent_Org,
  Org_name,

  A_E_attendances_Type_1,
  A_E_attendances_Type_2,
  A_E_attendances_Other_A_E_Department,
  A_E_attendances_Booked_Appointments_Type_1,
  A_E_attendances_Booked_Appointments_Type_2,
  A_E_attendances_Booked_Appointments_Other_Department,

  Attendances_over_4hrs_Type_1,
  Attendances_over_4hrs_Type_2,
  Attendances_over_4hrs_Other_Department,
  Attendances_over_4hrs_Booked_Appointments_Type_1,
  Attendances_over_4hrs_Booked_Appointments_Type_2,
  Attendances_over_4hrs_Booked_Appointments_Other_Department,

  Patients_who_have_waited_4_12_hs_from_DTA_to_admission,
  Patients_who_have_waited_12__hrs_from_DTA_to_admission,

  Emergency_admissions_via_A_E___Type_1,
  Emergency_admissions_via_A_E___Type_2,
  Emergency_admissions_via_A_E___Other_A_E_department,
  Other_emergency_admissions,
  
  year_month,

  CASE
    WHEN A_E_attendances_Type_1 IS NOT NULL THEN 'Major A&E'
    WHEN A_E_attendances_Type_2 IS NOT NULL THEN 'Minor A&E'
    WHEN A_E_attendances_Other_A_E_Department IS NOT NULL THEN 'Walk-in Centre'
    ELSE 'Unknown'
    END AS type_description

FROM source

{% if var('is_test_run', default=false) %}
    limit 100
{% endif %}