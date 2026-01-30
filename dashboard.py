import streamlit as st
import duckdb
import plotly.express as px
import plotly.graph_objects as go
import pandas as pd

# Page config
st.set_page_config(page_title="Personal Finance Dashboard", page_icon="💰", layout="wide")

# Connect to DuckDB
@st.cache_resource
def get_connection():
    return duckdb.connect('data/personal_finance.duckdb', read_only=True)

conn = get_connection()

# Title
st.title("💰 Personal Finance Dashboard")
st.markdown("---")

# Load burn rate data
@st.cache_data
def load_burn_rate():
    return conn.execute("""
        SELECT 
            transaction_date,
            daily_total,
            avg_7day_spend,
            cumulative_spend,
            transaction_count,
            day_over_day_change,
            pct_change_from_prev_day
        FROM fct_burn_rate
        ORDER BY transaction_date
    """).df()

burn_rate = load_burn_rate()

# Metrics row
col1, col2, col3, col4 = st.columns(4)

with col1:
    total_spent = burn_rate['cumulative_spend'].iloc[-1]
    st.metric("Total Spent", f"${total_spent:,.2f}")

with col2:
    avg_daily = burn_rate['daily_total'].mean()
    st.metric("Avg Daily Spend", f"${avg_daily:,.2f}")

with col3:
    total_txns = burn_rate['cumulative_transactions'].iloc[-1]
    st.metric("Total Transactions", f"{int(total_txns):,}")

with col4:
    last_day_change = burn_rate['pct_change_from_prev_day'].iloc[-1]
    st.metric("Last Day Change", f"{last_day_change:.1f}%", delta=f"{last_day_change:.1f}%")

st.markdown("---")

# Daily Spending Trend
st.subheader("📈 Daily Spending Trend")
fig1 = px.line(burn_rate, x='transaction_date', y='daily_total', 
               title='Daily Spending Over Time',
               labels={'daily_total': 'Daily Spend ($)', 'transaction_date': 'Date'})
fig1.update_traces(line_color='#FF4B4B')
st.plotly_chart(fig1, use_container_width=True)

# 7-Day Rolling Average
st.subheader("📊 7-Day Rolling Average")
fig2 = px.line(burn_rate, x='transaction_date', y='avg_7day_spend',
               title='7-Day Average Spending',
               labels={'avg_7day_spend': '7-Day Avg ($)', 'transaction_date': 'Date'})
fig2.update_traces(line_color='#4B7BFF')
st.plotly_chart(fig2, use_container_width=True)

# Cumulative Spending
st.subheader("💸 Cumulative Spending")
fig3 = px.area(burn_rate, x='transaction_date', y='cumulative_spend',
               title='Total Cumulative Spending',
               labels={'cumulative_spend': 'Total Spend ($)', 'transaction_date': 'Date'})
fig3.update_traces(fillcolor='#50C878', line_color='#2E8B57')
st.plotly_chart(fig3, use_container_width=True)

st.markdown("---")

# Top Merchants
st.subheader("🏪 Top Merchants")
top_merchants = conn.execute("""
    SELECT 
        merchant_clean,
        COUNT(*) as transaction_count,
        SUM(amount) as total_spent,
        AVG(amount) as avg_transaction
    FROM stg_transactions
    GROUP BY merchant_clean
    ORDER BY total_spent DESC
    LIMIT 10
""").df()

fig4 = px.bar(top_merchants, x='total_spent', y='merchant_clean', 
              orientation='h',
              title='Top 10 Merchants by Total Spend',
              labels={'total_spent': 'Total Spent ($)', 'merchant_clean': 'Merchant'})
fig4.update_traces(marker_color='#FFD700')
st.plotly_chart(fig4, use_container_width=True)

# Coffee Battle
st.subheader("☕ Coffee Battle: Starbucks vs Dunkin")
coffee_stats = conn.execute("""
    SELECT 
        merchant_clean,
        COUNT(*) as visits,
        SUM(amount) as total_spent,
        AVG(amount) as avg_per_visit
    FROM stg_transactions
    WHERE merchant_clean IN ('Starbucks', 'Dunkin')
    GROUP BY merchant_clean
""").df()

col1, col2 = st.columns(2)

with col1:
    fig5 = px.bar(coffee_stats, x='merchant_clean', y='total_spent',
                  title='Total Coffee Spending',
                  labels={'total_spent': 'Total Spent ($)', 'merchant_clean': 'Coffee Shop'})
    fig5.update_traces(marker_color=['#00704A', '#FF6600'])
    st.plotly_chart(fig5, use_container_width=True)

with col2:
    st.dataframe(coffee_stats, use_container_width=True, hide_index=True)

st.markdown("---")
st.caption("Built with dbt + DuckDB + Streamlit")