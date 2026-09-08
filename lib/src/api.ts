import type { Category, Ingredient, Recipe } from '@/types';

const BASE_URL = 'https://www.themealdb.com/api/json/v1/1';

// TheMealDB categories we expose, mapped to Russian labels
const CATEGORY_MAP: Record<string, { label: string; emoji: string }> = {
  Breakfast: { label: 'Завтрак', emoji: '🍳' },
  Chicken: { label: 'Курица', emoji: '🍗' },
  Beef: { label: 'Говядина', emoji: '🥩' },
  Pasta: { label: 'Паста', emoji: '🍝' },
  Seafood: { label: 'Морепродукты', emoji: '🦐' },
  Dessert: { label: 'Десерт', emoji: '🍰' },
  Vegetarian: { label: 'Вегетарианское', emoji: '🥗' },
  Vegan: { label: 'Веганское', emoji: '🌱' },
};

export const apiCategories: Category[] = Object.entries(CATEGORY_MAP).map(
  ([id, { label, emoji }]) => ({ id, label, emoji }),
);

interface MealDbCategory {
  idCategory: string;
  strCategory: string;
  strCategoryThumb: string;
  strCategoryDescription: string;
}

interface MealDbMealSummary {
  idMeal: string;
  strMeal: string;
  strMealThumb: string;
}

interface MealDbMealFull {
  idMeal: string;
  strMeal: string;
  strCategory: string;
  strArea: string;
  strInstructions: string;
  strMealThumb: string;
  strTags: string | null;
  strYoutube: string | null;
  [key: `strIngredient${number}`]: string | null;
  [key: `strMeasure${number}`]: string | null;
}

async function fetchJson<T>(url: string): Promise<T> {
  const res = await fetch(url);
  if (!res.ok) throw new Error(`Ошибка сети: ${res.status}`);
  return res.json() as Promise<T>;
}

export async function fetchCategories(): Promise<Category[]> {
  return apiCategories;
}

export async function fetchRecipesByCategory(category: string): Promise<Recipe[]> {
  const data = await fetchJson<{ meals: MealDbMealSummary[] | null }>(
    `${BASE_URL}/filter.php?c=${encodeURIComponent(category)}`,
  );
  if (!data.meals) return [];
  return data.meals.map((m) => ({
    id: m.idMeal,
    title: m.strMeal,
    category,
    image: m.strMealThumb,
    time: '',
    servings: 0,
    calories: 0,
    difficulty: 'Средне' as const,
    description: '',
    ingredients: [],
    steps: [],
    rating: 0,
  }));
}

function parseIngredients(meal: MealDbMealFull): Ingredient[] {
  const ingredients: Ingredient[] = [];
  for (let i = 1; i <= 20; i++) {
    const name = meal[`strIngredient${i}` as `strIngredient${number}`];
    const amount = meal[`strMeasure${i}` as `strMeasure${number}`];
    if (name && name.trim()) {
      ingredients.push({ name: name.trim(), amount: (amount || '').trim() });
    }
  }
  return ingredients;
}

function parseSteps(instructions: string): string[] {
  return instructions
    .split(/\r?\n/)
    .map((s) => s.trim())
    .filter((s) => s.length > 0);
}

export async function fetchRecipeById(id: string): Promise<Recipe | null> {
  const data = await fetchJson<{ meals: MealDbMealFull[] | null }>(
    `${BASE_URL}/lookup.php?i=${encodeURIComponent(id)}`,
  );
  if (!data.meals || data.meals.length === 0) return null;
  const meal = data.meals[0];
  const steps = parseSteps(meal.strInstructions);
  return {
    id: meal.idMeal,
    title: meal.strMeal,
    category: meal.strCategory,
    image: meal.strMealThumb,
    time: '',
    servings: 0,
    calories: 0,
    difficulty: 'Средне',
    description: meal.strArea ? `Кухня: ${meal.strArea}` : '',
    ingredients: parseIngredients(meal),
    steps,
    rating: 0,
  };
}

export async function searchRecipes(query: string): Promise<Recipe[]> {
  const data = await fetchJson<{ meals: MealDbMealSummary[] | null }>(
    `${BASE_URL}/search.php?s=${encodeURIComponent(query)}`,
  );
  if (!data.meals) return [];
  return data.meals.map((m) => ({
    id: m.idMeal,
    title: m.strMeal,
    category: '',
    image: m.strMealThumb,
    time: '',
    servings: 0,
    calories: 0,
    difficulty: 'Средне' as const,
    description: '',
    ingredients: [],
    steps: [],
    rating: 0,
  }));
}

export async function fetchRandomRecipes(count: number): Promise<Recipe[]> {
  const requests = Array.from({ length: count }, () =>
    fetchJson<{ meals: MealDbMealFull[] | null }>(`${BASE_URL}/random.php`),
  );
  const results = await Promise.all(requests);
  return results
    .filter((r) => r.meals && r.meals.length > 0)
    .map((r) => {
      const meal = r.meals![0];
      return {
        id: meal.idMeal,
        title: meal.strMeal,
        category: meal.strCategory,
        image: meal.strMealThumb,
        time: '',
        servings: 0,
        calories: 0,
        difficulty: 'Средне' as const,
        description: meal.strArea ? `Кухня: ${meal.strArea}` : '',
        ingredients: [],
        steps: [],
        rating: 0,
      } as Recipe;
    });
}

export async function fetchAllCategories(): Promise<MealDbCategory[]> {
  const data = await fetchJson<{ categories: MealDbCategory[] }>(
    `${BASE_URL}/categories.php`,
  );
  return data.categories;
}
