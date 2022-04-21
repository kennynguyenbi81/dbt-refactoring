
  create or replace  view analytics.dbt_knguyen_refactor.stg_jaffle_shop__orders 
  
   as (
    with
source as (
    select * from raw.jaffle_shop.orders
),
transformed as (
    select 
        id as order_id,
        user_id as customer_id,
        order_date,
        status as order_status,
        case 
            when order_status not in ('returned','return_pending') 
                then order_date 
        end as valid_order_date,
        row_number() over (
                        partition by user_id 
                        order by order_date, id) as user_order_seq
    from source
)
select * from transformed
  );
