# 🏠 HubSpot Analytics Engineer Take-Home (Snowflake + dbt)

This project builds an analytics-ready data model on top of raw property listing data from HubSpot’s take-home dataset.  
It transforms raw calendar, review, and amenity information into a **single, daily reporting table** that supports revenue, occupancy, and amenity analysis across listings.

---

## ⚙️ Tech Stack

| Layer | Tool / Service | Purpose |
|-------|----------------|----------|
| Warehouse | **Snowflake** | Data storage & transformations |
| Transformation | **dbt Core** | Modeling, testing, documentation |
| Language | **SQL (Snowflake dialect)** | Data transformations |
| Version Control | **Git / GitHub** | Project management & submission |

---

## 🧠 Business Context

The goal was to design a reporting model that enables analysts to:
- Compare **revenue and occupancy** period-over-period.  
- Evaluate **review performance** per listing.  
- Analyze **amenity combinations** (e.g., AC vs Non-AC, Lockbox + First Aid Kit).  
- Compute **maximum possible stay durations** based on availability and listing rules.

The final table therefore needs to be **at the `listing_id × date` grain**, so analysts can filter and aggregate by any dimension without complex joins.

---
```text
## 🧩 Project Structure

hubspot_analytics_takehome/
├── README.md
├── dbt_project.yml
├── macros/
│ └── as_of_join.sql
├── models/
│ ├── sources.yml
│ ├── stage/
│ │ ├── stg__listings.sql
│ │ ├── stg__calendar.sql
│ │ ├── stg__generated_reviews.sql
│ │ └── stg__amenities_changelog.sql
│ ├── int/
│ │ ├── int__calendar_enriched.sql
│ │ ├── int__reviews_daily.sql
│ │ └── int__amenities_scd.sql
│ └── marts/
│ └── mart_listing_daily_enriched.sql
└── seeds/

```text
---

## 🧩 Model Summary & Grain

| Model | Grain | Key Fields | Purpose |
|--------|-------|-------------|----------|
| **`int__calendar_enriched`** | listing_id × date | price_usd, is_occupied, min_nights, max_nights, revenue_usd | Core daily fact table for availability & revenue |
| **`int__reviews_daily`** | listing_id × date | review_count_1d, avg_review_score_1d | Aggregates reviews per day |
| **`int__amenities_scd`** | listing_id × valid_from / valid_to | amenity flags | Tracks changing amenity availability |
| **`mart_listing_daily_enriched`** | listing_id × date | revenue_usd, occupancy, price, min/max nights, review metrics, amenity flags, neighborhood | Final analyst-ready “One Big Table” combining all relevant metrics |

---

## 🧮 Key Design Choices

- **Grain: Listing × Day** → Matches prompt and enables daily KPI comparison.  
- **One Big Table (OBT):** Instead of a star schema, the final mart denormalizes data for simplicity and direct querying.  
- **Amenity SCDs:** Handled via `int__amenities_scd` with `valid_from` / `valid_to`, joined as-of when populating the daily mart.  
- **Snowflake Functions Used:**
  - `ARRAY_CONTAINS()` & `PARSE_JSON()` → parse amenities lists.  
  - `QUALIFY ROW_NUMBER()` → select top runs / valid ranges.  
  - `DATEDIFF()` & windowing for availability “islands” queries.

---

## 🧰 How to Run

> **Prerequisites:**  
> - Python & dbt Core installed  
> - Access to a Snowflake warehouse (with a working profile in `~/.dbt/profiles.yml`)

```bash
# 1️⃣ Install dependencies
dbt deps

# 2️⃣ Verify Snowflake connection
dbt debug

# 3️⃣ Load and stage source data
dbt seed
dbt run --select stage

# 4️⃣ Build intermediate and final models
dbt run --select int+
dbt run --select marts+

# 5️⃣ Run tests & generate docs
dbt test
dbt docs generate && dbt docs serve
