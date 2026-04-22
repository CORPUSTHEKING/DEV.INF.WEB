import { renderSiteTitle } from './site-title.js';
import { renderSearchDesktop, renderSearchMobile } from './search.js';
import { renderNavDrawer } from './nav-drawer.js';
import { Z_INDEX, HEADER_BAR } from '../constants.js';
import headerNavItems from '../../content/header-nav.json';

export const renderHeader = () => {
  const navLinks = headerNavItems.map((item) => `<a href="${item.url}" class="HeaderLink">${item.title}</a>`).join('');

  return `
    <div class="stickyHeader" style="z-index:${Z_INDEX.HEADER}; top:${HEADER_BAR}px;">
      <header class="headerBox NpmHeaderBar">
        <div class="HeaderBox_0">
          ${renderSiteTitle(true, 'SiteTitle')}
          ${renderSearchDesktop()}
        </div>
        <div class="HeaderBox_1">
          <div class="navDesktop">${navLinks}</div>
          <div class="navMobile">
            ${renderSearchMobile()}
            ${renderNavDrawer()}
          </div>
        </div>
      </header>
    </div>
  `;
};

export default renderHeader;
