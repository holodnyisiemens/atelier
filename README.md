# Система учета в ателье

## Настройка

Устанавливаем PostgreSQL в соответствии с инструкцией https://www.postgresql.org/download/

Клонируем репозиторий:
```sh
git clone https://github.com/holodnyisiemens/atelier.git
```

Переходим в рабочую директорию:
```sh
cd atelier
```

### Linux

Заходим в psql:
```sh
sudo -u postgres psql
```

Создаем базу данных:
```postgresql
CREATE DATABASE atelier;
```

Устанавливаем временную зону:
```postgresql
ALTER DATABASE atelier SET TIMEZONE TO 'Asia/Yekaterinburg';
```

Подключаемся к созданной БД:
```postgresql
\c atelier
```

Инициализируем схему БД:
```postgresql
\i init_all.sql
```

## Использование

### Вывод услуг и заказов

Список всех заказов:
```postgresql
SELECT * FROM order_info_view;
```

Список всех невыполненных и неотмененных заказов:
```postgresql
SELECT * FROM order_info_view WHERE "Status" != 'done' AND "Status" != 'cancelled';
```

Получение заказа по его ID:
```postgresql
SELECT * FROM order_info_view WHERE "Order ID" = 1;
```

Список всех невыполненных и неотмененных услуг по всем заказам:
```postgresql
SELECT * FROM order_list_view WHERE "Status" != 'done' AND "Status" != 'cancelled';
```

Состав заказа по его ID:
```postgresql
SELECT * FROM order_list_view WHERE "Order ID" = 1;
```

Также можно выводить эти данные, не используя представления (view).

### Создание заказа

Список доступных услуг:
```postgresql
SELECT * from service;
```

Список заказчиков
```postgresql
SELECT * FROM customer;
```

Создание заказа (указываем ID заказчика и дедлайн):
```postgresql
INSERT INTO orders (customer_id, deadline) VALUES (1, '2026-01-16');
```

Добавление услуги в заказ (указываем ID заказа и ID услуги):
```
INSERT INTO order_service (order_id, service_id) VALUES (1, 1);
```

Также есть дополнительные поля при создании и наполнении заказа, такие как количество услуг, мерки, описание и др.

### Сотрудники и назначение услуг

Список активных сотрудников:
```postgresql
SELECT * from employee WHERE is_active = true;
```

Назначение сотруднику ТОЛЬКО ОДНОЙ услуги из заказа:
```postgresql
UPDATE order_service SET employee_id = 1 WHERE order_id = 1 AND service_id = 1;
```

Назначение сотруднику ВСЕХ услуг из заказа:
```postgresql
UPDATE order_service SET employee_id = 1 WHERE order_id = 1;
```

Список незавершенных и неотмененных услуг, назначенных сотруднику по его ID:
```postgresql
SELECT * FROM order_service WHERE status != 'done' AND status != 'cancelled' AND employee_id = 1;
```

### Уведомления

Список уведомлений пользователя по его ID:
```postgresql
SELECT * FROM notification WHERE employee_id = 1;
```
