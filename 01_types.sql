-- Возможные статусы заказа и услуг в заказе
CREATE TYPE work_status AS ENUM ('new', 'in_progress', 'done', 'cancelled');
