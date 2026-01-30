# Personal Finance Tracker - dbt + DuckDB

A Modern Data Stack project analyzing 2,500 bank transactions using dbt and DuckDB. Built to showcase SQL skills, data modeling, and window functions for technical interviews.

## 🎯 Project Overview

This project demonstrates:
- **ETL Pipeline**: CSV → DuckDB → Transformed Data
- **Data Modeling**: Staging (cleaning) → Marts (metrics)
- **SQL Mastery**: Window functions, CASE statements, aggregations
- **Data Quality**: Automated testing with dbt
- **Documentation**: Auto-generated lineage graphs

## 📊 Dataset

- **Source**: 2,500 synthetic bank transactions (2025)
- **Merchants**: Starbucks, Dunkin, Netflix, Amazon, Walmart, Rent, Salary
- **Challenge**: Messy merchant names (e.g., "STARBUCKS COFFEE #123" vs "Starbucks")
- **Accounts**: Checking and Credit Card transactions

## 📂 Project Structure
```
personal_finance_tracker/
├── dbt_project.yml           # dbt configuration
├── profiles.yml              # DuckDB connection
├── data/                     # DuckDB database file
├── seeds/
│   └── raw_bank_transactions.csv  # 2,500 transactions
├── models/
│   ├── staging/
│   │   ├── stg_transactions.sql   # Merchant name cleaning
│   │   └── stg_schema.yml         # Staging tests
│   └── marts/
│       ├── fct_burn_rate.sql      # 6 window functions
│       └── marts_schema.yml       # Marts tests
└── analyses/
    ├── spending_insights.sql      # Top merchants, categories
    └── trend_analysis.sql         # Variance, momentum, milestones
```

## 🚀 Quick Start

### Prerequisites
```powershell
pip install dbt-duckdb
```

### Run the Pipeline
```powershell
# Load seed data
dbt seed

# Run all models
dbt run

# Run tests
dbt test

# Generate documentation
dbt docs generate
dbt docs serve
```

## 🧪 What Gets Built

### Staging Layer: `stg_transactions`
**Purpose**: Clean and standardize raw data

**Key Transformations**:
- Unify merchant names using CASE logic
  - "STARBUCKS COFFEE #123" → "Starbucks"
  - "DUNKIN DONUTS STORE 44" → "Dunkin"
- Convert date strings to proper dates
- Add metadata (loaded_at timestamp)

**Tests**:
- ✅ Unique transaction IDs
- ✅ No null values in key fields
- ✅ Valid account types (Checking/Credit Card)

### Marts Layer: `fct_burn_rate`
**Purpose**: Calculate daily spending metrics with window functions

**6 Window Functions**:
1. **7-day rolling average** - Smooth out daily volatility
2. **Cumulative spend** - Running total over time
3. **Running transaction count** - Total transactions to date
4. **Day-over-day change** - Daily spending delta
5. **Percentage change** - % change from previous day
6. **Spend rank** - Rank days by total spending

**Tests**:
- ✅ Unique dates
- ✅ No null metrics
- ✅ Data integrity checks

## 📈 Sample Queries

### Top Spending Days
```sql
select
    transaction_date,
    daily_total,
    spend_rank
from fct_burn_rate
order by daily_total desc
limit 10;
```

### Coffee Spending Analysis
```sql
select
    merchant_clean,
    count(*) as visits,
    sum(amount) as total_spent,
    avg(amount) as avg_per_visit
from stg_transactions
where merchant_clean in ('Starbucks', 'Dunkin')
group by merchant_clean;
```

### 7-Day Trend
```sql
select
    transaction_date,
    daily_total,
    avg_7day_spend,
    daily_total - avg_7day_spend as variance
from fct_burn_rate
order by transaction_date desc
limit 7;
```

## 🎤 Interview Talking Points

### Why dbt?
"dbt brings software engineering best practices to analytics - version control, testing, documentation, and modularity. It handles dependency management automatically and makes collaboration easier."

### Staging vs Marts?
"Staging is 1:1 with source data - it's about cleaning and standardization. Marts contain business logic and metrics. This separation makes debugging easier and code more reusable."

### Window Functions Deep Dive
"I used 6 different window functions in the burn rate model:
- **AVG OVER** for 7-day rolling average to smooth volatility
- **SUM OVER** for cumulative spend tracking
- **LAG** to compare day-over-day changes
- **RANK** to identify highest spending days

Unlike GROUP BY, window functions preserve row-level detail while calculating aggregates."

### Data Quality Approach
"I implemented tests at both layers - staging tests validate source data integrity (unique IDs, no nulls, valid values), while marts tests ensure metric calculations are complete. This catches issues early in the pipeline."

### Scalability Considerations
"For larger datasets, I'd:
1. Switch to incremental models (only process new data)
2. Add partitioning by month/year
3. Consider materializing staging as tables instead of views
4. Implement data retention policies"

## 🔍 Key SQL Patterns Demonstrated

### CASE Statement (Merchant Cleaning)
```sql
case
    when upper(description) like '%STARBUCKS%' then 'Starbucks'
    when upper(description) like '%DUNKIN%' then 'Dunkin'
    else description
end as merchant_clean
```

### Rolling Average (Window Function)
```sql
avg(daily_total) over (
    order by transaction_date
    rows between 6 preceding and current row
) as avg_7day_spend
```

### Day-over-Day Comparison (LAG)
```sql
daily_total - lag(daily_total, 1) over (
    order by transaction_date
) as day_over_day_change
```

### Cumulative Sum
```sql
sum(daily_total) over (
    order by transaction_date
    rows between unbounded preceding and current row
) as cumulative_spend
```

## ✅ Testing Coverage

**Staging Tests (5)**:
- Transaction ID uniqueness
- Required fields (date, merchant, amount, account_type)
- Account type valid values

**Marts Tests (5)**:
- Date uniqueness
- Metric completeness (no nulls in calculations)

## 📚 Analysis Files

### `spending_insights.sql`
- Top spending days
- Coffee analysis (Starbucks vs Dunkin)
- Spending by account type
- Top merchants overall
- Monthly spending trends

### `trend_analysis.sql`
- Spending variance detection
- Momentum analysis (consecutive high-spend days)
- Cumulative milestones
- Best and worst spending days

## 🎯 Success Metrics

✅ 2,500 transactions processed  
✅ 100% test coverage (10/10 tests passing)  
✅ 2 model layers (staging + marts)  
✅ 6 window functions implemented  
✅ Auto-generated documentation with lineage  
✅ 8+ analysis queries ready to demo  

## 🚀 Next Steps / Extensions

1. **Add dimensions**: Create `dim_merchants` and `dim_categories` tables
2. **Monthly aggregations**: Build `fct_monthly_spend` mart
3. **Budget tracking**: Add budget vs actual comparison
4. **Anomaly detection**: Flag unusual spending patterns
5. **Visualization**: Connect to Streamlit/Tableau for dashboards
6. **Incremental loads**: Optimize for daily updates

## 🛠️ Tech Stack

- **dbt**: Data transformation and testing
- **DuckDB**: Embedded analytics database
- **SQL**: Window functions, CTEs, aggregations
- **Python**: Seed data generation (pandas)

## 📖 Documentation

View the full lineage graph and model documentation:
```powershell
dbt docs serve
```

Navigate to `http://localhost:8080` to see:
- Interactive lineage graph
- Column-level documentation
- Test results
- Model dependencies

---

**Built for Modern Data Stack interviews** | Demonstrates SQL mastery, data modeling, and analytics engineering best practices 🚀