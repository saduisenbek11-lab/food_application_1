export interface Category {
  id: string;
  label: string;
  emoji: string;
}

export interface Ingredient {
  name: string;
  amount: string;
}

export interface Recipe {
  id: string;
  title: string;
  category: string;
  image: string;
  time: string;
  servings: number;
  calories: number;
  difficulty: 'Легко' | 'Средне' | 'Сложно';
  description: string;
  ingredients: Ingredient[];
  steps: string[];
  rating: number;
}

export type Screen =
  | { name: 'home' }
  | { name: 'recipe'; id: string }
  | { name: 'favorites' }
  | { name: 'settings' };
