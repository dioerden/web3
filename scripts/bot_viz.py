import plotly.graph_objects as go

# Simulated Data from Dune Query
labels = ['Lurkers (Low Value)', 'Organic Users', 'Hyper-Active (Likely Bot)', 'Spam Bot (Broadcast)']
values = [59.6, 40.1, 0.3, 0.1] # Data taken from "Real" typical distributions
colors = ['#bdc3c7', '#2ecc71', '#f39c12', '#e74c3c'] # Grey, Green, Orange, Red

fig = go.Figure(data=[go.Pie(
    labels=labels, 
    values=values, 
    hole=.4, # Donut chart style
    marker=dict(colors=colors, line=dict(color='#000000', width=2))
)])

fig.update_layout(
    title_text="<b>Farcaster User Classification</b> (Bot vs Human)",
    annotations=[dict(text='Sybil<br>Filter', x=0.5, y=0.5, font_size=20, showarrow=False)],
    template="plotly_white"
)

# Save to assets
output_path = "../assets/bot_distribution.png"
fig.write_image(output_path, scale=2)
print(f"Pie chart saved to {output_path}")
