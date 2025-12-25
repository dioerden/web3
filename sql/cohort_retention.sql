/*
    Cohort Analysis & Retention SQL (Cleaned)
    Target: Dune Analytics V2 / Flipside Crypto (Snowflake)
    Protocol: Example GameFi (e.g., Pixels)
*/

WITH raw_activity AS (
    -- Extract all user interactions
    SELECT 
        "from" AS user_address,
        date_trunc('week', block_time) AS activity_week,
        block_time,
        hash
    FROM 
         -- Replace with specific project contract (e.g., ronin.pixels_trace)
         evm_chain.transactions 
    WHERE 
        to IN ('0xCoreContract1', '0xCoreContract2') 
        AND block_time > now() - interval '6 months'
),

bot_filter AS (
    -- Filter logic: Exclude users with barely any activity (likely bots/claimers)
    SELECT 
        user_address 
    FROM 
        raw_activity
    GROUP BY 
        1
    HAVING 
        count(*) > 5  -- Minimum 5 transactions lifetime
),

cohorts AS (
    -- Determine the "Join Week" for each valid user
    SELECT 
        r.user_address,
        min(r.activity_week) AS join_week
    FROM 
        raw_activity r
    JOIN 
        bot_filter b ON r.user_address = b.user_address
    GROUP BY 
        1
),

retention_base AS (
    -- Calculate weeks elapsed since joining for every activity
    SELECT 
        c.user_address,
        c.join_week,
        r.activity_week,
        FLOOR(EXTRACT(EPOCH FROM (r.activity_week - c.join_week)) / 604800) AS week_number
    FROM 
        raw_activity r
    JOIN 
        cohorts c ON r.user_address = c.user_address
    GROUP BY 
        1, 2, 3
)

-- Final Output: Cohort Retention Table
SELECT 
    join_week,
    count(DISTINCT CASE WHEN week_number = 0 THEN user_address END) AS cohort_size,
    
    -- Retention Rates (Week 1 to Week 8)
    count(DISTINCT CASE WHEN week_number = 1 THEN user_address END) * 100.0 / count(DISTINCT CASE WHEN week_number = 0 THEN user_address END) AS week_1_retention,
    count(DISTINCT CASE WHEN week_number = 2 THEN user_address END) * 100.0 / count(DISTINCT CASE WHEN week_number = 0 THEN user_address END) AS week_2_retention,
    count(DISTINCT CASE WHEN week_number = 4 THEN user_address END) * 100.0 / count(DISTINCT CASE WHEN week_number = 0 THEN user_address END) AS week_4_retention,
    count(DISTINCT CASE WHEN week_number = 8 THEN user_address END) * 100.0 / count(DISTINCT CASE WHEN week_number = 0 THEN user_address END) AS week_8_retention

FROM 
    retention_base
WHERE 
    join_week < date_trunc('week', now()) -- Exclude incomplete current week
GROUP BY 
    1
ORDER BY 
    1 DESC
