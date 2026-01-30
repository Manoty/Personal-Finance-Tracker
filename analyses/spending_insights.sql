-- Analysis 1: Top spending days
select
    transaction_date,
    daily_total,
    transaction_count,
    spend_rank
from {{ ref('fct_burn_rate') }}
order by daily_total desc
limit 10;

-- Analysis 2: Coffee addiction analysis (Starbucks vs Dunkin)
select
    merchant_clean,
    count(*) as visits,
    sum(amount) as total_spent,
    avg(amount) as avg_per_visit,
    min(amount) as min_spend,
    max(amount) as max_spend
from {{ ref('stg_transactions') }}
where merchant_clean in ('Starbucks', 'Dunkin')
group by merchant_clean;

-- Analysis 3: Spending by account type
select
    account_type,
    count(*) as transaction_count,
    sum(amount) as total_spent,
    avg(amount) as avg_transaction
from {{ ref('stg_transactions') }}
group by account_type;

