-- Функция перерасчета поля updated_at при обновлении строки
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS trigger AS $$
BEGIN
    NEW.updated_at := now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Функция вычисления статуса заказа по статусам его услуг
CREATE OR REPLACE FUNCTION get_order_status(id_order INT)
RETURNS work_status AS $$
DECLARE
    cnt_new INT;
    cnt_in_progress INT;
    cnt_done INT;
    cnt_cancelled INT;
    total_count INT;
    result work_status;
BEGIN
    -- Считаем количество услуг по каждому статусу
    SELECT 
        COUNT(*) FILTER (WHERE status = 'new'),
        COUNT(*) FILTER (WHERE status = 'in_progress'),
        COUNT(*) FILTER (WHERE status = 'done'),
        COUNT(*) FILTER (WHERE status = 'cancelled')
    INTO cnt_new, cnt_in_progress, cnt_done, cnt_cancelled
    FROM order_service
    WHERE order_id = id_order;

    total_count := cnt_new + cnt_in_progress + cnt_done + cnt_cancelled;

    IF total_count = 0 THEN
        -- В заказе нет услуг
        result := 'new';
    ELSIF cnt_done = total_count THEN
        -- Все услуги в заказе выполнены
        result := 'done';
    ELSIF cnt_cancelled = total_count THEN
        -- Все услуги в заказе отменены
        result := 'cancelled';
    ELSIF cnt_new = total_count THEN
        -- Все услуги в заказе новые
        result := 'new';
    ELSE
        -- В остальных случаях заказ в процессе
        result := 'in_progress';
    END IF;

    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Функция расчета суммы заказа
CREATE OR REPLACE FUNCTION get_order_total_amount(id_order INT)
RETURNS NUMERIC(10,2) AS $$
DECLARE
    total_amount NUMERIC(10,2);
BEGIN
    SELECT COALESCE(SUM(s.price * os.count), 0)
    INTO total_amount
    FROM order_service os
    JOIN service s ON s.id = os.service_id
    WHERE os.order_id = id_order;

    RETURN total_amount;
END;
$$ LANGUAGE plpgsql;

-- Проверка активности сотрудника перед назначением выполнения услуги
CREATE OR REPLACE FUNCTION check_employee_active()
RETURNS TRIGGER AS $$
BEGIN
    -- Если сотрудник не назначается — пропускаем
    IF NEW.employee_id IS NULL THEN
        RETURN NEW;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM employee e
        WHERE e.id = NEW.employee_id
          AND e.is_active = true
    ) THEN
        RAISE EXCEPTION
            'Employee % is inactive and cannot be assigned to services',
            NEW.employee_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Отправка уведомлений сотрудникам при изменении данных заказов
CREATE OR REPLACE FUNCTION notify_employee_assigned()
RETURNS TRIGGER AS $$
DECLARE
    service_title TEXT;
BEGIN
    SELECT s.title
    INTO service_title
    FROM service s
    WHERE s.id = NEW.service_id;

    -- INSERT
    IF TG_OP = 'INSERT' THEN
        IF NEW.employee_id IS NOT NULL THEN
            INSERT INTO notification (employee_id, message)
            VALUES (
                NEW.employee_id,
                format(
                    '(Заказ #%s) Вам назначена услуга "%s"',
                    NEW.order_id,
                    service_title
                )
            );
        END IF;

        RETURN NEW;
    END IF;

    -- UPDATE
    IF TG_OP = 'UPDATE' THEN
        -- При назначении услуги
        IF OLD.employee_id IS NULL AND NEW.employee_id IS NOT NULL THEN
            INSERT INTO notification (employee_id, message)
            VALUES (
                NEW.employee_id,
                format(
                    '(Заказ #%s) Вам назначена услуга "%s"',
                    NEW.order_id,
                    service_title
                )
            );

        -- При снятии
        ELSIF OLD.employee_id IS NOT NULL AND NEW.employee_id IS NULL THEN
            INSERT INTO notification (employee_id, message)
            VALUES (
                OLD.employee_id,
                format(
                    '(Заказ #%s) С вас снята услуга "%s"',
                    NEW.order_id,
                    service_title
                )
            );

        -- При переназначении
        ELSIF OLD.employee_id IS NOT NULL
          AND NEW.employee_id IS NOT NULL
          AND OLD.employee_id <> NEW.employee_id THEN

            -- Уведомление тому, с кого сняли
            INSERT INTO notification (employee_id, message)
            VALUES (
                OLD.employee_id,
                format(
                    '(Заказ #%s) С вас снята услуга "%s"',
                    NEW.order_id,
                    service_title
                )
            );

            -- Уведомление тому, кому назначили
            INSERT INTO notification (employee_id, message)
            VALUES (
                NEW.employee_id,
                format(
                    '(Заказ #%s) Вам назначена услуга "%s"',
                    NEW.order_id,
                    service_title
                )
            );

        -- Уведомление при обновлении других полей
        ELSIF OLD.employee_id = NEW.employee_id
          AND NEW.employee_id IS NOT NULL THEN

            INSERT INTO notification (employee_id, message)
            VALUES (
                NEW.employee_id,
                format(
                    '(Заказ #%s) Обновлена услуга "%s"',
                    NEW.order_id,
                    service_title
                )
            );
        END IF;

        RETURN NEW;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
