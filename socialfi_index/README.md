# SocialFi Real User Index: Farcaster Analysis

> **VC Thesis:** "Is the recent growth in Farcaster driven by genuine social interaction (Quality) or merely airdrop farming (Noise)?"

## 📂 Project Overview
This project performs a due diligence analysis on **Farcaster (Base)** using On-Chain Data. We built a custom **"Real User Index"** to filter out bot activity and measure true organic retention.

### Key Deliverables
1.  **[VC Thesis](analysis/vc_thesis.md)**: Our hypothesis on why "Power User Curves" matter more than DAU.
2.  **[Retention Heatmap (SQL)](sql/retention_heatmap.sql)**: Dune-compatible query to visualize user cohorts over 12 months.
3.  **[Bot Detection Algo (SQL)](sql/bot_detection.sql)**: Logic to flag wallets with high-frequency spam behavior.

## 📊 Findings (Simulated)
*   **Vanity Metric:** 100k+ Registered IDs.
*   **Reality:** Only 12% of users are "Middle Class" (posting >3 times/week).
*   **Verdict:** **Bullish**. Despite the bot noise, the core retention of 12% is significantly higher than competitor SocialFi apps.

## 🛠 Tech Stack
*   **Data Source**: Dune Analytics (`dune.neynar.dataset_farcaster_casts`)
*   **Language**: Trino SQL (Dune SQL)
*   **Framework**: VC Due Diligence

---
*Query designed for [Dune Analytics](https://dune.com).*
