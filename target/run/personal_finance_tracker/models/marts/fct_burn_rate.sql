
  
    
    

    create  table
      "personal_finance"."main"."fct_burn_rate__dbt_tmp"
  
    as (
      -- Marts layer: Calculate daily burn rate with rolling averages
-- Focus: Window functions for trend analysis

with daily_spend as (
    select
        transaction_date,
        sum(amount) as daily_total,
        count(*) as transaction_count
    from "personal_finance"."main"."stg_transactions"
    group by transaction_date
),

burn_rate_calc as (
    select
        transaction_date,
        daily_total,
        transaction_count,
        
        -- 7-day rolling average (window function #1)
        avg(daily_total) over (
            order by transaction_date
            rows between 6 preceding and current row
        ) as avg_7day_spend,
        
        -- Cumulative spend (window function #2)
        sum(daily_total) over (
            order by transaction_date
            rows between unbounded preceding and current row
        ) as cumulative_spend,
        
        -- Running transaction count (window function #3)
        sum(transaction_count) over (
            order by transaction_date
            rows between unbounded preceding and current row
        ) as cumulative_transactions,
        
        -- Day-over-day change (window function #4)
        daily_total - lag(daily_total, 1) over (
            order by transaction_date
        ) as day_over_day_change,
        
        -- Percentage change from previous day (window function #5)
        round(
            ((daily_total - lag(daily_total, 1) over (order by transaction_date)) 
            / nullif(lag(daily_total, 1) over (order by transaction_date), 0)) * 100,
            2
        ) as pct_change_from_prev_day,
        
        -- Rank days by spending (window function #6)
        rank() over (order by daily_total desc) as spend_rank
        
    from daily_spend
)

select * from burn_rate_calc
order by transaction_date
    );
  
  