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

Получить список всех заказов:
```postgresql
SELECT * FROM order_info_view;
```

Получить список всех невыполненных и неотмененных заказов:
```postgresql
SELECT * FROM order_info_view WHERE "Status" != 'done' AND "Status" != 'cancelled';
```

Получить заказ по его ID:
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

Список активных сотрудников:
```postgresql
SELECT * from employee WHERE is_active = true;
```

Список услуг:
```postgresql
SELECT * from service;
```

Назначение сотруднику ТОЛЬКО ОДНОЙ услуги из заказа:
```postgresql
UPDATE order_service SET employee_id = 1 WHERE order_id = 1 AND service_id = 1;
```

Назначение сотруднику ВСЕХ услуг из заказа:
```postgresql
UPDATE order_service SET employee_id = 1 WHERE order_id = 1;
```
