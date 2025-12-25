import pandas as pd
import numpy as np
import plotly.graph_objects as go
from plotly.subplots import make_subplots
import datetime

# 1. Generate Synthetic Data
# Simulation params
np.random.seed(42)
days = 180
start_date = datetime.date.today() - datetime.timedelta(days=days)
date_range = [start_date + datetime.timedelta(days=x) for x in range(days)]

# Simulate "Organic" Growth (DAU) -> Logarithmic growth + noise
t = np.linspace(1, 10, days)
dau_trend = 500 * np.log(t) * 10 
dau_noise = np.random.normal(0, 200, days)
dau = np.maximum(dau_trend + dau_noise, 100).astype(int)

# Simulate "Speculative" Token Price -> Correlated initially, then diverts (pump & dump)
price_trend = np.linspace(0.1, 2.5, days)
price_shock = np.concatenate([np.zeros(100), np.linspace(0, 3, 40), np.linspace(3, -1, 40)]) # Late spike and crash
token_price = 0.5 * np.log(t) + price_shock + np.random.normal(0, 0.1, days)
token_price = np.maximum(token_price, 0.01)

# Create DataFrame
df = pd.DataFrame({
    'Date': date_range,
    'DAU': dau,
    'Token_Price': token_price
})

# 2. Visualizing: User Growth vs Token Price
fig = make_subplots(specs=[[{"secondary_y": True}]])

# Add DAU Trace (Bar)
fig.add_trace(
    go.Bar(
        x=df['Date'], y=df['DAU'], 
        name="Daily Active Users (DAU)",
        marker_color='rgba(26, 118, 255, 0.6)'
    ),
    secondary_y=False
)

# Add Price Trace (Line)
fig.add_trace(
    go.Scatter(
        x=df['Date'], y=df['Token_Price'], 
        name="Token Price ($)",
        mode='lines',
        line=dict(color='crimson', width=3)
    ),
    secondary_y=True
)

# Cosmetic formatting (VC Style)
fig.update_layout(
    title_text="<b>Project Traction Analysis:</b> User Growth vs. Token Price",
    template="plotly_white",
    hovermode="x unified",
    legend=dict(orientation="h", yanchor="bottom", y=1.02, xanchor="right", x=1)
)

fig.update_yaxes(title_text="<b>DAU</b> (Users)", secondary_y=False, showgrid=False)
fig.update_yaxes(title_text="<b>Token Price</b> ($)", secondary_y=True, showgrid=True)

# 3. Save Output
output_path = "traction_chart.html"
fig.write_html(output_path)
print(f"Chart saved to {output_path}")

# Optional: Correlation calc
corr = df['DAU'].corr(df['Token_Price'])
print(f"Correlation Coefficient: {corr:.2f}")
