-- Триггеры автообновления поля updated_at при изменении строк
DROP TRIGGER IF EXISTS trg_set_updated_at_employee ON employee;
CREATE TRIGGER trg_set_updated_at_employee
BEFORE UPDATE ON employee
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_set_updated_at_service ON service;
CREATE TRIGGER trg_set_updated_at_service
BEFORE UPDATE ON service
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_set_updated_at_customer ON customer;
CREATE TRIGGER trg_set_updated_at_customer
BEFORE UPDATE ON customer
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_set_updated_at_orders ON orders;
CREATE TRIGGER trg_set_updated_at_orders
BEFORE UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_set_updated_at_order_service ON order_service;
CREATE TRIGGER trg_set_updated_at_order_service
BEFORE UPDATE ON order_service
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_set_updated_at_notification ON notification;
CREATE TRIGGER trg_set_updated_at_notification
BEFORE UPDATE ON notification
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- Триггер проверки активности сотрудника перед назначением ему выполнения услуги
CREATE TRIGGER trg_check_employee_active
BEFORE INSERT OR UPDATE OF employee_id
ON order_service
FOR EACH ROW
EXECUTE FUNCTION check_employee_active();
