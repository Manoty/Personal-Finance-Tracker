
    
    

with all_values as (

    select
        account_type as value_field,
        count(*) as n_records

    from "personal_finance"."main"."stg_transactions"
    group by account_type

)

select *
from all_values
where value_field not in (
    'Checking','Credit Card'
)


