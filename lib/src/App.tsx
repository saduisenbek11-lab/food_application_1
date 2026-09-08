import { useEffect, useState } from 'react';
import { ChefHat } from 'lucide-react';
import type { Screen } from '@/types';
import { useFavorites } from '@/hooks/useFavorites';
import { useSettings } from '@/hooks/useSettings';
import { useRecipes } from '@/hooks/useRecipes';
import { BottomNav } from '@/components/BottomNav';
import { HomeScreen } from '@/screens/HomeScreen';
import { RecipeDetailScreen } from '@/screens/RecipeDetailScreen';
import { FavoritesScreen } from '@/screens/FavoritesScreen';
import { SettingsScreen } from '@/screens/SettingsScreen';

function App() {
  const [screen, setScreen] = useState<Screen>({ name: 'home' });
  const { favorites, toggleFavorite, isFavorite } = useFavorites();
  const { settings, updateSettings } = useSettings();
  const {
    categories,
    recipes,
    loading,
    error,
    activeCategory,
    searchQuery,
    selectCategory,
    search,
    getRecipeById,
    retry,
  } = useRecipes();

  // Apply theme to <html>
  useEffect(() => {
    const root = document.documentElement;
    if (settings.theme === 'dark') {
      root.classList.add('dark');
    } else {
      root.classList.remove('dark');
    }
  }, [settings.theme]);

  const openRecipe = (id: string) => {
    setScreen({ name: 'recipe', id });
    window.scrollTo({ top: 0 });
  };

  const navigate = (s: Screen) => {
    setScreen(s);
    window.scrollTo({ top: 0 });
  };

  const goHome = () => setScreen({ name: 'home' });

  return (
    <div className="min-h-screen bg-neutral-50 text-neutral-900 dark:bg-neutral-950 dark:text-white">
      {/* Top header (hidden on recipe detail for immersive hero) */}
      {screen.name !== 'recipe' && (
        <header className="sticky top-0 z-20 border-b border-neutral-200/80 bg-neutral-50/80 backdrop-blur-lg dark:border-neutral-800 dark:bg-neutral-950/80">
          <div className="mx-auto flex max-w-2xl items-center gap-2 px-4 py-3">
            <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-amber-500 text-white shadow-md shadow-amber-500/30">
              <ChefHat className="h-5 w-5" />
            </div>
            <div>
              <h1 className="text-base font-bold leading-none text-neutral-900 dark:text-white">
                Вкусно
              </h1>
              <p className="text-[11px] text-neutral-400">Рецепты на каждый день</p>
            </div>
          </div>
        </header>
      )}

      <main className="mx-auto max-w-2xl">
        {screen.name === 'home' && (
          <HomeScreen
            categories={categories}
            recipes={recipes}
            loading={loading}
            error={error}
            activeCategory={activeCategory}
            searchQuery={searchQuery}
            onSearch={search}
            onSelectCategory={selectCategory}
            onOpenRecipe={openRecipe}
            onRetry={retry}
          />
        )}

        {screen.name === 'recipe' && (
          <RecipeDetailScreen
            recipeId={screen.id}
            isFavorite={isFavorite(screen.id)}
            onToggleFavorite={toggleFavorite}
            onBack={goHome}
            onOpenRecipe={openRecipe}
            loadRecipe={getRecipeById}
          />
        )}

        {screen.name === 'favorites' && (
          <FavoritesScreen favorites={favorites} onOpenRecipe={openRecipe} />
        )}

        {screen.name === 'settings' && (
          <SettingsScreen settings={settings} onUpdate={updateSettings} />
        )}
      </main>

      <BottomNav screen={screen} onNavigate={navigate} />
    </div>
  );
}

export default App;
