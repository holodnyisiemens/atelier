-- Представление для одного или нескольких заказов
CREATE OR REPLACE VIEW order_info_view AS
SELECT 
    o.id AS "Order ID",
    c.firstname || ' ' || c.lastname || ' (' || c.id || ')' AS "Customer with ID",
    o.created_at AS "Creation date",
    o.deadline AS "Deadline",
    get_order_status(o.id) AS "Status",
    get_order_total_amount(o.id) AS "Total"
FROM orders AS o
JOIN customer c ON c.id = o.customer_id;

-- Представление для состава заказов
CREATE OR REPLACE VIEW order_list_view AS
SELECT
    o.id AS "Order ID",
    c.firstname || ' ' || c.lastname || ' (' || c.id || ')' AS "Customer with ID",
    e.firstname || ' ' || e.lastname || ' (' || e.id || ')' AS "Employee with ID",
    e.experience AS "Employee experience",
    s.title AS "Service",
    s.complexity AS "Complexity",
    s.price || ' x ' || os.count || ' = ' || (s.price * os.count) AS "Price",
    o.deadline AS "Deadline",
    os.status AS "Status"
FROM orders o
JOIN customer c ON c.id = o.customer_id
JOIN order_service os ON os.order_id = o.id
JOIN service s ON s.id = os.service_id
LEFT JOIN employee e ON e.id = os.employee_id;
