import { useEffect, useState } from 'react';

export type ThemeMode = 'light' | 'dark';

export interface Settings {
  theme: ThemeMode;
  notifications: boolean;
  measurementUnit: 'metric' | 'imperial';
  language: 'ru' | 'en';
}

const DEFAULT_SETTINGS: Settings = {
  theme: 'light',
  notifications: true,
  measurementUnit: 'metric',
  language: 'ru',
};

const SETTINGS_KEY = 'recipe-app-settings';

export function useSettings() {
  const [settings, setSettings] = useState<Settings>(() => {
    try {
      const stored = localStorage.getItem(SETTINGS_KEY);
      return stored ? { ...DEFAULT_SETTINGS, ...JSON.parse(stored) } : DEFAULT_SETTINGS;
    } catch {
      return DEFAULT_SETTINGS;
    }
  });

  useEffect(() => {
    try {
      localStorage.setItem(SETTINGS_KEY, JSON.stringify(settings));
    } catch {
      // ignore
    }
  }, [settings]);

  const updateSettings = (partial: Partial<Settings>) => {
    setSettings((prev) => ({ ...prev, ...partial }));
  };

  return { settings, updateSettings };
}
