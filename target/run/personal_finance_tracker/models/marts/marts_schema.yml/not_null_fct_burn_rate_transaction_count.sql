
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select transaction_count
from "personal_finance"."main"."fct_burn_rate"
where transaction_count is null



  
  
      
    ) dbt_internal_test