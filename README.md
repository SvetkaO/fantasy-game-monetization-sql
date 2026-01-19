# fantasy-game-monetization-sql
SQL analysis of player behavior and in-game monetization in a fantasy game, focusing on paying users, purchase activity, and revenue metrics.

In-Game Purchases & Player Behavior Analysis (SQL)
📌 Project Overview

This project analyzes player behavior and in-game purchase activity in the fantasy game “Secrets of the Dark Forest”.

The main objective is to understand how player and character attributes influence:

* The likelihood of making purchases

* Spending behavior

* In-game revenue distribution

* The analysis focuses on monetization metrics and player engagement patterns.

⸻

📂 Dataset Description

The database contains information about:

* Players and their attributes (payer flag, character race)

* In-game purchase events

* Purchase amounts and transaction details

* In-game items available for purchase

⸻

🎯 Business Questions

The project answers the following key questions:

- What proportion of players make in-game purchases?

- How does the share of paying users vary by character race?

- What are the statistical characteristics of in-game purchases?

- Are zero-value purchases present in the data?

- Which in-game items generate the highest purchase activity?

- How does player activity and monetization differ by race?

⸻
   

🧹 Data Exploration & Quality Checks

- Evaluated the distribution of purchase amounts

- Identified zero-value (anomalous) purchases

- Calculated median, average, and standard deviation for transaction values

Differentiated between:

- Registered players

- Buyers (players with at least one purchase)

- Paying users

⸻

🧠 Analytical Approach
Part 1: Exploratory Data Analysis

* Calculated overall and race-based shares of paying players

* Analyzed purchase amount statistics

* Identified the most popular epic items

* Measured player-level participation in item purchases

Part 2: Ad Hoc Analysis

* Compared player activity across character races

Calculated:

* Buyer conversion rate

* Share of paying users among buyers

* Average number of purchases per player

* Average revenue per purchase

* Average revenue per player

⸻

🛠 SQL Techniques Used

• Common Table Expressions (CTEs)

• Aggregations and conditional logic

• COUNT(DISTINCT ...)

• Percentile calculations

• Revenue and conversion metrics

• Division safety using NULLIF

• Business-oriented metric calculations

⸻

📊 Key Insights

• Only a subset of registered players actively make in-game purchases

• Monetization behavior differs significantly across character races

• A small group of buyers generates a large share of total revenue

• Certain epic items dominate purchase activity

• Paying users show higher engagement and spending intensity

📂 Files
📦 fantasy-game-monetization-sql
