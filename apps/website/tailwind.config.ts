import type { Config } from 'tailwindcss';

const config: Config = {
  content: ['./src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      fontFamily: {
        sans: ['var(--font-inter)', 'ui-sans-serif', 'system-ui', 'sans-serif'],
        heading: ['var(--font-poppins)', 'ui-sans-serif', 'system-ui', 'sans-serif'],
      },
      colors: {
        brand: {
          primary: '#1B1F26',
          accent: '#3B82F6',
          'accent-dark': '#2563EB',
          success: '#10B981',
          warning: '#F59E0B',
        },
      },
    },
  },
  plugins: [],
};

export default config;
