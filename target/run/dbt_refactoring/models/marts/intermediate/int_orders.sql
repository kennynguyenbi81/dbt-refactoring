
  create or replace  view analytics.dbt_knguyen_refactor.int_orders 
  
   as (
    with 

-- Import CTEs
orders as (
    select * from analytics.dbt_knguyen_refactor.stg_jaffle_shop__orders
),
payments as (
    select * from analytics.dbt_knguyen_refactor.stg_stripe__payments
    where payment_status != 'fail'
),
-----------
order_totals as (
    select
        order_id,
        payment_status,
        sum(payment_amount) as order_value_dollars
    from payments
    group by 1, 2
),
order_value_joined as (
    select
        orders.*,
        order_totals.payment_status,
        order_totals.order_value_dollars
    from orders
    left join order_totals
        on orders.order_id = order_totals.order_id
)
select * from order_value_joined
  );
