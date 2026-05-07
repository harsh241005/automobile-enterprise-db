Indian Automobile Enterprise Database — Oracle SQL

A fully normalized 19-table relational database modeling the complete Indian automobile manufacturing ecosystem — from company hierarchy and vehicle configuration to dealership sales pipeline, supply chain traceability, and a PHP web portal for real-time inventory search.

![ER Diagram](docs/automobile_erd.jpeg)

Database Architecture
The schema models a real-world automobile enterprise across 6 dependency layers:
LayerTablesPurposeFoundationCompany, Colours, Engine, Transmission, Bodystyle, Supplier, Parts, PlantIndependent reference entitiesHierarchyBrand, Model, Dealer, Customer, Serializing_PartDepend on foundation tablesConfigurationModel_Colour, Model_Engine, Model_Transmission, Model_PartsJunction tables with composite keys for valid vehicle configurationsInventoryVehicleComposite foreign keys ensuring only valid colour/engine/transmission combos per modelSalesSold_VehicleTracks customer purchases with VIN uniqueness constraint
Key Design Decisions
Company → Brand → Model hierarchy: Reflects how Indian auto companies operate (e.g., Tata Motors → Tata → Nexon, Harrier, Safari).
Body style as a Model attribute, not a junction table: A Swift is always a Hatchback, a Fortuner is always an SUV. Body style is fixed per model, not a customer choice like colour or engine — so it's a direct FK in the Model table, not a many-to-many relationship.
Composite foreign keys in Vehicle: The Vehicle table references (model_id, colour_id), (model_id, engine_id), and (model_id, transmission_id) — ensuring a vehicle can only be configured with options that actually exist for that model. You can't accidentally assign a diesel engine to a model that only comes in petrol.
Serializing_Part with VIN tracing: Every serialized part links back to the specific vehicle it was installed in, enabling full supply chain traceability from supplier → batch → vehicle.
Indian Brands Covered
CompanyBrandsModelsTata MotorsTataNexon, Harrier, SafariMahindraMahindraThar, XUV700Maruti SuzukiMarutiSwift, DzireHyundai Motor IndiaHyundaiCreta, i20Toyota KirloskarToyotaFortunerHonda Cars IndiaHondaCityKia IndiaKiaSeltosMG Motor IndiaMGHectorRenault IndiaRenaultKwid
DriveNet — PHP Inventory Portal
A full-stack web application built with PHP (Oracle OCI8) and Bootstrap 5 that provides a real-time vehicle inventory search across the dealer network.
Features:

Dynamic dropdowns populated from live database (models and dealer locations)
Parameterized queries with oci_bind_by_name to prevent SQL injection
Filters only unsold vehicles using a LEFT JOIN on Sold_Vehicle
Dark-themed UI with Bootstrap 5, Bebas Neue typography, and gold accent design system
Colour-coded fuel type badges (Petrol, Diesel, Hybrid, Electric, CNG)
Responsive design for mobile and desktop

Screenshots
Show Image
Show Image

Rename your screenshot files to match the names above, or update these image paths to match your actual filenames.

OLAP Analytics (10 Queries)
Advanced SQL queries using ROLLUP, RANK, DENSE_RANK, and window functions:
#QuerySQL FeatureKey Finding1Revenue by CompanyROLLUPToyota Kirloskar leads at ₹45L (1 unit — Fortuner)2Revenue by Body StyleROLLUPSUVs dominate with ₹1.10Cr (63% of total revenue)3Cumulative Revenue Over TimeWindow SUMRevenue accelerates in May with premium SUV sales4Customer Income RankingRANKTop 4 earners are all female customers5Gender AnalysisROLLUP + AGGFemale customers earn ₹7.9L avg vs ₹6.13L for males6Sold vs Unsold InventoryLEFT JOIN + ROLLUP10 of 15 vehicles sold (67% sell-through rate)7Colour PopularityDENSE_RANKWhite dominates with 6 vehicles (40% of inventory)8Parts per SupplierROLLUPTop 5 suppliers each supply 2 parts; 5 supply 1 each9Most Used PartsDENSE_RANKBrake is universal (12 models); Gearbox and Battery tied at rank #210SUV Buyer ProfileMulti-JOIN4 SUV buyers spent ₹1.10Cr total, avg ₹27.5L per vehicle
Visualizations
All 10 queries visualized with a dark neon theme using Python matplotlib:
Revenue by Company
Show Image
Revenue by Body Style
Show Image
Cumulative Revenue Over Time
Show Image
Customer Income Ranking
Show Image
Gender Analysis
Show Image
Sold vs Unsold Inventory
Show Image
Colour Popularity
Show Image
Parts per Supplier
Show Image
Most Used Parts
Show Image
SUV Buyers
Show Image
Project Structure
automobile-enterprise-db/
├── README.md
├── requirements.txt
├── sql/
│   ├── 01_schema.sql              # 19 CREATE TABLE statements with constraints
│   ├── 02_inserts.sql             # Sample data for all tables
│   └── 03_olap_queries.sql        # 10 analytical queries
├── web/
│   ├── db_connect.php             # Oracle OCI8 database connection
│   └── search.php                 # DriveNet Inventory Portal (full-stack)
├── visualizations/
│   ├── olap_charts.py             # Python matplotlib script (dark neon theme)
│   ├── q1_revenue_by_company.jpeg
│   ├── q2_revenue_by_bodystyle.jpeg
│   ├── q3_cumulative_revenue.jpeg
│   ├── q4_customer_income_rank.jpeg
│   ├── q5_gender_analysis.jpeg
│   ├── q6_sold_vs_unsold.jpeg
│   ├── q7_colour_popularity.jpeg
│   ├── q8_parts_per_supplier.jpeg
│   ├── q9_most_used_parts.jpeg
│   └── q10_suv_buyers.jpeg
├── screenshots/
│   └── (DriveNet web app screenshots)
└── docs/
    ├── erd_diagram.jpeg           # Hand-drawn Entity-Relationship Diagram
    └── query_outputs.txt          # Raw SQL*Plus output for all 10 queries
Tech Stack
CategoryToolsDatabaseOracle SQL (SQL Developer)SQL FeaturesDDL, DML, CHECK constraints, composite foreign keys, ROLLUP, RANK, DENSE_RANK, window functionsWeb FrontendPHP 8 (OCI8), Bootstrap 5, HTML5, CSS3VisualizationPython 3, matplotlib, numpyDesignDark neon theme (charts), gold accent dark theme (DriveNet portal)
How to Run
Database Setup

Open Oracle SQL Developer
Run sql/01_schema.sql to create all 19 tables
Run sql/02_inserts.sql to populate sample data
Run sql/03_olap_queries.sql to execute analytics

Visualizations
bashpip install -r requirements.txt
python visualizations/olap_charts.py
DriveNet Web Portal

Install PHP with OCI8 extension
Update credentials in web/db_connect.php
Place files in your web server directory (e.g., XAMPP htdocs)
Open http://localhost/search.php in your browser

Author
Harsh Palyekar — B.Sc. Data Science, Goa University
LinkedIn · GitHub
