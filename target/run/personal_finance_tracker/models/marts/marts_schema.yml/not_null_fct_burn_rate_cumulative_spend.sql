
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select cumulative_spend
from "personal_finance"."main"."fct_burn_rate"
where cumulative_spend is null



  
  
      
    ) dbt_internal_test