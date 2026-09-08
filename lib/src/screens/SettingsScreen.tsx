import { Bell, Globe, Moon, Ruler, Sun, User } from 'lucide-react';
import type { Settings } from '@/hooks/useSettings';

interface SettingsScreenProps {
  settings: Settings;
  onUpdate: (partial: Partial<Settings>) => void;
}

export function SettingsScreen({ settings, onUpdate }: SettingsScreenProps) {
  return (
    <div className="px-4 pb-24 pt-6">
      <h1 className="mb-5 text-2xl font-bold text-neutral-900 dark:text-white">
        Настройки
      </h1>

      {/* Profile card */}
      <div className="flex items-center gap-4 rounded-2xl bg-gradient-to-br from-amber-500 to-orange-500 p-5 text-white shadow-lg shadow-amber-500/20">
        <div className="flex h-16 w-16 items-center justify-center rounded-full bg-white/20 backdrop-blur-sm">
          <User className="h-8 w-8" />
        </div>
        <div>
          <p className="text-lg font-bold">Гость</p>
          <p className="text-sm text-white/80">Войдите, чтобы синхронизировать рецепты</p>
        </div>
      </div>

      {/* Theme */}
      <Section title="Оформление">
        <div className="flex gap-2">
          <ThemeButton
            active={settings.theme === 'light'}
            onClick={() => onUpdate({ theme: 'light' })}
            icon={Sun}
            label="Светлая"
          />
          <ThemeButton
            active={settings.theme === 'dark'}
            onClick={() => onUpdate({ theme: 'dark' })}
            icon={Moon}
            label="Тёмная"
          />
        </div>
      </Section>

      {/* Notifications */}
      <Section title="Уведомления">
        <Row
          icon={Bell}
          label="Push-уведомления"
          description="Советы и напоминания о новых рецептах"
        >
          <Toggle
            on={settings.notifications}
            onClick={() => onUpdate({ notifications: !settings.notifications })}
          />
        </Row>
      </Section>

      {/* Units */}
      <Section title="Единицы измерения">
        <div className="flex gap-2">
          <PillButton
            active={settings.measurementUnit === 'metric'}
            onClick={() => onUpdate({ measurementUnit: 'metric' })}
            icon={Ruler}
            label="Метрические"
          />
          <PillButton
            active={settings.measurementUnit === 'imperial'}
            onClick={() => onUpdate({ measurementUnit: 'imperial' })}
            icon={Ruler}
            label="Имперские"
          />
        </div>
      </Section>

      {/* Language */}
      <Section title="Язык">
        <div className="flex gap-2">
          <PillButton
            active={settings.language === 'ru'}
            onClick={() => onUpdate({ language: 'ru' })}
            icon={Globe}
            label="Русский"
          />
          <PillButton
            active={settings.language === 'en'}
            onClick={() => onUpdate({ language: 'en' })}
            icon={Globe}
            label="English"
          />
        </div>
      </Section>

      <p className="mt-8 text-center text-xs text-neutral-400">
        Версия 1.0.0
      </p>
    </div>
  );
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section className="mt-6">
      <h2 className="mb-2 px-1 text-sm font-semibold uppercase tracking-wide text-neutral-400">
        {title}
      </h2>
      <div className="rounded-2xl bg-white p-4 ring-1 ring-neutral-200 dark:bg-neutral-800 dark:ring-neutral-700">
        {children}
      </div>
    </section>
  );
}

function Row({
  icon: Icon,
  label,
  description,
  children,
}: {
  icon: typeof Bell;
  label: string;
  description: string;
  children: React.ReactNode;
}) {
  return (
    <div className="flex items-center justify-between gap-3">
      <div className="flex items-center gap-3">
        <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-amber-100 text-amber-600 dark:bg-amber-500/15 dark:text-amber-400">
          <Icon className="h-5 w-5" />
        </div>
        <div>
          <p className="text-sm font-semibold text-neutral-900 dark:text-white">{label}</p>
          <p className="text-xs text-neutral-500 dark:text-neutral-400">{description}</p>
        </div>
      </div>
      {children}
    </div>
  );
}

function Toggle({ on, onClick }: { on: boolean; onClick: () => void }) {
  return (
    <button
      onClick={onClick}
      className={`relative h-6 w-11 rounded-full transition-colors ${
        on ? 'bg-amber-500' : 'bg-neutral-300 dark:bg-neutral-600'
      }`}
    >
      <span
        className={`absolute top-0.5 h-5 w-5 rounded-full bg-white shadow-sm transition-transform ${
          on ? 'translate-x-5' : 'translate-x-0.5'
        }`}
      />
    </button>
  );
}

function ThemeButton({
  active,
  onClick,
  icon: Icon,
  label,
}: {
  active: boolean;
  onClick: () => void;
  icon: typeof Sun;
  label: string;
}) {
  return (
    <button
      onClick={onClick}
      className={`flex flex-1 items-center justify-center gap-2 rounded-xl py-3 text-sm font-semibold transition-all ${
        active
          ? 'bg-amber-500 text-white shadow-md shadow-amber-500/30'
          : 'bg-neutral-100 text-neutral-600 dark:bg-neutral-700 dark:text-neutral-300'
      }`}
    >
      <Icon className="h-4 w-4" />
      {label}
    </button>
  );
}

function PillButton({
  active,
  onClick,
  icon: Icon,
  label,
}: {
  active: boolean;
  onClick: () => void;
  icon: typeof Ruler;
  label: string;
}) {
  return (
    <button
      onClick={onClick}
      className={`flex flex-1 items-center justify-center gap-2 rounded-xl py-3 text-sm font-semibold transition-all ${
        active
          ? 'bg-amber-500 text-white shadow-md shadow-amber-500/30'
          : 'bg-neutral-100 text-neutral-600 dark:bg-neutral-700 dark:text-neutral-300'
      }`}
    >
      <Icon className="h-4 w-4" />
      {label}
    </button>
  );
}

export type { SettingsScreenProps };
