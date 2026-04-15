-- FoodPorn: оновлення меню від 2026-04-15
-- Призначення: застосувати актуалізацію цін та додати нові позиції.

BEGIN;

-- Нова категорія сезонних пропозицій
INSERT INTO menu_categories (id, slug, name, sort_order)
VALUES (5, 'seasonal', 'Сезонні пропозиції', 50)
ON CONFLICT (id) DO UPDATE
SET slug = EXCLUDED.slug,
    name = EXCLUDED.name,
    sort_order = EXCLUDED.sort_order;

-- Додаємо нові позиції меню
INSERT INTO menu_items (id, category_id, sku, name, description, price_uah, is_active)
VALUES
    (1002, 1, 'HUMMUS-01', 'Хумус з пітою', 'Кремовий хумус, піта, паприка, оливкова олія', 165.00, TRUE),
    (2002, 2, 'SALMON-BOWL-01', 'Боул з лососем', 'Рис, лосось, авокадо, огірок, соус понзу', 345.00, TRUE),
    (5001, 5, 'CREAM-SOUP-ASP-01', 'Крем-суп зі спаржі', 'Сезонний крем-суп зі спаржі та грінками', 215.00, TRUE)
ON CONFLICT (id) DO UPDATE
SET category_id = EXCLUDED.category_id,
    sku = EXCLUDED.sku,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price_uah = EXCLUDED.price_uah,
    is_active = EXCLUDED.is_active,
    updated_at = CURRENT_TIMESTAMP;

-- Актуалізація цін існуючих позицій
UPDATE menu_items
SET price_uah = 155.00,
    updated_at = CURRENT_TIMESTAMP
WHERE id = 1001;

UPDATE menu_items
SET price_uah = 275.00,
    updated_at = CURRENT_TIMESTAMP
WHERE id = 2001;

-- Архівуємо неактуальну позицію
UPDATE menu_items
SET is_active = FALSE,
    updated_at = CURRENT_TIMESTAMP
WHERE id = 4001;

COMMIT;
