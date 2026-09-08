import { Search, X, Loader2, AlertCircle } from 'lucide-react';
import type { Category, Recipe } from '@/types';
import { RecipeCard } from '@/components/RecipeCard';

interface HomeScreenProps {
  categories: Category[];
  recipes: Recipe[];
  loading: boolean;
  error: string | null;
  activeCategory: string | null;
  searchQuery: string;
  onSearch: (query: string) => void;
  onSelectCategory: (category: string | null) => void;
  onOpenRecipe: (id: string) => void;
  onRetry: () => void;
}

export function HomeScreen({
  categories,
  recipes,
  loading,
  error,
  activeCategory,
  searchQuery,
  onSearch,
  onSelectCategory,
  onOpenRecipe,
  onRetry,
}: HomeScreenProps) {
  const handleCategoryClick = (cat: Category) => {
    if (activeCategory === cat.id) {
      onSelectCategory(null);
    } else {
      onSelectCategory(cat.id);
    }
  };

  const activeCat = categories.find((c) => c.id === activeCategory);

  return (
    <div className="px-4 pb-24 pt-6">
      {/* Search */}
      <div className="relative">
        <Search className="pointer-events-none absolute left-4 top-1/2 h-5 w-5 -translate-y-1/2 text-neutral-400" />
        <input
          type="text"
          value={searchQuery}
          onChange={(e) => onSearch(e.target.value)}
          placeholder="Поиск рецептов..."
          className="w-full rounded-2xl border border-neutral-200 bg-white py-3.5 pl-12 pr-12 text-sm font-medium text-neutral-900 shadow-sm outline-none transition-all placeholder:text-neutral-400 focus:border-amber-400 focus:ring-2 focus:ring-amber-400/20 dark:border-neutral-700 dark:bg-neutral-800 dark:text-white"
        />
        {searchQuery && (
          <button
            onClick={() => onSearch('')}
            className="absolute right-3 top-1/2 -translate-y-1/2 rounded-full p-1 text-neutral-400 hover:bg-neutral-100 dark:hover:bg-neutral-700"
          >
            <X className="h-5 w-5" />
          </button>
        )}
      </div>

      {/* Categories */}
      <div className="mt-6">
        <h2 className="mb-3 text-lg font-bold text-neutral-900 dark:text-white">
          Подборки
        </h2>
        <div className="flex gap-3 overflow-x-auto pb-2 [scrollbar-width:none] [-ms-overflow-style:none] [&::-webkit-scrollbar]:hidden">
          {categories.map((cat) => {
            const isActive = activeCategory === cat.id;
            return (
              <button
                key={cat.id}
                onClick={() => handleCategoryClick(cat)}
                className={`flex flex-shrink-0 items-center gap-2 rounded-2xl px-4 py-3 text-sm font-semibold transition-all duration-200 ${
                  isActive
                    ? 'bg-amber-500 text-white shadow-md shadow-amber-500/30'
                    : 'bg-white text-neutral-700 ring-1 ring-neutral-200 hover:bg-neutral-50 dark:bg-neutral-800 dark:text-neutral-200 dark:ring-neutral-700'
                }`}
              >
                <span className="text-lg">{cat.emoji}</span>
                {cat.label}
              </button>
            );
          })}
        </div>
      </div>

      {/* Recipes */}
      <div className="mt-6">
        <div className="mb-3 flex items-center justify-between">
          <h2 className="text-lg font-bold text-neutral-900 dark:text-white">
            {searchQuery
              ? 'Результаты поиска'
              : activeCat
                ? activeCat.label
                : 'Рекомендуем'}
          </h2>
          {!loading && !error && (
            <span className="text-sm text-neutral-400">{recipes.length} блюд</span>
          )}
        </div>

        {loading && (
          <div className="flex flex-col items-center justify-center py-20">
            <Loader2 className="h-8 w-8 animate-spin text-amber-500" />
            <p className="mt-3 text-sm text-neutral-400">Загрузка рецептов...</p>
          </div>
        )}

        {error && !loading && (
          <div className="flex flex-col items-center justify-center rounded-2xl bg-white py-16 text-center ring-1 ring-neutral-200 dark:bg-neutral-800 dark:ring-neutral-700">
            <AlertCircle className="mb-3 h-10 w-10 text-rose-400" />
            <p className="text-neutral-600 dark:text-neutral-300">{error}</p>
            <button
              onClick={onRetry}
              className="mt-4 rounded-xl bg-amber-500 px-5 py-2 text-sm font-semibold text-white transition-colors hover:bg-amber-600"
            >
              Повторить
            </button>
          </div>
        )}

        {!loading && !error && recipes.length === 0 && (
          <div className="flex flex-col items-center justify-center rounded-2xl bg-white py-16 text-center ring-1 ring-neutral-200 dark:bg-neutral-800 dark:ring-neutral-700">
            <p className="text-neutral-400">Ничего не найдено</p>
            <p className="mt-1 text-sm text-neutral-400">
              Попробуйте изменить запрос или подборку
            </p>
          </div>
        )}

        {!loading && !error && recipes.length > 0 && (
          <div className="grid grid-cols-2 gap-4">
            {recipes.map((recipe: Recipe) => (
              <RecipeCard
                key={recipe.id}
                recipe={recipe}
                onClick={() => onOpenRecipe(recipe.id)}
              />
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

export type { HomeScreenProps };
