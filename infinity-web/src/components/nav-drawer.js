import { renderNavItems } from './nav-items.js';
import { renderSiteTitle } from './site-title.js';
import { HEADER_BAR, HEADER_HEIGHT } from '../constants.js';

export const renderNavDrawer = () => `
  <button aria-label="Menu" class="DrawerButton" onclick="document.getElementById('nav-drawer').classList.add('open')">
    <svg viewBox="0 0 16 16" width="16" height="16" fill="currentColor" aria-hidden="true">
      <path d="M1 3h14v2H1V3zm0 4h14v2H1V7zm0 4h14v2H1v-2z"></path>
    </svg>
  </button>

  <div id="nav-drawer" class="NavDrawer" style="top:${HEADER_HEIGHT + HEADER_BAR}px;">
    <div class="NavDrawerOverlay" onclick="document.getElementById('nav-drawer').classList.remove('open')"></div>
    <div class="NavDrawerPanel">
      ${renderSiteTitle(false, 'NavDrawerTitle')}
      ${renderNavItems(window.location.pathname || '/', 'https://github.com/CORPUSTHEKING/DEV.INF.WEB.git')}
    </div>
  </div>
`;

export default renderNavDrawer;
