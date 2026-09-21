# FoodPorn

FoodPorn is a small, database-first project for managing a chef-facing menu catalog. It defines a PostgreSQL schema for menu categories and menu items and includes versioned update scripts for safely applying changes to the menu over time.

This repository is focused on the data layer: it is not a web app or UI, but a reusable foundation for menu data that can be fed into a larger application.

## Why this project exists

The repository solves a simple problem: keeping menu data structured, versioned, and easy to update without creating duplicate records or making schema changes by hand.

It provides:

- a base schema for categories and items
- seeded initial menu data
- a dated update script for seasonal menu changes
- idempotent SQL so the scripts can be re-run safely

## Repository structure

```text
.
├── README.md
├── database/
│   ├── menu_base.sql
│   └── updates/
│       └── menu_update_2026_04_15.sql
└── .gitignore
```

## Database schema

The base schema is defined in `database/menu_base.sql`.

### `menu_categories`

Stores top-level menu groups such as starters, mains, desserts, and drinks.

Columns:

- `id` — primary key
- `slug` — unique URL-safe identifier
- `name` — display name
- `sort_order` — sorting order for presentation

### `menu_items`

Stores individual dishes and beverages.

Columns:

- `id` — primary key
- `category_id` — foreign key to `menu_categories`
- `sku` — unique stock-keeping code
- `name` — dish name
- `description` — product description
- `price_uah` — price in UAH
- `is_active` — availability flag
- `updated_at` — timestamp of the last update

## Initial setup

Before running the scripts, ensure PostgreSQL is available and that your database connection is configured.

Set the connection string:

```bash
export DATABASE_URL="postgresql://user:password@localhost:5432/foodporn"
```

Then initialize the base menu schema and seed data:

```bash
psql "$DATABASE_URL" -f database/menu_base.sql
```

This creates the tables and inserts the starter menu records.

## Applying menu updates

The project includes a dated update script for the menu refresh:

```bash
psql "$DATABASE_URL" -f database/updates/menu_update_2026_04_15.sql
```

This update does three main things:

- adds a new `Сезонні пропозиції` category
- inserts new dishes
- updates prices for existing entries
- archives an outdated item by setting `is_active = FALSE`

## Safe re-runs

All inserts and updates are written with PostgreSQL `ON CONFLICT` clauses so the scripts are safe to run more than once.

This means repeated executions:

- do not create duplicate records
- do update existing rows with the latest values
- keep the dataset consistent across repeated deployments

## Example data flow

The base script creates a menu like this:

- `Закуски`
- `Основні страви`
- `Десерти`
- `Напої`

The update script adds:

- `Сезонні пропозиції`
- `Хумус з пітою`
- `Боул з лососем`
- `Крем-суп зі спаржі`

## Example queries

List all active menu items:

```sql
SELECT m.id, m.name, m.price_uah, c.name AS category
FROM menu_items m
JOIN menu_categories c ON c.id = m.category_id
WHERE m.is_active = TRUE
ORDER BY c.sort_order, m.id;
```

Find a category by slug:

```sql
SELECT *
FROM menu_categories
WHERE slug = 'seasonal';
```

## Requirements

- PostgreSQL client (`psql`)
- a configured `DATABASE_URL`
- a target database with privileges to create tables and insert data

## Notes

This repository intentionally focuses on menu data management rather than user interfaces or application logic. It is designed to be simple, reproducible, and easy to extend with further menu updates as seasonal or pricing changes are introduced.
