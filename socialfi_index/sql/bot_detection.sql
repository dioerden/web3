/*
    Farcaster Bot/Sybil Detector (Heuristic)
    Logic: Identify "Spam" casters with high volume but low engagement
*/

WITH user_stats AS (
    SELECT 
        fid,
        count(hash) as total_casts,
        count(distinct parent_hash) as replies_made,
        min(block_time) as first_seen,
        max(block_time) as last_seen
    FROM 
        dune.neynar.dataset_farcaster_casts
    WHERE 
        block_time > now() - interval '30' day -- Analyze last 30 days
    GROUP BY 
        1
),

suspicious_flags AS (
    SELECT 
        fid,
        total_casts,
        replies_made,
        
        CASE 
            WHEN total_casts > 500 AND replies_made = 0 THEN 'Spam Bot (Broadcast Only)'
            WHEN total_casts > 1000 THEN 'Hyper-Active (Likely Bot)'
            WHEN total_casts < 5 THEN 'Lurker / Low Value'
            ELSE 'Organic'
        END as user_label
    FROM 
        user_stats
)

-- Summary of Network Health
SELECT 
    user_label,
    count(fid) as user_count,
    count(fid) * 100.0 / (select count(*) from user_stats) as percentage
FROM 
    suspicious_flags
GROUP BY 
    1
ORDER BY 
    2 DESC
