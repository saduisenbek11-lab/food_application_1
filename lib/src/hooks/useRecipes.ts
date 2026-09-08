import { useCallback, useEffect, useState } from 'react';
import type { Category, Recipe } from '@/types';
import {
  apiCategories,
  fetchRandomRecipes,
  fetchRecipeById,
  fetchRecipesByCategory,
  searchRecipes,
} from '@/api';

export function useRecipes() {
  const [categories] = useState<Category[]>(apiCategories);
  const [recipes, setRecipes] = useState<Recipe[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [activeCategory, setActiveCategory] = useState<string | null>(null);
  const [searchQuery, setSearchQuery] = useState('');

  const loadRandom = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const random = await fetchRandomRecipes(10);
      setRecipes(random);
    } catch (e) {
      setError('Не удалось загрузить рецепты. Проверьте подключение.');
    } finally {
      setLoading(false);
    }
  }, []);

  const loadByCategory = useCallback(async (category: string) => {
    setLoading(true);
    setError(null);
    try {
      const list = await fetchRecipesByCategory(category);
      setRecipes(list);
    } catch (e) {
      setError('Не удалось загрузить подборку.');
    } finally {
      setLoading(false);
    }
  }, []);

  const runSearch = useCallback(async (query: string) => {
    if (!query.trim()) return;
    setLoading(true);
    setError(null);
    try {
      const results = await searchRecipes(query);
      setRecipes(results);
    } catch (e) {
      setError('Поиск не удался. Попробуйте ещё раз.');
    } finally {
      setLoading(false);
    }
  }, []);

  const handleSelectCategory = useCallback(
    (category: string | null) => {
      setActiveCategory(category);
      setSearchQuery('');
      if (category) {
        loadByCategory(category);
      } else {
        loadRandom();
      }
    },
    [loadByCategory, loadRandom],
  );

  const handleSearch = useCallback(
    (query: string) => {
      setSearchQuery(query);
      if (query.trim()) {
        setActiveCategory(null);
        runSearch(query);
      } else {
        loadRandom();
      }
    },
    [runSearch, loadRandom],
  );

  // Initial load
  useEffect(() => {
    loadRandom();
  }, [loadRandom]);

  const getRecipeById = useCallback(async (id: string): Promise<Recipe | null> => {
    return fetchRecipeById(id);
  }, []);

  return {
    categories,
    recipes,
    loading,
    error,
    activeCategory,
    searchQuery,
    selectCategory: handleSelectCategory,
    search: handleSearch,
    getRecipeById,
    retry: () => (activeCategory ? loadByCategory(activeCategory) : loadRandom()),
  };
}
