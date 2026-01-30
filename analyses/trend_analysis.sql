-- Analysis 1: Days with highest spending variance
select
    transaction_date,
    daily_total,
    avg_7day_spend,
    daily_total - avg_7day_spend as variance_from_avg,
    pct_change_from_prev_day
from {{ ref('fct_burn_rate') }}
where abs(daily_total - avg_7day_spend) > 50
order by abs(daily_total - avg_7day_spend) desc
limit 20;

-- Analysis 2: Spending momentum (consecutive high-spend days)
select
    transaction_date,
    daily_total,
    day_over_day_change,
    case
        when day_over_day_change > 0 then 'Increasing'
        when day_over_day_change < 0 then 'Decreasing'
        else 'Stable'
    end as trend_direction
from {{ ref('fct_burn_rate') }}
order by transaction_date;

-- Analysis 3: Cumulative spending milestones
select
    transaction_date,
    daily_total,
    cumulative_spend,
    cumulative_transactions,
    round(cumulative_spend / cumulative_transactions, 2) as avg_transaction_to_date
from {{ ref('fct_burn_rate') }}
where cumulative_spend >= 10000
    or cumulative_spend >= 50000
    or cumulative_spend >= 100000
order by cumulative_spend;

-- Analysis 4: Best and worst spending days
(select
    'Top 5 Highest Spend' as category,
    transaction_date,
    daily_total,
    transaction_count
from {{ ref('fct_burn_rate') }}
order by daily_total desc
limit 5)

union all

(select
    'Top 5 Lowest Spend' as category,
    transaction_date,
    daily_total,
    transaction_count
from {{ ref('fct_burn_rate') }}
order by daily_total asc
limit 5);