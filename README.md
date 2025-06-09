# Emergency-Pipeline 🚑

## 🚀 Pipeline Overview

An end‑to‑end data engineering pipeline built on **Google Cloud Platform** to deliver monthly insights into emergency care performance:

- ⏱️ Automated ingestion of NHS A&E data (April 2020 – March 2025)
- 🧱 Transformed with **dbt** into staging, core, and fact models (includes primary keys and source tests)
- 🗃️ Materialized to **BigQuery**, partitioned by `year_month` and clustered by organization
- 📊 Visualized via **Looker Studio** with interactive dashboards

The output supports downstream use cases such as:
- 📉 Building performance dashboards for hospital operations teams  
- 📊 Tracking regional emergency pressures over time  
- 🔁 Supporting data-driven decisions on resource allocation

---

## 🧰 Tech Stack

![image](https://github.com/user-attachments/assets/332be1b1-0235-4050-ba2f-496bff5e435a)

- **Google Cloud Platform (GCP)**: Used for cloud infrastructure, including **BigQuery** (data warehouse) and **Cloud Storage** (data lake).
- **dbt (Data Build Tool)**: For ELT modeling, building staging and core models with modular SQL.
- **Looker Studio**: Used to create interactive BI dashboards for A&E trend analysis.
- **Terraform + Docker**: (Optional) Used to provision cloud infrastructure and containerize workflows for reproducibility.
- **Python**: Used for data ingestion, web scraping, and pipeline automation.

---

## ☁️ Cloud Setup

This project leverages **Terraform** to provision cloud resources efficiently. This ensures that infrastructure deployments are reproducible, scalable, and maintainable.

Steps:
- The first step is to create a project on **Google Cloud Platform (GCP)**.
- Next, use Terraform to create a **Google Cloud Storage (GCS)** bucket and a **BigQuery** dataset to store the required data.
- If you encounter issues with GCS, make sure your service account `.json` file is correctly configured. Alternatively, you can create the resources manually in the GCP Console.

![image](https://github.com/user-attachments/assets/9f95cf4c-4efb-4485-8f71-afe047378801)  
![image](https://github.com/user-attachments/assets/2eaab7bb-46f8-4c67-b275-c8c1d1c4eb08)

---

## 📥 Data Ingestion

A batch ingestion pipeline was created to retrieve monthly data from the **NHS England website**.

- The data covers the period from **April 2020 to March 2025**.
- You can automate this process using **Kestra**, or use the provided Python script.
- The script is available in `ae_data_ingestion.ipynb`, which fetches and processes raw CSV files from the NHS website.
  
---

## 🏗️ Data Warehouse

The raw data was first uploaded to a **Google Cloud Storage bucket**, and then loaded into **BigQuery**.

To improve query performance and reduce cost:
- ✅ The table was **partitioned by `year_month`** to enable efficient filtering.
- ✅ It was also **clustered by `Parent_Org` and `Org_name`** to optimize scans on categorical dimensions.

![Partition and Clustering](https://github.com/user-attachments/assets/024dd162-d430-47f7-9de3-6a372ed6f5a7)

---

### 🧱 dbt Modeling Workflow

1. **Project setup**
   - Define your project name in `dbt_project.yml`.
   - Create a `models/staging` directory and define your source tables in `models/staging/schema.yml`.

   ![dbt Source Setup](https://github.com/user-attachments/assets/73876317-718d-41b2-8257-ddb1977af388)

2. **Package installation**
   - Visit [dbt Hub](https://hub.getdbt.com/) to explore reusable macros (e.g., `dbt_utils`).
   - Create a `packages.yml` and add your desired packages.
   - Run `dbt deps` to install dependencies under the `dbt_packages` directory.

3. **Modeling best practices**
   - Use macros like `generate_surrogate_key` to ensure each record has a **unique ID** and maintain correct grain.

   ![Macro](https://github.com/user-attachments/assets/f068ec70-9bea-4826-9c8b-99bc286f3479)

4. **Seeding lookup tables**
   - Place reusable lookup tables (e.g., `lookup.csv`) in the `seeds/` directory.
   - Run `dbt seed` to load them into BigQuery.
   - Make sure the CSV has no extra blank lines or formatting issues.

5. **Building core models**
   - Use `models/core/` to define `dim_` and `fact_` tables using references to staging and lookup layers.
   - Run `dbt build` to compile and materialize all models with upstream dependencies.

   ![Core Model DAG](https://github.com/user-attachments/assets/c01cdf68-d516-448f-91cf-65daa25cc47d)

---

## 📊 Data Visualization in Looker Studio

This project leverages **Looker Studio** to create an interactive dashboard with three key visualizations that provide insight into healthcare resource usage and system pressure. These charts empower stakeholders to make data-driven operational decisions.

### 1. Record Volume Trend (Monthly)

This chart presents the monthly trend of A&E attendance records over a multi-year period.  
Users can hover over each point to view exact volumes per month. A slight downward trend suggests changes in reporting behavior or a shift in patient volume, and may help identify early indicators of reduced emergency demand.

![image](https://github.com/user-attachments/assets/ea3c4a1e-6bfb-4abb-bec3-e6a6dbf469aa)

### 2. Emergency Pressure Trend

This multi-line chart tracks three key indicators over time:
- Total A&E attendances
- Attendances with wait times over 4 hours
- Emergency admissions

The chart reveals that while total attendance remains high and stable, 4+ hour delays fluctuate moderately, and emergency admissions stay relatively low — indicating that operational pressure is driven more by **wait time management** than by **inpatient capacity**.

![image](https://github.com/user-attachments/assets/88cbaf28-99b6-42a3-96a3-bbc48fb3f3f4)

### 3. Regional Comparison (Interactive Bar Chart)

This chart compares NHS organizations based on two key emergency care performance metrics:
- % of attendances exceeding 4-hour wait times  
- % of attendances leading to emergency admissions  

Users can filter by **organization** and **month** to assess operational pressure and performance differences across regions and time. This visualization supports targeted resource allocation and service optimization.

![image](https://github.com/user-attachments/assets/9977054e-bbae-41b5-8ff0-bf85b295f061)

### 🔗 Dashboard Demo

[👉 View the interactive dashboard in Looker Studio](https://lookerstudio.google.com/u/0/reporting/90748a94-e924-4b60-81b4-31dcdadd3ece/page/g57MF?hl=en)

---

## 🎯 Purpose & Learning Outcomes

This project replicates a real-world, end-to-end data engineering workflow:
- Ingesting and transforming raw data at scale
- Writing modular and maintainable dbt models
- Building business-facing BI layers with clear value
- Thinking from a stakeholder and decision-maker perspective

---

## 🧠 Key Highlights

- ✅ **Macro-driven modeling** using `generate_surrogate_key` for robust primary keys
- ✅ **Clear data lineage** with dbt DAG: `source → stg_all → fact_org`
- ✅ **Automated enrichment** via seed-based dimensional lookups
- ✅ **Interactive BI dashboard** for monthly and regional insights into emergency pressures


