export const SITE_CONFIG = {
  title: 'Infinity Web',
  description: 'A modular static site scaffold for Astro + vanilla JS.',
  version: '1.0.0',
  root: 'infinity-web/',
  apiBase: '/data/',
  repositoryUrl: 'https://github.com/CORPUSTHEKING/DEV.INF.WEB.git',
  imageUrl: '/favicon.png',
};

export const THEME_MODES = {
  LIGHT: 'light',
  DARK: 'dark',
};

export const HEADER_HEIGHT = 56;
export const HEADER_BAR = 10;
export const FULL_HEADER_HEIGHT = HEADER_HEIGHT + HEADER_BAR;
export const SCROLL_MARGIN_TOP = FULL_HEADER_HEIGHT + 24;
export const SKIP_TO_CONTENT_ID = 'skip-to-content';
export const SKIP_TO_SEARCH_ID = 'search-box-input';
export const CLI_PATH = '/cli';

export const Z_INDEX = {
  HEADER: 10,
  SEARCH_OVERLAY: 25,
};

export const DEFAULT_THEME = THEME_MODES.LIGHT;
