import pandas as pd
import numpy as np
from faker import Faker
import random
from datetime import datetime, timedelta

fake = Faker()
num_users = 1000
days = 30

users = [fake.uuid4() for _ in range(num_users)]
events = []

for day in range(days):
    date = datetime.now() - timedelta(days=day)
    for user in users:
        if random.random() < 0.3:  # 30% chance to interact
            events.append({
                "user_id": user,
                "timestamp": date,
                "event_type": random.choice(["user_signup", "product_view", "add_to_cart", "purchase"]),
                "device_type": random.choice(["web", "mobile"]),
                "product_id": random.randint(1, 100),
                "price": random.uniform(5, 500)
            })

df = pd.DataFrame(events)
df.to_csv("events.csv", index=False)
