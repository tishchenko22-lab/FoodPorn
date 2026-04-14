# FoodPorn
Додаток для шефа

## Висновок щодо надійності CSS-селекторів для automation

### Що є стійким / що менш стійке
Дуже стійке:
- усі `#ingredient_*`
- `#ingredient-editor-panel`
- `#ingredients-list`
- `#ingredient-search`

Достатньо стійке:
- `button[onclick="openIngredientCreate()"]`
- `button[onclick="saveIngredientFromForm()"]`

Менш стійке:
- пошук по тексту + `New ingredient`
- `.view`
- `.panel`
- `.toolbar`

### Рекомендований пріоритет селекторів
1. `id`
2. `onclick`
3. текст
4. XPath по структурі

### Що прибрати
Абсолютний XPath як підхід слід виключити:
- `/html/body/div[4]/div/div/div/div[2]/div[1]`

### Що використовувати замість
`#ingredient-search`
`#ingredients-list`
`#ingredient-editor-panel:not(.hidden)`
`#ingredient_name`
`button[onclick="openIngredientCreate()"]`
`button[onclick="saveIngredientFromForm()"]`

### Фінальний практичний висновок
Для цього екрану абсолютний XPath більше не потрібен і має бути повністю прибраний. Надійна production-автоматизація тут досягається через пріоритет `id`-селекторів, з резервом на `onclick`-селектори. Текстові та структурні XPath-пошуки варто залишати лише як fallback. Запропонований набір селекторів покриває сценарії стабільно та практично для підтримки в продакшені.
