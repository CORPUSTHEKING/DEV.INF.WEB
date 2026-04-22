import { THEME_MODES } from './constants.js';

export const applyTheme = (theme = THEME_MODES.LIGHT) => {
  const root = document.documentElement;

  if (theme === THEME_MODES.DARK || theme === 'dark') {
    root.style.setProperty('--bg-color', '#121212');
    root.style.setProperty('--text-color', '#ffffff');
    root.style.setProperty('--bgColor-default', '#0d1117');
    root.style.setProperty('--fgColor-default', '#c9d1d9');
  } else {
    root.style.setProperty('--bg-color', '#ffffff');
    root.style.setProperty('--text-color', '#111111');
    root.style.setProperty('--bgColor-default', '#ffffff');
    root.style.setProperty('--fgColor-default', '#24292f');
  }
};

export default applyTheme;
