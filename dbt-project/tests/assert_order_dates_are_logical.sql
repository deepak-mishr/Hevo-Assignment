-- This test ensures that the first order date is never after the most recent order date.
-- If this query returns ANY rows, the test fails.
select
    customer_id,
    first_order_date,
    most_recent_order_date
from {{ ref('customers') }}
where first_order_date > most_recent_order_date
