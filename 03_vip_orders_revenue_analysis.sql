/*******************************************************************************
 * SCRIPT NAME : 03_vip_orders_revenue_analysis.sql
 * PURPOSE     : Analyze high-value (VIP) customer orders, product tier 
 *               distribution, and cumulative revenue contribution.
 * DIALECT     : Standard ANSI SQL (PostgreSQL / MySQL 8.0+ / Snowflake)
 * AUTHOR      : Data Analytics Team
 * DATE        : 2026-07-22
 * -----------------------------------------------------------------------------
 * BUSINESS CONTEXT:
 * Executive management requires visibility into top-tier orders to evaluate:
 *   1. Order value and product tier composition (High-tier > $100 vs. Low-tier <= $100).
 *   2. Order position based on gross revenue.
 *   3. Running cumulative contribution of these top orders to total revenue.
 ******************************************************************************/

-- Step 1: Aggregate order-level metrics and segment product tiers
WITH aggregated_order_summary AS (
    SELECT
        order_id,
        ROUND(SUM(price), 2) AS total_order_value,
        -- Conditional aggregations for product tier classification
        COUNT(CASE WHEN price > 100.00 THEN 1 END) AS high_tier_item_count,
        COUNT(CASE WHEN price <= 100.00 THEN 1 END) AS low_tier_item_count
    FROM order_items
    GROUP BY 
        order_id
),

-- Step 2: Compute dense ranking and running cumulative revenue
ranked_order_metrics AS (
    SELECT
        order_id,
        total_order_value,
        high_tier_item_count,
        low_tier_item_count,
        -- Rank orders by revenue without gaps in rank values
        DENSE_RANK() OVER (
            ORDER BY total_order_value DESC
        ) AS order_rank,
        -- Explicit frame definition for cumulative running total
        ROUND(
            SUM(total_order_value) OVER (
                ORDER BY total_order_value DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ), 2
        ) AS cumulative_revenue
    FROM aggregated_order_summary
)

-- Step 3: Final output query retrieving the top 10 orders by gross value
SELECT 
    order_rank,
    order_id,
    total_order_value,
    high_tier_item_count,
    low_tier_item_count,
    cumulative_revenue
FROM ranked_order_metrics
WHERE order_rank <= 10
ORDER BY order_rank ASC;
