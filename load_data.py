import pandas as pd
import numpy as np
import os
from datetime import datetime, timedelta

if not os.path.exists('seeds'):
    os.makedirs('seeds')

rows = 2500
descriptions = ['STARBUCKS COFFEE #123', 'DUNKIN DONUTS STORE 44', 'NETFLIX.COM', 'AMAZON MKTPLACE', 'WALMART GROCERY', 'APARTMENT RENT', 'SALARY DEPOSIT']
data = {
    'txn_id': range(1, rows + 1),
    'date': [(datetime(2025, 1, 1) + timedelta(days=np.random.randint(0, 365))).strftime('%Y-%m-%d') for _ in range(rows)],
    'description': [np.random.choice(descriptions) for _ in range(rows)],
    'amount': [round(np.random.uniform(-100, -5), 2) for _ in range(rows)],
    'account_type': [np.random.choice(['Checking', 'Credit Card']) for _ in range(rows)]
}
pd.DataFrame(data).to_csv('seeds/raw_bank_transactions.csv', index=False)
print("SUCCESS: seeds/raw_bank_transactions.csv created!")
