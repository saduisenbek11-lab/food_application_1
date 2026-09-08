import { useEffect, useState } from 'react';
import { Heart, Loader2 } from 'lucide-react';
import type { Recipe } from '@/types';
import { fetchRecipeById } from '@/api';
import { RecipeCard } from '@/components/RecipeCard';

interface FavoritesScreenProps {
  favorites: string[];
  onOpenRecipe: (id: string) => void;
}

export function FavoritesScreen({ favorites, onOpenRecipe }: FavoritesScreenProps) {
  const [favRecipes, setFavRecipes] = useState<Recipe[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    let cancelled = false;
    if (favorites.length === 0) {
      setFavRecipes([]);
      return;
    }
    setLoading(true);
    Promise.all(favorites.map((id) => fetchRecipeById(id)))
      .then((results) => {
        if (!cancelled) {
          setFavRecipes(
            results.filter((r): r is Recipe => r !== null),
          );
        }
      })
      .catch(() => {})
      .finally(() => {
        if (!cancelled) setLoading(false);
      });
    return () => {
      cancelled = true;
    };
  }, [favorites]);

  return (
    <div className="px-4 pb-24 pt-6">
      <div className="mb-5 flex items-center gap-2">
        <Heart className="h-6 w-6 fill-rose-500 text-rose-500" />
        <h1 className="text-2xl font-bold text-neutral-900 dark:text-white">
          Избранное
        </h1>
      </div>

      {loading && (
        <div className="flex flex-col items-center justify-center py-20">
          <Loader2 className="h-8 w-8 animate-spin text-amber-500" />
          <p className="mt-3 text-sm text-neutral-400">Загрузка...</p>
        </div>
      )}

      {!loading && favRecipes.length === 0 && (
        <div className="flex flex-col items-center justify-center rounded-2xl bg-white py-20 text-center ring-1 ring-neutral-200 dark:bg-neutral-800 dark:ring-neutral-700">
          <Heart className="mb-3 h-12 w-12 text-neutral-300 dark:text-neutral-600" />
          <p className="text-neutral-500 dark:text-neutral-400">Список пуст</p>
          <p className="mt-1 text-sm text-neutral-400">
            Нажмите на сердечко в рецепте, чтобы добавить его сюда
          </p>
        </div>
      )}

      {!loading && favRecipes.length > 0 && (
        <>
          <p className="mb-4 text-sm text-neutral-500 dark:text-neutral-400">
            {favRecipes.length} избранных рецептов
          </p>
          <div className="grid grid-cols-2 gap-4">
            {favRecipes.map((recipe) => (
              <RecipeCard
                key={recipe.id}
                recipe={recipe}
                onClick={() => onOpenRecipe(recipe.id)}
              />
            ))}
          </div>
        </>
      )}
    </div>
  );
}
