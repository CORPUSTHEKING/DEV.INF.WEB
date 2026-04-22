### 1. Changeable Values and Injection Points
| File | Changeable Values | Injection Point |
|---|---|---|
| breadcrumbs.js | Component mount state, maximum depth before hiding. | renderBreadcrumbs function parameters. |
| header.js | Gradient color stops (#fb8817, etc.), SVG Logo toggle. | Template literals in renderHeader / CSS variables. |
| link.js | Fallback URL string generator, Underline hover behavior. | getLocalPath logic / class toggles. |
| nav-drawer.js | Drawer overlay background (rgba), Animation durations (0.2s). | CSS classes / Inline styles. |
| nav-items.js | Hardcoded text ("Site navigation", "GitHub"). | renderNavItems string templates. |
| page-footer.js | Month array format, GitHub Avatar size (?size=40), Top margin. | Contributors map function / format() utility. |
| search.js | Placeholder text, Animation scales/opacities, Dropdown max-height. | Input attributes / Event listener style toggles. |
| sidebar.js | Sticky scroll height calc (100vh - header), SessionStorage key. | Inline style calculations / handleScroll event. |
| site-title.js | Logo SVG path points, colors (#cb3837, #ffffff), Logo size. | SVG markup within renderSiteTitle. |
| skip-nav.js | Translate Y positions (-100% to 0%), z-index. | CSS :focus-within selectors. |
| table-of-contents.js | Default open state, Max-height offset (calc(100% - 24px)). | Details/Summary DOM attributes. |
| text-input.js | iOS zoom prevention font-size (16px), Placeholder opacity. | CSS .TextInput rules. |
| variant-select.js | Variant types (latest, current, prerelease, legacy). | Switch/case statement inside useVariants logic. |
| visually-hidden.js | Clip rect dimensions (rect(0,0,0,0)). | CSS .VisuallyHidden rules. |
### 2. Vanilla JS Rewrites
#### src/components/breadcrumbs.js & breadcrumbs.css
```bash
cat << 'EOF' > src/components/breadcrumbs.js
import * as getNav from '../util/get-nav.js';

export const renderBreadcrumbs = (pathname) => {
  const items = getNav.getItemBreadcrumbs(pathname, { hideVariants: true });
  if (items.length <= 1) return '';

  const links = items.map(item => {
    const selected = getNav.isPathForItem(pathname, getNav.getItem(item.url));
    return `<a href="${item.url}" class="breadcrumb-item ${selected ? 'selected' : ''}">${item.shortName || item.title}</a>`;
  }).join(' / ');

  return `<nav class="PrimerBreadcrumbs">${links}</nav>`;
};
EOF

cat << 'EOF' > src/components/breadcrumbs.css
.PrimerBreadcrumbs { margin-bottom: 24px; font-size: 14px; }
.breadcrumb-item.selected { font-weight: bold; color: var(--fgColor-default); text-decoration: none; pointer-events: none; }
EOF

```
#### src/components/header.js & header.css
```bash
cat << 'EOF' > src/components/header.js
import { renderSiteTitle } from './site-title.js';
import { renderSearchDesktop, renderSearchMobile } from './search.js';
import { renderNavDrawer } from './nav-drawer.js';
import { Z_INDEX, HEADER_BAR } from '../constants.js';
import headerNavItems from '../../content/header-nav.json' with { type: "json" };

export const renderHeader = () => {
  const navLinks = headerNavItems.map(item => 
    `<a href="${item.url}" class="HeaderLink">${item.title}</a>`
  ).join('');

  return `
    <div class="stickyHeader" style="z-index: ${Z_INDEX.HEADER};">
      <div class="NpmHeaderBar" style="height: ${HEADER_BAR}px;"></div>
      <header class="headerBox DarkTheme">
        <div class="HeaderBox_0">
          ${renderSiteTitle(true, 'SiteTitle')}
          <div class="searchDesktop">${renderSearchDesktop()}</div>
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
EOF

cat << 'EOF' > src/components/header.css
.NpmHeaderBar { background-image: linear-gradient(139deg, #fb8817, #ff4b01, #c12127, #e02aff); }
.stickyHeader { top: 0; position: sticky; }
.HeaderBox_0, .HeaderBox_1 { display: flex; align-items: center; }
.SiteTitle { margin-right: 24px; }
.HeaderLink { display: block; margin-left: 24px; color: #e1e4e8; text-decoration: none; }
.headerBox { display: flex; height: 56px; padding: 0 16px; align-items: center; justify-content: space-between; background-color: #333333; border-bottom: 1px solid #444d56; }
@media (min-width: 1012px) { .headerBox { padding: 0 24px; } }
.searchDesktop, .navDesktop { display: none; align-items: center; }
@media (min-width: 1012px) { .searchDesktop { display: block; margin-left: 24px; } .navDesktop { display: flex; } .navMobile { display: none; } }
.navMobile { display: flex; }
EOF

```
#### src/components/link.js & link.css
```bash
cat << 'EOF' > src/components/link.js
const FALLBACK = `http://_${Math.random().toString().slice(2)}._${Math.random().toString().slice(2)}`;

export const getLocalPath = (href) => {
  if (!href || href.startsWith('#')) return null;
  try {
    const url = new URL(href, FALLBACK);
    if (url.host === 'docs.npmjs.com' || url.origin === FALLBACK) {
      return `${url.pathname}${url.search}${url.hash}`;
    }
  } catch { return null; }
  return null;
};

export const renderLink = ({ to, href, showUnderline = false, className = '', text }) => {
  const localPath = getLocalPath(href);
  const targetHref = to || localPath || href;
  const combinedClass = `CustomLink ${showUnderline ? 'showUnderline' : ''} ${className}`;
  return `<a href="${targetHref}" class="${combinedClass.trim()}">${text}</a>`;
};
EOF

cat << 'EOF' > src/components/link.css
.CustomLink:hover, .CustomLink:focus { text-decoration: none; }
.CustomLink.showUnderline { text-decoration: underline; }
EOF

```
#### src/components/nav-drawer.js & nav-drawer.css
```bash
cat << 'EOF' > src/components/nav-drawer.js
import { renderNavItems } from './nav-items.js';
import { renderSiteTitle } from './site-title.js';
import { HEADER_BAR, HEADER_HEIGHT } from '../constants.js';

export const renderNavDrawer = () => `
  <button aria-label="Menu" class="DrawerButton" onclick="document.getElementById('nav-drawer').classList.add('open')">
    <svg viewBox="0 0 16 16" width="16" height="16" fill="currentColor"><path fill-rule="evenodd" d="M1 2.75A.75.75 0 011.75 2h12.5a.75.75 0 110 1.5H1.75A.75.75 0 011 2.75zm0 5A.75.75 0 011.75 7h12.5a.75.75 0 110 1.5H1.75A.75.75 0 011 7.75zM1.75 12a.75.75 0 100 1.5h12.5a.75.75 0 100-1.5H1.75z"></path></svg>
  </button>
  <div id="nav-drawer" class="DrawerBox hidden">
    <div class="DrawerOverlay" onclick="document.getElementById('nav-drawer').classList.remove('open')"></div>
    <div class="DrawerPanel" style="top: ${HEADER_BAR}px;">
      <div class="DrawerContent">
        <div class="DrawerDarkTheme" style="height: ${HEADER_HEIGHT}px;">
          ${renderSiteTitle(false, '')}
          <button aria-label="Close" onclick="document.getElementById('nav-drawer').classList.remove('open')">X</button>
        </div>
        <div class="DrawerNavContainer">
           <div id="drawer-nav-items-mount"></div>
        </div>
      </div>
    </div>
  </div>
`;
EOF

cat << 'EOF' > src/components/nav-drawer.css
.DrawerBox.hidden { display: none; }
.DrawerBox.open { display: block; }
.DrawerOverlay { position: fixed; top: 0; right: 0; bottom: 0; left: 0; background: rgba(140, 149, 159, 0.15); z-index: 20; }
.DrawerPanel { position: fixed; right: 0; bottom: 0; width: 300px; z-index: 21; background: #333333; transform: translateX(0); transition: transform 0.2s; }
.DrawerContent { display: flex; flex-direction: column; height: 100%; overflow: auto; color: #e1e4e8; }
.DrawerDarkTheme { display: flex; align-items: center; justify-content: space-between; padding: 0 16px; background: #333333; border-bottom: 1px solid #444d56; }
.DrawerNavContainer { display: flex; flex-direction: column; padding: 16px; }
.DrawerButton { margin-left: 16px; background: transparent; border: none; color: inherit; cursor: pointer; }
.DrawerButton:focus-visible { outline: 2px solid -webkit-focus-ring-color; }
EOF

```
#### src/components/nav-items.js & nav-items.css
```bash
cat << 'EOF' > src/components/nav-items.js
import * as getNav from '../util/get-nav.js';
import headerNavItems from '../../content/header-nav.json' with { type: "json" };

export const renderNavItems = (pathname, repositoryUrl) => {
  const items = getNav.getHierarchy(null, pathname, { hideVariants: true });
  
  const buildTree = (nodes, depth = 1) => nodes.map(item => {
    const isCurrent = getNav.isActiveUrl(pathname, item.url);
    const children = getNav.getHierarchy(item, item.url, { hideVariants: true });
    const depthClass = depth === 1 ? 'NavList_Item_depth1' : 'NavList_Item_depth2';
    
    let html = `<a href="${item.url}" class="NavListItem ${depthClass}" ${isCurrent ? 'aria-current="page"' : ''}>${item.title}</a>`;
    if (children) html += `<div class="NavSubGroup">${buildTree(children, depth + 1)}</div>`;
    return html;
  }).join('');

  const externalLinks = headerNavItems.map(item => 
    `<div class="headerNavItem"><a class="NavListItem" href="${item.url}">${item.title} ↗</a></div>`
  ).join('');

  return `
    <h3 class="VisuallyHidden">Site navigation</h3>
    <nav aria-label="Site" class="NavListRoot">
      ${buildTree(items)}
      <hr class="NavDivider" />
      ${externalLinks}
      <a class="NavListItem" href="${repositoryUrl}">GitHub ↗</a>
    </nav>
  `;
};
EOF

cat << 'EOF' > src/components/nav-items.css
.NavListItem { display: block; padding: 8px 0; color: inherit; text-decoration: none; }
.NavList_Item_depth1 { font-size: 16px; font-weight: 600; }
.NavList_Item_depth2 { font-size: 14px; margin-left: 16px; opacity: 0.9; }
.NavListItem[aria-current="page"] { font-weight: bold; color: var(--fgColor-accent); }
.NavSubGroup { margin-bottom: 8px; }
.NavDivider { border: 0; border-top: 1px solid #444d56; margin: 16px 0; }
.headerNavItem { display: flex; }
@media (min-width: 1012px) { .headerNavItem { display: none; } }
EOF

```
#### src/components/page-footer.js & page-footer.css
```bash
cat << 'EOF' > src/components/page-footer.js
const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
const format = d => `${months[d.getMonth()]} ${d.getDate()}, ${d.getFullYear()}`;
const pluralize = (word, count) => `${word}${count === 1 ? '' : 's'}`;

export const renderPageFooter = (editUrl, latestCommit, contributors = []) => {
  if (!editUrl && !contributors.length) return '';

  let contributorsHtml = '';
  if (contributors.length) {
    const avatars = contributors.map(login => `
      <a href="https://github.com/${login}" class="FooterLink" title="${login}">
        <img src="https://github.com/${login}.png?size=40" alt="${login}" class="Avatar" />
      </a>
    `).join('');
    contributorsHtml = `<div class="FooterBox"><span class="FooterText">${contributors.length} ${pluralize('contributor', contributors.length)}</span>${avatars}</div>`;
  }

  let commitHtml = '';
  if (latestCommit) {
    const dateStr = format(new Date(latestCommit.date));
    commitHtml = `<div class="FooterText_1">Last edited by <a href="https://github.com/${latestCommit.login}" class="FooterLink Underline">${latestCommit.login}</a> on <a href="${latestCommit.url}" class="FooterLink Underline">${dateStr}</a></div>`;
  }

  const editHtml = editUrl ? `<a href="${editUrl}" class="FooterEditLink">✏️ Edit this page on GitHub</a>` : '';

  return `
    <div class="FooterContainer">
      <div class="FooterGrid">
        ${editHtml}
        ${contributorsHtml}
        ${commitHtml}
      </div>
    </div>
  `;
};
EOF

cat << 'EOF' > src/components/page-footer.css
.FooterContainer { border-top: 1px solid #444d56; margin-top: 64px; padding: 32px 0; }
.FooterGrid { display: grid; gap: 16px; }
.FooterBox { display: flex; align-items: center; flex-wrap: wrap; gap: 8px; }
.FooterText { margin-right: 8px; }
.FooterText_1 { font-size: 14px; margin-top: 4px; opacity: 0.8; }
.FooterLink { line-height: 1.25; margin-right: 8px; text-decoration: none; color: inherit; }
.FooterLink.Underline { text-decoration: underline; }
.FooterEditLink { display: inline-flex; align-items: center; gap: 8px; text-decoration: none; color: inherit; font-weight: 500; }
.Avatar { width: 24px; height: 24px; border-radius: 50%; }
EOF

```
#### src/components/search.js, text-input.js, & CSS
```bash
cat << 'EOF' > src/components/search.js
import { HEADER_BAR, HEADER_HEIGHT, Z_INDEX } from '../constants.js';

export const renderSearchDesktop = () => `
  <div class="SearchBox_2">
    <input type="text" placeholder="Search" aria-label="Search" class="TextInput DesktopSearchInput" id="search-desktop" />
    <div class="SearchResultsContainer" id="search-results-desktop"></div>
  </div>
`;

export const renderSearchMobile = () => `
  <button aria-label="Search" class="SearchButton" onclick="document.getElementById('mobile-search-overlay').classList.add('open')">🔍</button>
  <div id="mobile-search-overlay" class="MobileSearchBox hidden" style="top: ${HEADER_BAR}px; z-index: ${Z_INDEX.SEARCH_OVERLAY};">
    <div class="MobileSearchBackdrop" onclick="document.getElementById('mobile-search-overlay').classList.remove('open')"></div>
    <div class="MobileSearchPanel">
      <div class="MobileSearchHeader" style="height: ${HEADER_HEIGHT}px;">
        <input type="text" placeholder="Search" aria-label="Search" class="TextInput MobileTextInput" id="search-mobile" />
        <button aria-label="Cancel" class="SearchCancelBtn" onclick="document.getElementById('mobile-search-overlay').classList.remove('open')">X</button>
      </div>
      <div class="MobileSearchResults LightTheme" id="search-results-mobile"></div>
    </div>
  </div>
`;
EOF

cat << 'EOF' > src/components/text-input.js
// Logic absorbed directly into global CSS and standard input tags.
EOF

cat << 'EOF' > src/components/search.css
.SearchBox_2 { position: relative; }
.DesktopSearchInput { width: 240px; }
.TextInput { padding: 4px 12px; border-radius: 6px; border: 1px solid #d0d7de; background: transparent; font-size: 16px !important; color: rgb(225, 228, 232) !important; }
.TextInput::placeholder { color: rgba(225, 228, 232, 0.7) !important; }
.SearchResultsContainer { position: absolute; left: 0; right: 0; padding-top: 4px; display: none; }
.SearchResultsContainer.active { display: block; }
.SearchButton { background: transparent; border: none; color: inherit; cursor: pointer; padding: 8px; }
.MobileSearchBox.hidden { display: none; }
.MobileSearchBox.open { display: block; position: fixed; left: 0; right: 0; bottom: 0; }
.MobileSearchBackdrop { position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgba(140, 149, 159, 0.15); z-index: -1; }
.MobileSearchPanel { display: flex; flex-direction: column; background: #ffffff; height: 100%; }
.MobileSearchHeader { display: flex; padding: 0 16px; align-items: center; border-bottom: 1px solid #d0d7de; }
.MobileTextInput { width: 100%; color: #1f2328 !important; }
.SearchCancelBtn { margin-left: 16px; background: transparent; border: none; font-size: 16px; cursor: pointer; color: #1f2328; }
.MobileSearchResults { flex: 1 1 auto; overflow: auto; background: #ffffff; color: #1f2328; }
EOF

```
#### src/components/sidebar.js & sidebar.css
```bash
cat << 'EOF' > src/components/sidebar.js
import { FULL_HEADER_HEIGHT } from '../constants.js';

export const renderSidebar = () => `
  <nav class="SidebarBox" style="top: ${FULL_HEADER_HEIGHT}px; height: calc(100vh - ${FULL_HEADER_HEIGHT}px);">
    <div id="sidebar-scroll" class="SidebarBox_1" onscroll="window.sessionStorage.setItem('sidebar', this.scrollTop)">
      <div class="SidebarBox_2" id="sidebar-nav-mount">
        </div>
    </div>
  </nav>
`;

export const initSidebarScroll = () => {
  const el = document.getElementById('sidebar-scroll');
  const pos = window.sessionStorage.getItem('sidebar');
  if (el && pos) el.scrollTop = pos;
};
EOF

cat << 'EOF' > src/components/sidebar.css
.SidebarBox { position: sticky; width: 270px; }
.SidebarBox_1 { overflow: auto; height: 100%; border-right: 1px solid #444d56; }
.SidebarBox_2 { display: flex; flex-direction: column; padding: 16px; }
EOF

```
#### src/components/site-title.js & site-title.css
```bash
cat << 'EOF' > src/components/site-title.js
export const renderSiteTitle = (logo = true, className = '') => `
  <a href="/" class="SiteTitleLink ${className}">
    ${logo ? `
      <div class="NpmLogoBox">
        <svg height="32" width="32" viewBox="0 0 700 700" fill="currentColor" aria-hidden="true">
          <polygon fill="currentColor" points="0,700 700,700 700,0 0,0" />
          <polygon fill="#ffffff" points="150,550 350,550 350,250 450,250 450,550 550,550 550,150 150,150 " />
        </svg>
      </div>
    ` : ''}
    <span id="site-title-text"></span>
  </a>
`;
EOF

cat << 'EOF' > src/components/site-title.css
.NpmLogoBox { color: #cb3837; display: flex; margin-right: 16px; }
.SiteTitleLink { font-weight: bold; font-size: 16px; color: #e1e4e8; display: flex; align-items: center; text-decoration: none; }
EOF

```
#### src/components/skip-nav.js & visually-hidden.js & CSS
```bash
cat << 'EOF' > src/components/skip-nav.js
import { SCROLL_MARGIN_TOP, SKIP_TO_CONTENT_ID } from '../constants.js';

export const renderSkipNavPlaceholder = () => `
  <div id="${SKIP_TO_CONTENT_ID}" style="scroll-margin-top: ${SCROLL_MARGIN_TOP}px;"></div>
`;
EOF

cat << 'EOF' > src/components/visually-hidden.js
// Absorbed into global CSS
EOF

cat << 'EOF' > src/components/util.css
.VisuallyHidden { position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px; overflow: hidden; clip: rect(0, 0, 0, 0); white-space: nowrap; border-width: 0; }
.SkipBox { display: inline-flex; z-index: 20; left: 10px; gap: 3px; position: absolute; transform: translateY(-100%); transition: transform 0.3s; padding: 8px; background-color: var(--bgColor-default); border: 1px solid var(--fgColor-accent); border-top: 0; font-size: 12px; border-radius: 0 0 6px 6px; }
.SkipBox:focus-within { transform: translateY(0%); }
.SkipLink { color: var(--fgColor-accent); padding: 4px; }
.SkipLink:focus { text-decoration: underline; }
EOF

```
#### src/components/table-of-contents.js & table-of-contents.css
```bash
cat << 'EOF' > src/components/table-of-contents.js
export const renderTOCItems = (items) => {
  if (!items || !items.length) return '';
  return `<ul class="TOCNavList">` + items.map(item => `
    <li>
      <a href="${item.url}">${item.title}</a>
      ${item.items ? renderTOCItems(item.items) : ''}
    </li>
  `).join('') + `</ul>`;
};

export const renderTOCDesktop = (items) => {
  if (!items) return '';
  return `
    <div class="tocDesktop">
      <h2 id="toc-heading" class="TOCHeading">Table of contents</h2>
      <div class="TOCBox">
        <nav aria-labelledby="toc-heading" class="TableOfContents">
          ${renderTOCItems(items)}
        </nav>
      </div>
    </div>
  `;
};

export const renderTOCMobile = (items) => {
  if (!items) return '';
  return `
    <div class="tocMobile">
      <details class="TOCDetails" open>
        <summary class="TOCSummary">Table of contents</summary>
        <nav class="TableOfContents">
          ${renderTOCItems(items)}
        </nav>
      </details>
    </div>
  `;
};
EOF

cat << 'EOF' > src/components/table-of-contents.css
.TOCBox { overflow-y: auto; max-height: calc(100% - 24px); }
.TOCNavList { text-decoration: underline; list-style: none; padding-left: 16px; }
.TOCNavList a { color: inherit; text-decoration: inherit; display: block; padding: 4px 0; }
.TOCDetails { border: 1px solid #444d56; border-radius: 6px; }
.TOCSummary { cursor: pointer; padding: 8px; background: transparent; border-bottom: 1px solid #444d56; font-weight: bold; }
.TOCHeading { font-size: 14px; display: inline-block; font-weight: bold; margin-bottom: 8px; }
.TableOfContents { margin-left: -8px; padding: 8px; }
.tocMobile { display: block; margin-bottom: 16px; margin-top: 24px; }
@media (min-width: 768px) { .tocMobile { display: none; } }
.tocDesktop { width: 220px; flex: 0 0 auto; margin-left: 48px; display: none; position: sticky; top: 90px; max-height: calc(100vh - 90px); }
@media (min-width: 544px) { .tocDesktop { margin-left: 48px; } }
@media (min-width: 768px) { .tocDesktop { display: block; margin-left: 64px; } }
@media (min-width: 1012px) { .tocDesktop { margin-left: 80px; } }
EOF

```
#### src/components/variant-select.js & variant-select.css
```bash
cat << 'EOF' > src/components/variant-select.js
import * as getNav from '../util/get-nav.js';

export const renderVariantSelect = (pathname) => {
  const variantPages = getNav.getVariantsForPath(pathname);
  if (!variantPages || !variantPages.length) return '';

  const result = { latest: null, current: null, prerelease: null, legacy: [], title: '' };
  for (const { variant, page } of variantPages) {
    const item = { ...variant, url: page.url, active: page.url === pathname };
    let typeDesc = '';
    switch (variant.type) {
      case 'latest': result.latest = item; typeDesc = ' (Latest)'; break;
      case 'current': result.current = item; typeDesc = ' (Current)'; break;
      case 'prerelease': result.prerelease = item; typeDesc = ' (Prerelease)'; break;
      default: result.legacy.push(item); typeDesc = ' (Legacy)';
    }
    if (item.active) result.title = `${item.title}${typeDesc}`;
  }
  
  result.legacy.sort((a, b) => parseInt(b.shortName.slice(1)) - parseInt(a.shortName.slice(1)));

  const renderItem = (item) => `<a href="${item.url}" class="VariantItem ${item.active ? 'active' : ''}">${item.title}</a>`;

  return `
    <div class="VariantBox_1">
      <p id="label-versions" class="VariantLabel">Select CLI Version:</p>
      <div class="VariantDropdown">
        <button class="VariantMenuButton" onclick="this.nextElementSibling.classList.toggle('active')">
          ${result.title} ▼
        </button>
        <div class="VariantOverlay">
          <div class="VariantGroup"><strong>Current</strong></div>
          ${result.latest ? renderItem(result.latest) : ''}
          ${result.current ? renderItem(result.current) : ''}
          ${result.prerelease ? renderItem(result.prerelease) : ''}
          <div class="VariantGroup"><strong>Legacy</strong></div>
          ${result.legacy.map(renderItem).join('')}
        </div>
      </div>
    </div>
  `;
};
EOF

cat << 'EOF' > src/components/variant-select.css
.VariantLabel { margin: 0 0 8px 0; font-size: 14px; color: var(--fgColor-default); }
.VariantBox_1 { margin-top: 8px; margin-bottom: 16px; position: relative; }
.VariantDropdown { position: relative; display: inline-block; width: 100%; }
.VariantMenuButton { width: 100%; padding: 6px 12px; text-align: left; background: transparent; border: 1px solid var(--borderColor-default, #d0d7de); border-radius: 6px; color: inherit; cursor: pointer; }
.VariantMenuButton:focus-visible { outline: 2px solid -webkit-focus-ring-color; outline-offset: 1px; }
@media (min-width: 768px) { .VariantMenuButton { width: auto; min-width: 200px; } .VariantDropdown { width: auto; } }
.VariantOverlay { display: none; position: absolute; top: 100%; left: 0; margin-top: 4px; background-color: var(--bgColor-default, #ffffff); border: 1px solid var(--borderColor-default, #d0d7de); box-shadow: 0 3px 6px rgba(140, 149, 159, 0.15); border-radius: 6px; min-width: 100%; z-index: 100; max-height: 300px; overflow-y: auto; }
.VariantOverlay.active { display: block; }
.VariantGroup { padding: 8px 12px; font-size: 12px; background: rgba(140, 149, 159, 0.1); }
.VariantItem { display: block; padding: 6px 12px; color: inherit; text-decoration: none; }
.VariantItem:hover { background-color: var(--bgColor-muted, rgba(140, 149, 159, 0.1)); }
.VariantItem.active { font-weight: bold; border-left: 2px solid var(--fgColor-accent); }
EOF

```
