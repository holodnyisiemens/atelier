-- Возможные статусы услуги в заказе
CREATE TYPE service_status AS ENUM ('new', 'in_progress', 'done', 'cancelled');

-- Возможные статусы заказа
CREATE TYPE order_status AS ENUM ('new', 'in_progress', 'done', 'cancelled');
