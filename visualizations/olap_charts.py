"""Indian Automobile Database OLAP Visualizations - Dark Neon Theme"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import os
from pathlib import Path
from matplotlib.patches import Patch

OUT_DIR = Path(os.path.expanduser('~')) / 'Downloads'
OUT_DIR.mkdir(parents=True, exist_ok=True)

BG = '#0F0F1A'
NEON = ['#00E5FF', '#FF3CAC', '#00FF88', '#FFD700', '#FF6B6B', '#A78BFA']
TEXT = '#E6E6FA'
GRID = '#2A2A3E'

plt.rcParams.update({
    'figure.facecolor': BG,
    'axes.facecolor': BG,
    'axes.edgecolor': GRID,
    'axes.labelcolor': TEXT,
    'axes.titlecolor': TEXT,
    'xtick.color': TEXT,
    'ytick.color': TEXT,
    'text.color': TEXT,
    'grid.color': GRID,
    'font.size': 10,
    'axes.titleweight': 'bold',
    'axes.titlesize': 13,
})


def fmt_inr(v_lakhs):
    """Format value (given in Lakhs) as ₹XL or ₹X.XXCr."""
    if v_lakhs >= 100:
        return f"₹{v_lakhs/100:.2f}Cr"
    return f"₹{v_lakhs:.1f}L"


def style_ax(ax, title=None):
    if title:
        ax.set_title(title, pad=14)
    ax.grid(True, alpha=0.25, linestyle='--')
    for s in ax.spines.values():
        s.set_color(GRID)


def save(fig, name):
    path = OUT_DIR / name
    fig.savefig(path, facecolor=BG, dpi=120, bbox_inches='tight')
    plt.close(fig)
    print(f"Saved: {path}")


# ---------- Q1: Revenue by Company ----------
def q1(ax=None):
    companies = ['Toyota Kirloskar', 'Mahindra', 'Tata Motors', 'Maruti Suzuki',
                 'Hyundai Motor India', 'Kia India', 'Honda Cars India']
    revenue = [45, 43, 33, 16, 14, 13, 12]  # Lakhs
    units = [1, 2, 2, 2, 1, 1, 1]
    order = np.argsort(revenue)
    companies = [companies[i] for i in order]
    revenue = [revenue[i] for i in order]
    units = [units[i] for i in order]

    standalone = ax is None
    if standalone:
        fig, ax = plt.subplots(figsize=(11, 6))
    colors = [NEON[i % len(NEON)] for i in range(len(companies))]
    bars = ax.barh(companies, revenue, color=colors, edgecolor=BG, linewidth=1.5)
    for bar, rev, u in zip(bars, revenue, units):
        ax.text(bar.get_width() + 0.8, bar.get_y() + bar.get_height()/2,
                f"{fmt_inr(rev)} ({u}u)", va='center', color=TEXT, fontsize=9)
    ax.set_xlabel('Revenue (₹ Lakhs)')
    ax.set_xlim(0, max(revenue) * 1.25)
    style_ax(ax, 'Q1: Revenue by Company (Grand Total: ₹1.76Cr, 10 units)')
    if standalone:
        save(fig, 'q1_revenue_by_company.png')


# ---------- Q2: Body Style Donut ----------
def q2(ax=None):
    labels = ['SUV', 'Compact SUV', 'Sedan', 'Hatchback']
    values = [110, 38, 20.5, 7.5]  # Lakhs
    units = [4, 3, 2, 1]
    colors = NEON[:4]

    standalone = ax is None
    if standalone:
        fig, ax = plt.subplots(figsize=(9, 7))

    wedges, _ = ax.pie(values, colors=colors, startangle=90,
                       wedgeprops=dict(width=0.38, edgecolor=BG, linewidth=2))
    total = sum(values)
    ax.text(0, 0.08, fmt_inr(total), ha='center', va='center',
            fontsize=18, fontweight='bold', color='#00E5FF')
    ax.text(0, -0.12, 'Total Revenue', ha='center', va='center',
            fontsize=9, color=TEXT)

    legend_labels = [f"{l}: {fmt_inr(v)} ({u}u)" for l, v, u in zip(labels, values, units)]
    ax.legend(wedges, legend_labels, loc='center left',
              bbox_to_anchor=(1.02, 0.5), frameon=False, labelcolor=TEXT)
    ax.set_title('Q2: Revenue by Body Style', pad=14)
    if standalone:
        save(fig, 'q2_revenue_by_bodystyle.png')


# ---------- Q3: Cumulative Revenue ----------
def q3(ax=None):
    dates = ['15-Mar', '20-Mar', '01-Apr', '10-Apr', '20-Apr',
             '01-May', '10-May', '15-May', '25-May', '01-Jun']
    models = ['Swift', 'Dzire', 'Nexon', 'Harrier', 'Thar',
              'XUV700', 'Creta', 'City', 'Fortuner', 'Seltos']
    incr = [7.5, 8.5, 11, 22, 18, 25, 14, 12, 45, 13]
    cum = np.cumsum(incr)

    standalone = ax is None
    if standalone:
        fig, ax = plt.subplots(figsize=(13, 6))

    x = np.arange(len(dates))
    ax.fill_between(x, 0, cum, color='#00E5FF', alpha=0.18)
    ax.plot(x, cum, color='#00E5FF', linewidth=2.5, marker='o',
            markerfacecolor='#FF3CAC', markeredgecolor='#00E5FF',
            markersize=9, markeredgewidth=1.5)
    for i, (c, m, inc) in enumerate(zip(cum, models, incr)):
        ax.annotate(f"{m}\n+{fmt_inr(inc)}", (i, c),
                    textcoords="offset points", xytext=(0, 12),
                    ha='center', fontsize=7.5, color=TEXT)
    ax.set_xticks(x)
    ax.set_xticklabels(dates, rotation=35, ha='right')
    ax.set_ylabel('Cumulative Revenue (₹ Lakhs)')
    ax.set_ylim(0, max(cum) * 1.22)
    style_ax(ax, 'Q3: Cumulative Revenue Over Time (Final: ₹1.76Cr)')
    if standalone:
        save(fig, 'q3_cumulative_revenue.png')


# ---------- Q4: Customer Income Rank ----------
def q4(ax=None):
    data = [('Sneha', 'F', 9, 1), ('Neha', 'F', 8.5, 2), ('Anita', 'F', 8.2, 3),
            ('Priya', 'F', 8, 4), ('Arjun', 'M', 7.5, 5), ('Pooja', 'F', 7.2, 6),
            ('Rohit', 'M', 7, 7), ('Meera', 'F', 6.5, 8), ('Amit', 'M', 6, 9),
            ('Vikas', 'M', 5.8, 10), ('Karan', 'M', 5.5, 11), ('Rahul', 'M', 5, 12)]
    data = data[::-1]
    names = [f"#{d[3]} {d[0]}" for d in data]
    incomes = [d[2] for d in data]
    colors = ['#FF3CAC' if d[1] == 'F' else '#00E5FF' for d in data]

    standalone = ax is None
    if standalone:
        fig, ax = plt.subplots(figsize=(11, 8))
    bars = ax.barh(names, incomes, color=colors, edgecolor=BG, linewidth=1.2)
    for bar, inc in zip(bars, incomes):
        ax.text(bar.get_width() + 0.08, bar.get_y() + bar.get_height()/2,
                f"₹{inc}L", va='center', color=TEXT, fontsize=9)
    ax.set_xlabel('Annual Income (₹ Lakhs)')
    ax.set_xlim(0, max(incomes) * 1.15)
    ax.legend(handles=[Patch(color='#FF3CAC', label='Female'),
                       Patch(color='#00E5FF', label='Male')],
              loc='lower right', facecolor=BG, edgecolor=GRID, labelcolor=TEXT)
    style_ax(ax, 'Q4: Customer Ranking by Income')
    if standalone:
        save(fig, 'q4_customer_income_rank.png')


# ---------- Q5: Gender Analysis ----------
def q5(axes=None):
    standalone = axes is None
    if standalone:
        fig, axes = plt.subplots(1, 2, figsize=(13, 6))
    ax1, ax2 = axes

    genders = ['Female', 'Male']
    counts = [6, 6]
    avgs = [7.9, 6.13]
    mins = [6.5, 5.0]
    maxs = [9.0, 7.5]
    colors = ['#FF3CAC', '#00E5FF']

    bars = ax1.bar(genders, counts, color=colors, edgecolor=BG, linewidth=2, width=0.55)
    for b, c in zip(bars, counts):
        ax1.text(b.get_x() + b.get_width()/2, b.get_height() + 0.1,
                 str(c), ha='center', color=TEXT, fontsize=12, fontweight='bold')
    ax1.set_ylabel('Customer Count')
    ax1.set_ylim(0, 8)
    style_ax(ax1, 'Customer Count by Gender (Total: 12)')

    x = np.arange(len(genders))
    for i, (mn, mx, av, col) in enumerate(zip(mins, maxs, avgs, colors)):
        ax2.plot([i, i], [mn, mx], color=col, linewidth=6, solid_capstyle='round', alpha=0.6)
        ax2.scatter(i, mn, color=col, s=80, zorder=3, edgecolor=BG)
        ax2.scatter(i, mx, color=col, s=80, zorder=3, edgecolor=BG)
        ax2.scatter(i, av, color='#FFD700', s=180, marker='D', zorder=4,
                    edgecolor=BG, linewidth=1.5, label='Avg' if i == 0 else None)
        ax2.text(i + 0.12, mx, f"Max ₹{mx}L", va='center', color=TEXT, fontsize=8)
        ax2.text(i + 0.12, mn, f"Min ₹{mn}L", va='center', color=TEXT, fontsize=8)
        ax2.text(i + 0.12, av, f"Avg ₹{av}L", va='center', color='#FFD700', fontsize=9,
                 fontweight='bold')
    ax2.set_xticks(x)
    ax2.set_xticklabels(genders)
    ax2.set_ylabel('Income (₹ Lakhs)')
    ax2.set_xlim(-0.5, 1.8)
    ax2.set_ylim(4, 10)
    ax2.legend(loc='upper right', facecolor=BG, edgecolor=GRID, labelcolor=TEXT)
    style_ax(ax2, 'Income Range by Gender')
    if standalone:
        save(fig, 'q5_gender_analysis.png')


# ---------- Q6: Sold vs Unsold ----------
def q6(ax=None):
    sold_only = ['City', 'Creta', 'Dzire', 'Fortuner', 'Harrier',
                 'Nexon', 'Seltos', 'Thar', 'XUV700']
    unsold_only = ['Hector', 'Kwid', 'Safari', 'i20']
    models = sold_only + ['Swift'] + unsold_only
    sold = [1]*9 + [1] + [0]*4
    unsold = [0]*9 + [1] + [1]*4

    standalone = ax is None
    if standalone:
        fig, ax = plt.subplots(figsize=(13, 6))
    x = np.arange(len(models))
    ax.bar(x, sold, color='#00FF88', label='Sold', edgecolor=BG, linewidth=1.2)
    ax.bar(x, unsold, bottom=sold, color='#FF6B6B', label='Unsold',
           edgecolor=BG, linewidth=1.2)
    ax.set_xticks(x)
    ax.set_xticklabels(models, rotation=40, ha='right')
    ax.set_ylabel('Units Produced')
    ax.set_yticks([0, 1, 2])
    ax.legend(facecolor=BG, edgecolor=GRID, labelcolor=TEXT)
    style_ax(ax, 'Q6: Sold vs Unsold per Model (Total: 15 produced, 10 sold, 5 unsold)')
    if standalone:
        save(fig, 'q6_sold_vs_unsold.png')


# ---------- Q7: Colour Popularity ----------
def q7(ax=None):
    colours = ['White', 'Grey', 'Black', 'Red', 'Blue']
    counts = [6, 3, 2, 2, 2]
    ranks = [1, 2, 3, 3, 3]
    fill = {'White': '#F5F5F5', 'Grey': '#888A8D', 'Black': '#1A1A1A',
            'Red': '#E53935', 'Blue': '#2196F3'}
    order = list(range(len(colours)))[::-1]
    colours = [colours[i] for i in order]
    counts = [counts[i] for i in order]
    ranks = [ranks[i] for i in order]

    standalone = ax is None
    if standalone:
        fig, ax = plt.subplots(figsize=(11, 6))
    bars = ax.barh(colours, counts, color=[fill[c] for c in colours],
                   edgecolor='#00E5FF', linewidth=1.8)
    for bar, c, r in zip(bars, counts, ranks):
        ax.text(bar.get_width() + 0.1, bar.get_y() + bar.get_height()/2,
                f"{c} models • Rank #{r}", va='center', color=TEXT, fontsize=10)
    ax.set_xlabel('Model Count')
    ax.set_xlim(0, max(counts) * 1.4)
    style_ax(ax, 'Q7: Colour Popularity (DENSE_RANK)')
    if standalone:
        save(fig, 'q7_colour_popularity.png')


# ---------- Q8: Parts per Supplier ----------
def q8(ax=None):
    suppliers = ['ZF India', 'Valeo', 'Bosch', 'Motherson', 'Denso',
                 'TVS Motors Supply', 'Bharat Forge', 'Ashok Leyland Parts',
                 'Amara Raja', 'Exide']
    counts = [2, 2, 2, 2, 2, 1, 1, 1, 1, 1]

    standalone = ax is None
    if standalone:
        fig, ax = plt.subplots(figsize=(12, 6))
    colors = [NEON[i % len(NEON)] for i in range(len(suppliers))]
    bars = ax.bar(suppliers, counts, color=colors, edgecolor=BG, linewidth=1.5)
    for b, c in zip(bars, counts):
        ax.text(b.get_x() + b.get_width()/2, b.get_height() + 0.05,
                str(c), ha='center', color=TEXT, fontsize=10, fontweight='bold')
    ax.set_xticklabels(suppliers, rotation=35, ha='right')
    ax.set_ylabel('Parts Supplied')
    ax.set_ylim(0, 3)
    style_ax(ax, 'Q8: Parts Supplied per Supplier (Total: 15)')
    if standalone:
        save(fig, 'q8_parts_per_supplier.png')


# ---------- Q9: Most Used Parts ----------
def q9(ax=None):
    parts = ['Brake', 'Gearbox', 'Battery', 'Suspension', 'Engine Block',
             'Radiator', 'Fuel Pump', 'Steering', 'Clutch', 'ECU']
    counts = [12, 3, 3, 2, 2, 1, 1, 1, 1, 1]
    ranks = [1, 2, 2, 3, 3, 4, 4, 4, 4, 4]
    order = list(range(len(parts)))[::-1]
    parts = [parts[i] for i in order]
    counts = [counts[i] for i in order]
    ranks = [ranks[i] for i in order]

    standalone = ax is None
    if standalone:
        fig, ax = plt.subplots(figsize=(11, 7))
    rank_color = {1: '#FFD700', 2: '#00E5FF', 3: '#00FF88', 4: '#A78BFA'}
    colors = [rank_color[r] for r in ranks]
    bars = ax.barh(parts, counts, color=colors, edgecolor=BG, linewidth=1.2)
    for bar, c, r in zip(bars, counts, ranks):
        ax.text(bar.get_width() + 0.15, bar.get_y() + bar.get_height()/2,
                f"{c} models • #{r}", va='center', color=TEXT, fontsize=9)
    ax.set_xlabel('Model Count')
    ax.set_xlim(0, max(counts) * 1.2)
    ax.legend(handles=[Patch(color=rank_color[r], label=f'Rank #{r}') for r in [1, 2, 3, 4]],
              loc='lower right', facecolor=BG, edgecolor=GRID, labelcolor=TEXT)
    style_ax(ax, 'Q9: Most Used Parts (DENSE_RANK)')
    if standalone:
        save(fig, 'q9_most_used_parts.png')


# ---------- Q10: SUV Buyers ----------
def q10(ax=None):
    buyers = ['Arjun', 'Neha', 'Sneha', 'Rohit']
    models = ['Fortuner', 'XUV700', 'Harrier', 'Thar']
    prices = [45, 25, 22, 18]
    order = np.argsort(prices)
    buyers = [buyers[i] for i in order]
    models = [models[i] for i in order]
    prices = [prices[i] for i in order]
    labels = [f"{b} — {m}" for b, m in zip(buyers, models)]

    standalone = ax is None
    if standalone:
        fig, ax = plt.subplots(figsize=(11, 5.5))
    colors = NEON[:len(buyers)]
    bars = ax.barh(labels, prices, color=colors, edgecolor=BG, linewidth=1.5)
    for bar, p in zip(bars, prices):
        ax.text(bar.get_width() + 0.6, bar.get_y() + bar.get_height()/2,
                fmt_inr(p), va='center', color=TEXT, fontsize=10, fontweight='bold')
    ax.set_xlabel('Price (₹ Lakhs)')
    ax.set_xlim(0, max(prices) * 1.2)
    style_ax(ax, 'Q10: SUV Buyers (Total SUV Revenue: ₹1.10Cr)')
    if standalone:
        save(fig, 'q10_suv_buyers.png')


# ---------- Master Dashboard ----------
def dashboard():
    fig = plt.figure(figsize=(22, 13))
    fig.suptitle('Indian Automobile Database — OLAP Master Dashboard',
                 fontsize=18, fontweight='bold', color='#00E5FF', y=0.995)
    gs = fig.add_gridspec(2, 3, hspace=0.55, wspace=0.35)

    q1(fig.add_subplot(gs[0, 0]))
    q2(fig.add_subplot(gs[0, 1]))
    q5([fig.add_subplot(gs[0, 2]), fig.add_subplot(gs[0, 2])] if False else None) if False else None
    # Gender analysis needs two sub-axes — nest a gridspec
    inner = gs[1, 0].subgridspec(1, 2, wspace=0.45)
    q5([fig.add_subplot(inner[0, 0]), fig.add_subplot(inner[0, 1])])
    q3(fig.add_subplot(gs[1, 1]))
    q7(fig.add_subplot(gs[0, 2]))
    q10(fig.add_subplot(gs[1, 2]))
    save(fig, 'dashboard_master.png')


if __name__ == '__main__':
    q1(); q2(); q3(); q4(); q5(); q6(); q7(); q8(); q9(); q10()
    dashboard()
    print("\nAll visualizations saved.")
