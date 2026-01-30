
    
    

select
    transaction_date as unique_field,
    count(*) as n_records

from "personal_finance"."main"."fct_burn_rate"
where transaction_date is not null
group by transaction_date
having count(*) > 1


