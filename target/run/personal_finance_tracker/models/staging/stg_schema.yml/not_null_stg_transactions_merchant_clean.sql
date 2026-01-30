
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select merchant_clean
from "personal_finance"."main"."stg_transactions"
where merchant_clean is null



  
  
      
    ) dbt_internal_test