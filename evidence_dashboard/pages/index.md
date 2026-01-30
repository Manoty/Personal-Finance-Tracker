# Personal Finance Dashboard

## Daily Burn Rate Analysis
```sql burn_rate
select 
    transaction_date,
    daily_total,
    avg_7day_spend,
    cumulative_spend,
    transaction_count
from fct_burn_rate
order by transaction_date
```

### Daily Spending Trend
<LineChart 
    data={burn_rate} 
    x=transaction_date 
    y=daily_total
    yAxisTitle="Daily Spend ($)"
/>

### 7-Day Rolling Average
<LineChart 
    data={burn_rate} 
    x=transaction_date 
    y=avg_7day_spend
    yAxisTitle="7-Day Avg Spend ($)"
/>

### Cumulative Spending
<AreaChart 
    data={burn_rate} 
    x=transaction_date 
    y=cumulative_spend
    yAxisTitle="Total Spend ($)"
/>

## Top Merchants
```sql top_merchants
select 
    merchant_clean,
    count(*) as transaction_count,
    sum(amount) as total_spent,
    avg(amount) as avg_transaction
from stg_transactions
group by merchant_clean
order by total_spent desc
limit 10
```

<BarChart 
    data={top_merchants} 
    x=merchant_clean 
    y=total_spent
    swapXY=true
/>

## Coffee Battle: Starbucks vs Dunkin
```sql coffee_stats
select 
    merchant_clean,
    count(*) as visits,
    sum(amount) as total_spent,
    avg(amount) as avg_per_visit
from stg_transactions
where merchant_clean in ('Starbucks', 'Dunkin')
group by merchant_clean
```

<BarChart 
    data={coffee_stats} 
    x=merchant_clean 
    y=total_spent
    title="Total Coffee Spending"
/>

<DataTable data={coffee_stats} />