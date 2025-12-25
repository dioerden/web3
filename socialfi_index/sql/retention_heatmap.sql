/*
    Farcaster User Retention Heatmap (Monthly)
    Target: Dune Analytics (Dune SQL)
    Dataset: dune.neynar.dataset_farcaster_casts
*/

WITH first_actions AS (
    -- Determine the first time every user ever casted
    SELECT 
        fid,
        min(timestamp) as first_cast_time
    FROM 
        dune.neynar.dataset_farcaster_casts
    GROUP BY 
        1
),

cohorts AS (
    -- Group users into monthly cohorts based on their first cast
    SELECT 
        fid,
        date_trunc('month', first_cast_time) as cohort_month
    FROM 
        first_actions
    WHERE 
        first_cast_time > (now() - interval '1' year) -- Last 12 months only
),

activity AS (
    -- Check activity in subsequent months
    SELECT 
        c.fid,
        c.cohort_month,
        date_trunc('month', fc.timestamp) as activity_month,
        date_diff('month', c.cohort_month, date_trunc('month', fc.timestamp)) as months_since_join
    FROM 
        cohorts c
    JOIN 
        dune.neynar.dataset_farcaster_casts fc ON c.fid = fc.fid
    GROUP BY 
        1, 2, 3, 4
)

-- Final Heatmap Output
-- Copy this dataset into Dune Visualization -> Heatmap
SELECT 
    cohort_month,
    -- Format as string for cleaner Pivot Table column headers
    'Month ' || CAST(months_since_join AS VARCHAR) as month_label,
    months_since_join as month_num,
    COUNT(DISTINCT fid) as retained_users,
    
    -- Calculate retention % relative to Month 0
    COUNT(DISTINCT fid) * 100.0 / MAX(COUNT(DISTINCT fid)) OVER (PARTITION BY cohort_month) as retention_rate
FROM 
    activity
WHERE 
    months_since_join >= 0
GROUP BY 
    cohort_month, 
    months_since_join
ORDER BY 
    cohort_month DESC, month_num ASC
```
