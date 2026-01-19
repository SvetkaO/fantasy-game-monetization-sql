/*
 * Project: "Secrets of the Dark Forest"
 * Project goal: to analyze the impact of player and character characteristics
 * on the purchase of in-game currency ("Heavenly Petals"),
 * as well as to evaluate player activity related to in-game purchases.
 

-- Part 1. Exploratory Data Analysis (EDA)
-- Task 1. Analysis of the share of paying players

-- 1.1 Share of paying users across the entire dataset
SELECT 
      COUNT(id) AS total_players,          -- total number of registered players
      SUM(payer) AS paying_players,        -- number of paying players
      AVG(payer) AS paying_share            -- share of paying players among all registered users
FROM fantasy.users;


-- 1.2 Share of paying users by character race
SELECT 
       r.race,
       COUNT(u.id) AS total_players_by_race,   -- total number of registered players of this race
       SUM(u.payer) AS paying_players,         -- number of paying players of this race
       ROUND(SUM(u.payer) * 100.0 / COUNT(u.id), 2) AS paying_share_percent
FROM fantasy.race AS r 
JOIN fantasy.users AS u
  ON u.race_id = r.race_id
GROUP BY r.race
ORDER BY r.race;


-- Task 2. In-game purchases analysis

-- 2.1 Descriptive statistics for the purchase amount
SELECT 
       COUNT(amount) AS total_purchases,
       SUM(amount) AS total_revenue,
       MAX(amount) AS max_purchase_amount,
       MIN(amount) AS min_purchase_amount,
       AVG(amount) AS avg_purchase_amount,
       PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY amount) AS median_purchase_amount,
       STDDEV(amount) AS std_dev_amount
FROM fantasy.events;


-- 2.2 Analysis of anomalous zero-value purchases
SELECT 
       MIN(amount) AS min_amount,    -- check whether zero-value purchases exist
       SUM(CASE WHEN amount = 0 THEN 1 END) AS zero_amount_count, -- absolute count of zero-value purchases
       ROUND(
           SUM(CASE WHEN amount = 0 THEN 1 END) * 100.0 / COUNT(amount),
           2
       ) AS zero_amount_share_percent -- share of zero-value purchases
FROM fantasy.events;


-- 2.3 Most popular epic items
WITH total_paid_users AS (
     SELECT COUNT(DISTINCT e.id) AS total_users
     FROM fantasy.events e 
     WHERE amount > 0
)
SELECT 
       i.game_items,
       COUNT(e.amount) AS total_purchases,  -- absolute number of purchases
       COUNT(e.amount)::FLOAT / SUM(COUNT(e.amount)) OVER () AS purchase_share,
       ROUND(
           COUNT(e.amount) * 100.0 / SUM(COUNT(e.amount)) OVER (),
           2
       ) AS purchase_share_percent,
       COUNT(DISTINCT u.id) AS players_per_item,
       -- Share of players who purchased this item at least once, %
       ROUND(
           COUNT(DISTINCT u.id) * 100.0 / tu.total_users,
           2
       ) AS buyers_share_percent
FROM fantasy.items AS i 
JOIN fantasy.events AS e
  ON i.item_code = e.item_code
JOIN fantasy.users AS u
  ON e.id = u.id
JOIN total_paid_users AS tu ON TRUE
WHERE amount > 0
GROUP BY i.game_items, tu.total_users
ORDER BY total_purchases DESC;


-- Part 2. Ad hoc analysis
-- Task: Player activity dependency on character race

WITH player_count AS (
     SELECT 
            r.race,
            COUNT(u.id) AS total_players   -- total number of registered players
     FROM fantasy.users u 
     JOIN fantasy.race r 
       ON u.race_id = r.race_id 
     GROUP BY r.race
),

buyers AS (
     SELECT 
           r.race,
           COUNT(DISTINCT e.id) AS buyers_count -- number of players who made at least one purchase
     FROM fantasy.users u
     JOIN fantasy.race r 
       ON u.race_id = r.race_id 
     JOIN fantasy.events e 
       ON u.id = e.id 
     WHERE e.amount > 0
     GROUP BY r.race
),

paying_buyers AS (
     SELECT 
           r.race,
           COUNT(DISTINCT u.id) AS paying_buyers_count
     FROM fantasy.users u
     JOIN fantasy.race r 
       ON u.race_id = r.race_id 
     JOIN fantasy.events e 
       ON u.id = e.id 
     WHERE e.amount > 0
       AND u.payer = 1
     GROUP BY r.race
),

purchases AS (
     SELECT 
            r.race,
            COUNT(e.transaction_id) AS total_purchases,
            SUM(e.amount) AS total_revenue
     FROM fantasy.users u 
     JOIN fantasy.race r 
       ON u.race_id = r.race_id 
     JOIN fantasy.events e
       ON u.id = e.id 
     WHERE amount > 0
     GROUP BY r.race
)

SELECT 
       pc.race,
       pc.total_players,
       b.buyers_count,
       ROUND(
           b.buyers_count::NUMERIC / pc.total_players,
           2
       ) AS buyers_share, -- share of players who made purchases
       ROUND(
           pb.paying_buyers_count * 100.0 / b.buyers_count,
           2
       ) AS paying_buyers_share, -- share of paying users among buyers
       ROUND(
           p.total_purchases::NUMERIC / NULLIF(b.buyers_count, 0),
           2
       ) AS avg_purchases_per_player,
       ROUND(
           p.total_revenue::NUMERIC / NULLIF(p.total_purchases, 0),
           2
       ) AS avg_revenue_per_purchase,
       ROUND(
           p.total_revenue::NUMERIC / NULLIF(b.buyers_count, 0),
           2
       ) AS avg_revenue_per_player
FROM player_count pc
LEFT JOIN buyers b
  ON pc.race = b.race
LEFT JOIN paying_buyers pb
  ON pc.race = pb.race
LEFT JOIN purchases p
  ON pc.race = p.race
ORDER BY buyers_count DESC;
