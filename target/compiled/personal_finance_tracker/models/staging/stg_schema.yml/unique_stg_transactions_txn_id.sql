
    
    

select
    txn_id as unique_field,
    count(*) as n_records

from "personal_finance"."main"."stg_transactions"
where txn_id is not null
group by txn_id
having count(*) > 1


