-- FoodPorn: базова структура та стартові дані меню

CREATE TABLE IF NOT EXISTS menu_categories (
    id INTEGER PRIMARY KEY,
    slug TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS menu_items (
    id INTEGER PRIMARY KEY,
    category_id INTEGER NOT NULL,
    sku TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    price_uah NUMERIC(10, 2) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES menu_categories(id)
);

INSERT INTO menu_categories (id, slug, name, sort_order)
VALUES
    (1, 'starters', 'Закуски', 10),
    (2, 'mains', 'Основні страви', 20),
    (3, 'desserts', 'Десерти', 30),
    (4, 'drinks', 'Напої', 40)
ON CONFLICT (id) DO UPDATE
SET slug = EXCLUDED.slug,
    name = EXCLUDED.name,
    sort_order = EXCLUDED.sort_order;

INSERT INTO menu_items (id, category_id, sku, name, description, price_uah, is_active)
VALUES
    (1001, 1, 'BRUSCHETTA-01', 'Брускета з томатами', 'Хрусткий хліб, томати, базилік, оливкова олія', 145.00, TRUE),
    (2001, 2, 'PASTA-ARRAB-01', 'Паста Арабіата', 'Паста з гострим томатним соусом та пармезаном', 265.00, TRUE),
    (3001, 3, 'TIRAMISU-01', 'Тірамісу', 'Класичний десерт з маскарпоне та еспресо', 180.00, TRUE),
    (4001, 4, 'LEMONADE-01', 'Лимонад класичний', 'Домашній лимонад з мʼятою', 95.00, TRUE)
ON CONFLICT (id) DO UPDATE
SET category_id = EXCLUDED.category_id,
    sku = EXCLUDED.sku,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price_uah = EXCLUDED.price_uah,
    is_active = EXCLUDED.is_active,
    updated_at = CURRENT_TIMESTAMP;
