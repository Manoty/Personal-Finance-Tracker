-- Staging layer: Clean and standardize raw transaction data

-- Focus: Unify merchant names (Starbucks/Dunkin variants)

with source_data as (
    select * from "personal_finance"."main"."raw_bank_transactions"
),

cleaned as (
    select
        txn_id,
        date::date as transaction_date,
        
        -- Unify merchant names using CASE logic
        case
            when upper(description) like '%STARBUCKS%' then 'Starbucks'
            when upper(description) like '%DUNKIN%' then 'Dunkin'
            when upper(description) like '%NETFLIX%' then 'Netflix'
            when upper(description) like '%AMAZON%' then 'Amazon'
            when upper(description) like '%WALMART%' then 'Walmart'
            when upper(description) like '%RENT%' then 'Rent'
            when upper(description) like '%SALARY%' then 'Salary'
            else description
        end as merchant_clean,
        
        description as original_description,
        amount,
        account_type,
        
        -- Add metadata
        current_timestamp as loaded_at
    from source_data
)

select * from cleaned