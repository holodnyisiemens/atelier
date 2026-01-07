-- Таблица сотрудников
CREATE TABLE employee (
    id SERIAL PRIMARY KEY,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    experience INT NOT NULL CHECK (experience BETWEEN 0 AND 10),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Таблица услуг
CREATE TABLE service (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description VARCHAR(500),
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    complexity INT NOT NULL CHECK (complexity BETWEEN 0 AND 10),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Таблица заказчиков
CREATE TABLE customer (
    id SERIAL PRIMARY KEY,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Таблица заказов
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    total_amount NUMERIC(10,2) NOT NULL DEFAULT 0,
    order_status order_status NOT NULL DEFAULT 'new',
    deadline DATE NOT NULL CHECK (deadline >= CURRENT_DATE),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(id)
        ON DELETE RESTRICT
);

-- Таблица соответствия заказов и услуг в них
CREATE TABLE order_service (
    order_id INT NOT NULL,
    service_id INT NOT NULL,
    employee_id INT,
    description VARCHAR(500),
    measurements VARCHAR(200),
    count INT NOT NULL DEFAULT 1,
    service_status service_status NOT NULL DEFAULT 'new',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT pk_order_service
        PRIMARY KEY (order_id, service_id),

    CONSTRAINT fk_os_order
        FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_os_service
        FOREIGN KEY (service_id)
        REFERENCES service(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_os_employee
        FOREIGN KEY (employee_id)
        REFERENCES employee(id)
        ON DELETE RESTRICT
);

-- Таблица уведомлений сотрудников
CREATE TABLE notification (
    id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    message VARCHAR(200) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_notification_employee
        FOREIGN KEY (employee_id)
        REFERENCES employee(id)
        ON DELETE CASCADE
);
