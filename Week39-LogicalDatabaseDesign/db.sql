CREATE TABLE categories (
    category_id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description   VARCHAR(500)
);

CREATE TABLE customers (
    customer_id    BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name     VARCHAR(50)  NOT NULL,
    last_name      VARCHAR(50)  NOT NULL,
    email          VARCHAR(255) NOT NULL UNIQUE,
    phone          VARCHAR(25),
    street_address VARCHAR(150),
    city           VARCHAR(100),
    postal_code    VARCHAR(20),
    country        VARCHAR(100),
    registered_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    CONSTRAINT chk_customers_email_format
        CHECK (email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$')
);

CREATE TABLE products (
    product_id     BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name           VARCHAR(150)  NOT NULL,
    description    VARCHAR(1000),
    price          NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    weight_kg      NUMERIC(8,3)  CHECK (weight_kg > 0),
    stock_quantity INTEGER       NOT NULL DEFAULT 0
                   CHECK (stock_quantity >= 0),
    created_at     TIMESTAMPTZ   NOT NULL DEFAULT now()
);

CREATE TABLE product_categories (
    category_id BIGINT NOT NULL,
    product_id  BIGINT NOT NULL,
    PRIMARY KEY (category_id, product_id),
    CONSTRAINT fk_pc_category FOREIGN KEY (category_id)
        REFERENCES categories (category_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_pc_product FOREIGN KEY (product_id)
        REFERENCES products (product_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE orders (
    order_id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_date       TIMESTAMPTZ NOT NULL DEFAULT now(),
    status           VARCHAR(20) NOT NULL DEFAULT 'pending'
                     CHECK (status IN
                         ('pending', 'paid', 'shipped', 'delivered', 'cancelled')),
    shipping_address VARCHAR(300),
    customer_id      BIGINT NOT NULL,
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE order_items (
    order_id   BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity   INTEGER       NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_oi_order FOREIGN KEY (order_id)
        REFERENCES orders (order_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_oi_product FOREIGN KEY (product_id)
        REFERENCES products (product_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);