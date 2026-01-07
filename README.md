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
