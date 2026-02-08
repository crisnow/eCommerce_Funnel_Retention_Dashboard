# eCommerce_Funnel_Retention_Dashboard

Project Overview

Objective:
Visualize user behavior from signup to purchase, understand retention, and identify top-performing products using live event data.

Tools & Stack:

Data warehouse: Google BigQuery

ETL / Modeling: SQL (optional dbt for modeling)

Visualization: Looker Studio (Google Data Studio)

Metrics: Funnel conversion rates, 30-day retention, top products by revenue and device

Role:
End-to-end owner of the project: data extraction, modeling, visualization, and KPI calculation.

Key Features
1️⃣ Funnel Analysis

Visualized user journey: signup → add_to_cart → purchase

Highlighted drop-off points for user conversion

Calculated conversion rates per step

Tools: BigQuery + Looker Studio

2️⃣ Retention Analysis

30-day user retention chart

Identified trends in user engagement

Highlighted opportunities to improve product stickiness

3️⃣ Top Products / Revenue by Device

Identified highest-revenue products

Segmented by device type to guide marketing and product decisions

Approach / Methodology

Data Extraction & Modeling

Connected Looker Studio directly to BigQuery (live connection)

Filtered relevant events: signup, add_to_cart, purchase

Optional: Used SQL/dbt for aggregated metrics and calculated fields

Dashboard Creation

Designed interactive charts with filters for date and device

Added calculated metrics for conversion rates and retention

Ensured dashboards are clear, concise, and presentation-ready

Insights & Impact

Funnel revealed drop-offs and bottlenecks in the signup-to-purchase journey

Retention charts identified user engagement patterns

Top products / revenue by device helped guide marketing and product prioritization

Screenshots (or Link)

Funnel chart: Screenshot of signup → purchase conversion

Retention chart: Screenshot of 30-day retention curve

Top products / revenue chart: Screenshot segmented by device