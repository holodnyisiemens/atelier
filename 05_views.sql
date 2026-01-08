-- Удобное представление одного или нескольких заказов
CREATE OR REPLACE VIEW order_info_view AS
SELECT 
    o.id AS order_id,
    c.id AS "Customer ID",
    c.firstname || ' ' || c.lastname AS "Customer name",
    o.created_at AS "Creation date",
    o.deadline AS "Deadline",
    get_order_status(o.id) AS "Status",
    get_order_total_amount(o.id) AS "Total"
FROM orders AS o
JOIN customer c ON c.id = o.customer_id;
