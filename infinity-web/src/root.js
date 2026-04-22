import { initGlobalStyles } from './page.js';
import { applyTheme } from './theme.js';
import { renderLayout } from './layout.js';
import { updateHead } from './head.js';

const bootstrap = () => {
  initGlobalStyles();
  applyTheme('light');
  updateHead({ title: 'Infinity Web' });

  const root = document.getElementById('app-root') || document.body;
  root.appendChild(renderLayout());
};

window.addEventListener('DOMContentLoaded', bootstrap);

export default bootstrap;
