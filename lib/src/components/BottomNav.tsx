import { Home, Heart, Settings as SettingsIcon } from 'lucide-react';
import type { Screen } from '@/types';

interface BottomNavProps {
  screen: Screen;
  onNavigate: (screen: Screen) => void;
}

export function BottomNav({ screen, onNavigate }: BottomNavProps) {
  const activeName = screen.name;

  const items: { name: Screen['name']; label: string; icon: typeof Home }[] = [
    { name: 'home', label: 'Главная', icon: Home },
    { name: 'favorites', label: 'Избранное', icon: Heart },
    { name: 'settings', label: 'Настройки', icon: SettingsIcon },
  ];

  return (
    <nav className="fixed bottom-0 left-0 right-0 z-30 border-t border-neutral-200/80 bg-white/90 backdrop-blur-lg dark:border-neutral-800 dark:bg-neutral-900/90">
      <div className="mx-auto flex max-w-2xl items-center justify-around px-4 py-2">
        {items.map((item) => {
          const Icon = item.icon;
          const isActive = activeName === item.name;
          return (
            <button
              key={item.name}
              onClick={() => onNavigate({ name: item.name } as Screen)}
              className="flex flex-1 flex-col items-center gap-1 rounded-xl px-3 py-2 transition-colors"
            >
              <Icon
                className={`h-6 w-6 transition-all duration-200 ${
                  isActive
                    ? 'scale-110 text-amber-500'
                    : 'text-neutral-400 dark:text-neutral-500'
                }`}
                fill={isActive && item.name === 'favorites' ? 'currentColor' : 'none'}
              />
              <span
                className={`text-[11px] font-medium transition-colors ${
                  isActive
                    ? 'text-amber-500'
                    : 'text-neutral-400 dark:text-neutral-500'
                }`}
              >
                {item.label}
              </span>
            </button>
          );
        })}
      </div>
    </nav>
  );
}
