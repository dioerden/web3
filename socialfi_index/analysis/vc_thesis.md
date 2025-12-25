# VC Thesis: The SocialFi "Real User" Index
**Target Protocol:** Farcaster (Base)
**Date:** 2024-05-21

## 1. The Core Question
> *"Is the recent growth in Farcaster driven by genuine social interaction (Quality) or merely airdrop farming (Noise)?"*

As a VC, we don't buy "Total Users." We buy **Network Effects**. If 90% of users are bots echoing each other to farm $DEGEN, the network effect is zero.

## 2. The "Power User" Hypothesis (80/20 Rule)
We hypothesize that a healthy SocialFi protocol must have a **"Middle Class"** of users—not just a few influencers and millions of lurkers/bots.

*   **Metric:** `Power User Curve (L30)`
*   **Definition:** Distribution of users by number of casts in the last 30 days.
*   **Target:** >15% of DAU should cast >3 times/week (The "Engaged" Layer).

## 3. Bot Detection Methodology (Sybil Filter)
We treat the data by filtering out wallets that exhibit "Inorganic Behavior":
1.  **Temporal Clustering:** Wallets created within the same 60-second window.
2.  **Dispenser Funding:** Wallets funded by the same parent address (e.g., CEX hot wallets are excluded, but personal multi-sends are flagged).
3.  **Low Effort:** Users with 0 casts but high token claiming activity.

## 4. Investment Verdict (Simulated)
*   **Raw Retention (Month 2):** 25% (Looks great on paper).
*   **Cleaned Retention (Bot-Filtered):** 12%
*   **Conclusion:** While lower than the vanity metric, a 12% organic retention for a *crypto social* app is actually **Best-in-Class** (compared to Lens at ~5% or Friend.tech at <2%). This suggests real product-market fit among a core niche.
