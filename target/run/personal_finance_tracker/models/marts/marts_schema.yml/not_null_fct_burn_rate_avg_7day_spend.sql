
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select avg_7day_spend
from "personal_finance"."main"."fct_burn_rate"
where avg_7day_spend is null



  
  
      
    ) dbt_internal_test