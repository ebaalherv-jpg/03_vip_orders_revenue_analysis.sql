<?xml version="1.0" encoding="UTF-8"?><sqlb_project><db path="C:/Users/ejalf/OneDrive/Documentos/tabla2.db" readonly="0" foreign_keys="1" case_sensitive_like="0" temp_store="0" wal_autocheckpoint="1000" synchronous="2"/><attached/><window><main_tabs open="structure browser pragmas query" current="3"/></window><tab_structure><column_width id="0" width="300"/><column_width id="1" width="0"/><column_width id="2" width="100"/><column_width id="3" width="1825"/><column_width id="4" width="0"/><expanded_item id="0" parent="1"/><expanded_item id="1" parent="1"/><expanded_item id="2" parent="1"/><expanded_item id="3" parent="1"/></tab_structure><tab_browse><table title="orders" custom_title="0" dock_id="2" table="4,6:mainorders"/><dock_state state="000000ff00000000fd0000000100000002000002480000020bfc0100000002fb000000160064006f0063006b00420072006f00770073006500310100000000000002480000000000000000fb000000160064006f0063006b00420072006f00770073006500320100000000ffffffff0000011800ffffff000002480000000000000004000000040000000800000008fc00000000"/><default_encoding codec=""/><browse_table_settings/></tab_browse><tab_sql><sql name="SQL 1*">/*******************************************************************************

 * SCRIPT NAME : 03_vip_orders_revenue_analysis.sql

 * PURPOSE     : Analyze high-value (VIP) customer orders, product tier 

 *               distribution, and cumulative revenue contribution.

 * DIALECT     : Standard ANSI SQL (PostgreSQL / MySQL 8.0+ / Snowflake)

 * AUTHOR      : Data Analytics Team

 * DATE        : 2026-07-22

 * -----------------------------------------------------------------------------

 * BUSINESS CONTEXT:

 * Executive management requires visibility into top-tier orders to evaluate:

 *   1. Order value and product tier composition (High-tier &gt; $100 vs. Low-tier &lt;= $100).

 *   2. Order position based on gross revenue.

 *   3. Running cumulative contribution of these top orders to total revenue.

 ******************************************************************************/



-- Step 1: Aggregate order-level metrics and segment product tiers

WITH aggregated_order_summary AS (

    SELECT

        order_id,

        ROUND(SUM(price), 2) AS total_order_value,

        -- Conditional aggregations for product tier classification

        COUNT(CASE WHEN price &gt; 100.00 THEN 1 END) AS high_tier_item_count,

        COUNT(CASE WHEN price &lt;= 100.00 THEN 1 END) AS low_tier_item_count

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

WHERE order_rank &lt;= 10

ORDER BY order_rank ASC;</sql><current_tab id="0"/></tab_sql></sqlb_project>
