import { useEffect, useState } from 'react';
import {
  ArrowLeft,
  Clock,
  Flame,
  Heart,
  Loader2,
  ListOrdered,
  Users,
  UtensilsCrossed,
} from 'lucide-react';
import type { Recipe } from '@/types';
import { apiCategories, fetchRecipesByCategory } from '@/api';
import { RecipeCard } from '@/components/RecipeCard';

interface RecipeDetailScreenProps {
  recipeId: string;
  fallback?: Recipe | undefined;
  isFavorite: boolean;
  onToggleFavorite: (id: string) => void;
  onBack: () => void;
  onOpenRecipe: (id: string) => void;
  loadRecipe: (id: string) => Promise<Recipe | null>;
}

export function RecipeDetailScreen({
  recipeId,
  fallback,
  isFavorite,
  onToggleFavorite,
  onBack,
  onOpenRecipe,
  loadRecipe,
}: RecipeDetailScreenProps) {
  const [recipe, setRecipe] = useState<Recipe | null>(fallback ?? null);
  const [related, setRelated] = useState<Recipe[]>([]);
  const [loading, setLoading] = useState(!fallback);

  useEffect(() => {
    let cancelled = false;
    if (!fallback) {
      setLoading(true);
      loadRecipe(recipeId).then((r) => {
        if (!cancelled) {
          setRecipe(r);
          setLoading(false);
        }
      });
    }
    return () => {
      cancelled = true;
    };
  }, [recipeId, fallback, loadRecipe]);

  // Load related recipes from the same category
  useEffect(() => {
    if (!recipe?.category) return;
    let cancelled = false;
    fetchRecipesByCategory(recipe.category)
      .then((list) => {
        if (!cancelled) {
          setRelated(list.filter((r) => r.id !== recipe.id).slice(0, 4));
        }
      })
      .catch(() => {});
    return () => {
      cancelled = true;
    };
  }, [recipe]);

  if (loading) {
    return (
      <div className="flex h-[60vh] flex-col items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-amber-500" />
        <p className="mt-3 text-sm text-neutral-400">Загрузка рецепта...</p>
      </div>
    );
  }

  if (!recipe) {
    return (
      <div className="flex flex-col items-center justify-center py-20 text-center">
        <p className="text-neutral-400">Рецепт не найден.</p>
        <button
          onClick={onBack}
          className="mt-4 rounded-xl bg-amber-500 px-5 py-2 text-sm font-semibold text-white"
        >
          Назад
        </button>
      </div>
    );
  }

  const category = apiCategories.find((c) => c.id === recipe.category);

  return (
    <div className="pb-24">
      {/* Hero image */}
      <div className="relative h-80 w-full overflow-hidden">
        <img
          src={recipe.image}
          alt={recipe.title}
          className="h-full w-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-b from-black/40 via-transparent to-black/10" />

        <div className="absolute inset-x-0 top-0 flex items-center justify-between p-4 pt-6">
          <button
            onClick={onBack}
            className="flex h-10 w-10 items-center justify-center rounded-full bg-white/90 text-neutral-800 shadow-lg backdrop-blur-sm transition-transform hover:scale-105 active:scale-95"
          >
            <ArrowLeft className="h-5 w-5" />
          </button>
          <button
            onClick={() => onToggleFavorite(recipe.id)}
            className="flex h-10 w-10 items-center justify-center rounded-full bg-white/90 shadow-lg backdrop-blur-sm transition-transform hover:scale-105 active:scale-95"
          >
            <Heart
              className={`h-5 w-5 transition-colors ${
                isFavorite ? 'fill-rose-500 text-rose-500' : 'text-neutral-700'
              }`}
            />
          </button>
        </div>
      </div>

      {/* Content */}
      <div className="relative -mt-6 rounded-t-3xl bg-neutral-50 px-5 pt-6 dark:bg-neutral-900">
        <h1 className="text-2xl font-bold leading-tight text-neutral-900 dark:text-white">
          {recipe.title}
        </h1>
        {category && (
          <span className="mt-2 inline-block rounded-full bg-amber-100 px-3 py-1 text-xs font-semibold text-amber-700 dark:bg-amber-500/15 dark:text-amber-400">
            {category.emoji} {category.label}
          </span>
        )}

        {recipe.description && (
          <p className="mt-4 text-sm leading-relaxed text-neutral-600 dark:text-neutral-300">
            {recipe.description}
          </p>
        )}

        {/* Ingredients */}
        {recipe.ingredients.length > 0 && (
          <section className="mt-8">
            <h2 className="mb-3 flex items-center gap-2 text-lg font-bold text-neutral-900 dark:text-white">
              <UtensilsCrossed className="h-5 w-5 text-amber-500" />
              Ингредиенты
            </h2>
            <div className="overflow-hidden rounded-2xl bg-white ring-1 ring-neutral-200 dark:bg-neutral-800 dark:ring-neutral-700">
              <ul className="divide-y divide-neutral-100 dark:divide-neutral-700">
                {recipe.ingredients.map((ing, idx) => (
                  <li
                    key={idx}
                    className="flex items-center justify-between px-4 py-3 text-sm"
                  >
                    <span className="text-neutral-700 dark:text-neutral-200">
                      {ing.name}
                    </span>
                    <span className="font-medium text-neutral-500 dark:text-neutral-400">
                      {ing.amount}
                    </span>
                  </li>
                ))}
              </ul>
            </div>
          </section>
        )}

        {/* Steps */}
        {recipe.steps.length > 0 && (
          <section className="mt-8">
            <h2 className="mb-3 flex items-center gap-2 text-lg font-bold text-neutral-900 dark:text-white">
              <ListOrdered className="h-5 w-5 text-amber-500" />
              Рецепт
            </h2>
            <ol className="space-y-3">
              {recipe.steps.map((step, idx) => (
                <li key={idx} className="flex gap-3">
                  <span className="flex h-7 w-7 flex-shrink-0 items-center justify-center rounded-full bg-amber-500 text-sm font-bold text-white">
                    {idx + 1}
                  </span>
                  <p className="pt-0.5 text-sm leading-relaxed text-neutral-700 dark:text-neutral-200">
                    {step}
                  </p>
                </li>
              ))}
            </ol>
          </section>
        )}

        {/* Related from same category */}
        {related.length > 0 && (
          <section className="mt-10">
            <h2 className="mb-3 text-lg font-bold text-neutral-900 dark:text-white">
              Больше из «{category?.label}»
            </h2>
            <div className="grid grid-cols-2 gap-4">
              {related.map((r) => (
                <RecipeCard key={r.id} recipe={r} onClick={() => onOpenRecipe(r.id)} />
              ))}
            </div>
          </section>
        )}
      </div>
    </div>
  );
}

export type { RecipeDetailScreenProps };
