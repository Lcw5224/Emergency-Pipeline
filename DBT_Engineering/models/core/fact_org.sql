{{ config(
    materialized='table'
) }}

with org_source as (
    select * from {{ ref('stg_all') }}
),

lookup_table as (
    select * from {{ ref('dim_lookup') }}
),

enriched as (
    select
      *,
      case 
        when A_E_attendances_Type_1 is not null then 'Type 1'
        when A_E_attendances_Type_2 is not null then 'Type 2'
        when A_E_attendances_Other_A_E_Department is not null then 'Other'
        else 'Unknown'
      end as attendance_type
    from org_source
)

select
  e.id,
  e.Org_Code,
  e.Parent_Org,
  e.Org_name,
  e.year_month,  
  e.A_E_attendances_Type_1,
  e.A_E_attendances_Type_2,
  e.A_E_attendances_Other_A_E_Department,
  e.Attendances_over_4hrs_Type_1,
  e.Attendances_over_4hrs_Type_2,
  e.Attendances_over_4hrs_Other_Department,
  e.Emergency_admissions_via_A_E___Type_1,
  e.Emergency_admissions_via_A_E___Type_2,
  e.Emergency_admissions_via_A_E___Other_A_E_department,
  l.type_description
from enriched e
left join lookup_table l
on e.attendance_type = l.attendance_type