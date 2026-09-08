import { Star } from 'lucide-react';
import type { Recipe } from '@/types';

interface RecipeCardProps {
  recipe: Recipe;
  onClick: () => void;
}

export function RecipeCard({ recipe, onClick }: RecipeCardProps) {
  return (
    <button
      onClick={onClick}
      className="group flex flex-col overflow-hidden rounded-2xl bg-white text-left shadow-sm ring-1 ring-black/5 transition-all duration-300 hover:-translate-y-1 hover:shadow-xl dark:bg-neutral-800 dark:ring-white/10"
    >
      <div className="relative h-44 overflow-hidden">
        <img
          src={recipe.image}
          alt={recipe.title}
          loading="lazy"
          className="h-full w-full object-cover transition-transform duration-500 group-hover:scale-110"
        />
      </div>
      <div className="flex flex-1 flex-col p-4">
        <h3 className="line-clamp-2 font-semibold leading-snug text-neutral-900 dark:text-white">
          {recipe.title}
        </h3>
        {recipe.description && (
          <p className="mt-1 line-clamp-2 text-sm text-neutral-500 dark:text-neutral-400">
            {recipe.description}
          </p>
        )}
      </div>
    </button>
  );
}
