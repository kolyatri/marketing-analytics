import pandas as pd
import numpy as np
import random
from datetime import datetime, timedelta

np.random.seed(42)

# ----------------------
# CONFIG
# ----------------------
NUM_USERS = 15000
START_DATE = datetime(2024, 1, 1)
END_DATE = datetime(2024, 3, 31)

channels = ["Facebook", "Google", "TikTok"]
countries = ["US", "CA", "UK", "DE"]

# ----------------------
# USERS
# ----------------------
users = []

for user_id in range(1, NUM_USERS + 1):
    signup_date = START_DATE + timedelta(days=random.randint(0, 60))
    country = random.choice(countries)

    users.append([user_id, signup_date.date(), country])

users_df = pd.DataFrame(users, columns=["user_id", "signup_date", "country"])

# ----------------------
# SESSIONS
# ----------------------
sessions = []
session_id = 1

for _, user in users_df.iterrows():
    num_sessions = np.random.poisson(5)

    for _ in range(num_sessions):
        session_date = user["signup_date"] + timedelta(days=random.randint(0, 30))
        channel = random.choices(channels, weights=[0.4, 0.4, 0.2])[0]
        device = random.choice(["mobile", "desktop"])

        sessions.append([session_id, user["user_id"], session_date, channel, device])
        session_id += 1

sessions_df = pd.DataFrame(
    sessions,
    columns=["session_id", "user_id", "session_date", "channel", "device"]
)

# ----------------------
# ORDERS
# ----------------------
orders = []
order_id = 1

for _, session in sessions_df.iterrows():
    # різний conversion rate по каналам
    if session["channel"] == "Google":
        prob = 0.12
    elif session["channel"] == "Facebook":
        prob = 0.08
    else:  # TikTok
        prob = 0.04

    if random.random() < prob:
        revenue = round(np.random.gamma(2, 50), 2)

        orders.append([
            order_id,
            session["user_id"],
            session["session_date"],
            revenue
        ])
        order_id += 1

orders_df = pd.DataFrame(
    orders,
    columns=["order_id", "user_id", "order_date", "revenue"]
)

# ----------------------
# ADS DATA
# ----------------------
ads = []

date_range = pd.date_range(START_DATE, END_DATE)

for date in date_range:
    for channel in channels:
        impressions = random.randint(5000, 20000)

        if channel == "Google":
            ctr = random.uniform(0.06, 0.09)
            cpc = random.uniform(0.3, 0.6)
        elif channel == "Facebook":
            ctr = random.uniform(0.04, 0.07)
            cpc = random.uniform(0.4, 0.8)
        else:  # TikTok
            ctr = random.uniform(0.03, 0.05)
            cpc = random.uniform(0.2, 0.5)

        clicks = int(impressions * ctr)
        ad_spend = round(clicks * cpc, 2)

        ads.append([
            date.date(),
            channel,
            f"{channel[:2]}_1",
            impressions,
            clicks,
            ad_spend
        ])

ads_df = pd.DataFrame(
    ads,
    columns=["date", "channel", "campaign_id", "impressions", "clicks", "ad_spend"]
)

# ----------------------
# SAVE
# ----------------------
users_df.to_csv("data/users.csv", index=False)
sessions_df.to_csv("data/sessions.csv", index=False)
orders_df.to_csv("data/orders.csv", index=False)
ads_df.to_csv("data/ads_data.csv", index=False)

print("Data generated!")