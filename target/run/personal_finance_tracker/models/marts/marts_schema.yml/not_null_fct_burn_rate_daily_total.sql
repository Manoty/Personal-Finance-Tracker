
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select daily_total
from "personal_finance"."main"."fct_burn_rate"
where daily_total is null



  
  
      
    ) dbt_internal_test