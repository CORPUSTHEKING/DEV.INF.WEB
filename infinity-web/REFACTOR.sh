#!/data/data/com.termux/files/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
cd "$ROOT"

mkdir -p \
  src/components/__tests__ \
  src/hooks \
  src/mdx \
  src/util \
  src/pages \
  content \
  config \
  assets/css

cat <<'EOF' > src/constants.js
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
EOF

cat <<'EOF' > config/site.json
{
  "title": "Infinity Web",
  "description": "A modular static site scaffold for Astro + vanilla JS.",
  "imageUrl": "/favicon.png",
  "repositoryUrl": "https://github.com/CORPUSTHEKING/DEV.INF.WEB.git",
  "navigation": [
    {
      "title": "Home",
      "shortName": "Home",
      "url": "/"
    },
    {
      "title": "Docs",
      "shortName": "Docs",
      "url": "/docs",
      "children": [
        {
          "title": "Assistance",
          "shortName": "Help",
          "url": "/docs/assistance"
        },
        {
          "title": "Devices",
          "shortName": "Devices",
          "url": "/docs/devices"
        },
        {
          "title": "Download",
          "shortName": "Download",
          "url": "/docs/download"
        },
        {
          "title": "Platforms",
          "shortName": "Platforms",
          "url": "/docs/platforms"
        },
        {
          "title": "Terminal",
          "shortName": "Terminal",
          "url": "/docs/terminal"
        }
      ],
      "variants": [
        {
          "type": "current",
          "title": "Current",
          "url": "/docs"
        },
        {
          "type": "legacy",
          "title": "Legacy",
          "url": "/docs/legacy"
        }
      ]
    }
  ]
}
EOF

cat <<'EOF' > content/header-nav.json
[
  { "title": "Docs", "url": "/docs" },
  { "title": "Search", "url": "/search" },
  { "title": "GitHub", "url": "https://github.com/CORPUSTHEKING/DEV.INF.WEB.git" }
]
EOF

cat <<'EOF' > assets/css/tokens.css
:root {
  --bg-color: #ffffff;
  --text-color: #111111;
  --fgColor-default: #24292f;
  --fgColor-muted: #57606a;
  --fgColor-accent: #0969da;
  --bgColor-default: #ffffff;
  --bgColor-muted: rgba(140, 149, 159, 0.1);
  --borderColor-default: #d0d7de;
  --header-height: 56px;
  --header-bar: 10px;
  --full-header-height: 66px;
  --scroll-margin-top: 90px;
}
EOF

cat <<'EOF' > src/theme.js
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
EOF

cat <<'EOF' > src/layout.js
export class Layout {
  render() {
    const wrapper = document.createElement('div');
    wrapper.className = 'layout-root';
    wrapper.innerHTML = `
      <header id="site-header"></header>
      <div class="main-container">
        <aside id="site-sidebar"></aside>
        <main id="page-content"></main>
      </div>
      <footer id="site-footer"></footer>
    `;
    return wrapper;
  }
}

export const renderLayout = () => new Layout().render();
EOF

cat <<'EOF' > src/page.js
import {
  HEADER_HEIGHT,
  HEADER_BAR,
  FULL_HEADER_HEIGHT,
  SCROLL_MARGIN_TOP,
  Z_INDEX,
  SKIP_TO_SEARCH_ID,
  SKIP_TO_CONTENT_ID,
} from './constants.js';

export const initGlobalStyles = () => {
  const id = 'infinity-web-global-styles';
  if (document.getElementById(id)) return;

  const style = document.createElement('style');
  style.id = id;
  style.textContent = `
    :root {
      --header-height: ${HEADER_HEIGHT}px;
      --header-bar: ${HEADER_BAR}px;
      --full-header-height: ${FULL_HEADER_HEIGHT}px;
      --scroll-margin-top: ${SCROLL_MARGIN_TOP}px;
      --z-header: ${Z_INDEX.HEADER};
      --z-search-overlay: ${Z_INDEX.SEARCH_OVERLAY};
    }
    html {
      scroll-behavior: smooth;
    }
    body {
      margin: 0;
      color: var(--text-color);
      background: var(--bg-color);
      font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    }
    #${SKIP_TO_CONTENT_ID} {
      scroll-margin-top: ${SCROLL_MARGIN_TOP}px;
    }
    #${SKIP_TO_SEARCH_ID} {
      scroll-margin-top: ${SCROLL_MARGIN_TOP}px;
    }
  `;
  document.head.appendChild(style);
};

export const renderPageElement = ({ title = '', content = '' } = {}) => {
  const section = document.createElement('section');
  section.className = 'PageBox';
  section.innerHTML = `
    <div class="PageBox_1">
      <div class="PageBox_2">
        <h1>${title}</h1>
        <div class="PageContent">${content}</div>
      </div>
    </div>
  `;
  return section;
};

export default renderPageElement;
EOF

cat <<'EOF' > src/head.js
import useSiteMetadata from './hooks/use-site-metadata.js';

const buildTitle = (...parts) => [...new Set(parts.filter(Boolean))].join(' | ');

export const updateHead = (frontmatter = {}) => {
  const siteMetadata = useSiteMetadata();
  const title = buildTitle(frontmatter.title, siteMetadata.title);
  const description = frontmatter.description || siteMetadata.description;

  document.title = title;

  const ensureMeta = (name, content, attr = 'name') => {
    let el = document.head.querySelector(`meta[${attr}="${name}"]`);
    if (!el) {
      el = document.createElement('meta');
      el.setAttribute(attr, name);
      document.head.appendChild(el);
    }
    el.setAttribute('content', content || '');
  };

  ensureMeta('description', description);
  ensureMeta('og:title', title, 'property');
  ensureMeta('og:description', description, 'property');
  ensureMeta('og:image', siteMetadata.imageUrl || '/favicon.png', 'property');
  ensureMeta('twitter:card', 'summary_large_image', 'name');
};

export default updateHead;
EOF

cat <<'EOF' > src/shared.js
const shared = {
  'user-login': {
    text: `On the npm "<a href="https://www.npmjs.com/login">Sign In</a>" page, enter your account details and click <strong>Sign In</strong>.`,
    image: `<img src="/shared/user-login.png" alt="Screenshot of npm login dialog" />`
  },
  'account-settings': {
    text: `Open account settings to change profile, billing, and security details.`,
    image: `<img src="/shared/account-settings.png" alt="Screenshot of account settings" />`
  },
  'billing-info': {
    text: `Billing pages explain payment methods, invoices, and plan changes.`,
    image: `<img src="/shared/billing-info.png" alt="Screenshot of billing information" />`
  }
};

export default shared;
EOF

cat <<'EOF' > src/util/get-nav.js
import siteData from '../../config/site.json';

const NAV = siteData.navigation || [];

const normalize = (path = '') => {
  if (!path) return '/';
  const [base] = String(path).split('#');
  return base.replace(/\/+$/, '') || '/';
};

const walk = (nodes, fn, parent = null) => {
  for (const node of nodes || []) {
    fn(node, parent);
    if (node.children?.length) walk(node.children, fn, node);
  }
};

export const getNavigation = async () => NAV.slice();

export const getNavigationSync = () => NAV.slice();

export const getItem = (url, tree = NAV) => {
  let found = null;
  walk(tree, (node) => {
    if (!found && normalize(node.url) === normalize(url)) found = node;
  });
  return found;
};

export const isActiveUrl = (pathname, url) => normalize(pathname) === normalize(url);

export const isPathForItem = (pathname, item) => {
  if (!item) return false;
  const current = normalize(pathname);
  const target = normalize(item.url);
  return current === target || current.startsWith(target + '/');
};

export const getItemBreadcrumbs = (pathname, options = {}) => {
  const { hideVariants = false } = options;
  const crumbs = [];
  const target = getItem(pathname);

  if (!target) return crumbs;

  const climb = (nodes, parentTrail = []) => {
    for (const node of nodes || []) {
      const nextTrail = parentTrail.concat(node);
      if (normalize(node.url) === normalize(target.url)) {
        crumbs.push(...nextTrail);
        return true;
      }
      if (node.children?.length && climb(node.children, nextTrail)) return true;
    }
    return false;
  };

  climb(NAV);
  if (hideVariants) return crumbs.filter((item) => !item.variant);
  return crumbs;
};

export const getHierarchy = (item = null, pathname = '', options = {}) => {
  const { hideVariants = false } = options;
  const source = item ? item.children || [] : NAV;
  const current = normalize(pathname);
  return source
    .filter((node) => !hideVariants || !node.variant)
    .map((node) => ({
      ...node,
      active: isPathForItem(current, node),
      children: getHierarchy(node, current, options),
    }));
};

export const getVariantsForPath = (pathname) => {
  const item = getItem(pathname);
  if (!item?.variants?.length) return [];
  return item.variants.map((variant) => ({
    ...variant,
    active: isActiveUrl(pathname, variant.url),
  }));
};

export const getUrlForItem = (item) => item?.url || '/';

export default {
  getNavigation,
  getNavigationSync,
  getItem,
  isActiveUrl,
  isPathForItem,
  getItemBreadcrumbs,
  getHierarchy,
  getVariantsForPath,
  getUrlForItem,
};
EOF

cat <<'EOF' > src/hooks/use-site-metadata.js
import siteData from '../../config/site.json';

let cache = null;

export default function useSiteMetadata() {
  if (!cache) {
    cache = {
      title: siteData.title || 'Infinity Web',
      description: siteData.description || '',
      imageUrl: siteData.imageUrl || '/favicon.png',
      repositoryUrl: siteData.repositoryUrl || '',
      navigation: siteData.navigation || [],
    };
  }
  return cache;
}
EOF

cat <<'EOF' > src/hooks/use-breakpoint.js
export const useMediaQuery = (query) => {
  if (typeof window === 'undefined') return false;
  return window.matchMedia(query).matches;
};

export const useBreakpoint = (breakpoint, minMax = 'min') => {
  const px = typeof breakpoint === 'string' ? parseInt(breakpoint, 10) : breakpoint;
  const adjusted = minMax === 'min' ? px : px - 1;
  return useMediaQuery(`(${minMax}-width: ${adjusted}px)`);
};

export const useIsMobile = () => useBreakpoint(768, 'max');

export default useBreakpoint;
EOF

cat <<'EOF' > src/hooks/use-location-change.js
export const createLocationChangeWatcher = (onChange) => {
  if (typeof window === 'undefined') return () => {};
  let previous = window.location.pathname;

  const handler = () => {
    const current = window.location.pathname;
    if (current !== previous) {
      onChange?.({ change: true, previous, current });
      previous = current;
    }
  };

  window.addEventListener('popstate', handler);
  window.addEventListener('hashchange', handler);

  return () => {
    window.removeEventListener('popstate', handler);
    window.removeEventListener('hashchange', handler);
  };
};

export default createLocationChangeWatcher;
EOF

cat <<'EOF' > src/hooks/use-page.js
export const usePage = async (pageName) => {
  try {
    const module = await import(`../pages/${pageName}.js`);
    return module.default || module;
  } catch (err) {
    console.error('Page load failed:', err);
    return null;
  }
};

export default usePage;
EOF

cat <<'EOF' > src/hooks/use-search.js
export const createSearchIndex = (items = []) => {
  const flat = [];
  const walk = (nodes) => {
    for (const node of nodes || []) {
      flat.push(node);
      if (node.children?.length) walk(node.children);
    }
  };
  walk(items);
  return flat;
};

export const searchItems = (items, query = '') => {
  const q = query.trim().toLowerCase();
  if (!q) return [];
  return createSearchIndex(items).filter((item) => {
    const haystack = [item.title, item.shortName, item.url].filter(Boolean).join(' ').toLowerCase();
    return haystack.includes(q);
  });
};

export default searchItems;
EOF

cat <<'EOF' > src/mdx/code.js
export const renderCodeBlock = (code = '', language = '') => {
  const pre = document.createElement('pre');
  pre.className = `CodeBlock language-${language}`.trim();
  pre.textContent = code;
  return pre;
};

export default renderCodeBlock;
EOF

cat <<'EOF' > src/mdx/components.js
export const renderMdxComponents = (content = '') => {
  const wrapper = document.createElement('div');
  wrapper.className = 'mdx-components';
  wrapper.innerHTML = content;
  return wrapper;
};

export default renderMdxComponents;
EOF

cat <<'EOF' > src/mdx/nav-hierarchy.js
export const renderNavHierarchy = (items = []) => {
  if (!items.length) return '';
  return `
    <ul class="NavHierarchy">
      ${items
        .map(
          (item) => `
            <li>
              <a href="${item.url}">${item.title}</a>
              ${item.children?.length ? renderNavHierarchy(item.children) : ''}
            </li>
          `
        )
        .join('')}
    </ul>
  `;
};

export default renderNavHierarchy;
EOF

cat <<'EOF' > src/mdx/index.js
import { renderMdxComponents } from './components.js';
import { renderCodeBlock } from './code.js';

export const renderMarkdown = (content) => {
  const container = document.createElement('div');
  container.className = 'mdx-content';
  container.innerHTML = String(content || '')
    .replace(/```(\w+)?\n([\s\S]*?)```/g, (_, lang = '', code = '') => {
      const block = renderCodeBlock(code.trimEnd(), lang);
      return `<pre class="CodeBlock language-${lang}"><code>${block.textContent}</code></pre>`;
    });

  return renderMdxComponents(container.innerHTML);
};

export default renderMarkdown;
EOF

cat <<'EOF' > src/components/breadcrumbs.js
import * as getNav from '../util/get-nav.js';

export const renderBreadcrumbs = (pathname) => {
  const items = getNav.getItemBreadcrumbs(pathname, { hideVariants: true });
  if (items.length <= 1) return '';

  return `
    <nav aria-label="Breadcrumb" class="Breadcrumbs">
      <ol>
        ${items
          .map((item) => {
            const selected = getNav.isPathForItem(pathname, getNav.getItem(item.url));
            return `<li><a href="${item.url}" class="breadcrumb-item ${selected ? 'selected' : ''}">${item.shortName || item.title}</a></li>`;
          })
          .join('')}
      </ol>
    </nav>
  `;
};

export default renderBreadcrumbs;
EOF

cat <<'EOF' > src/components/header.js
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
EOF

cat <<'EOF' > src/components/header.css
.NpmHeaderBar { background-image: linear-gradient(139deg, #fb8817, #ff4b01, #c12127, #e02aff); }
.stickyHeader { top: 0; position: sticky; }
.HeaderBox_0, .HeaderBox_1 { display: flex; align-items: center; }
.SiteTitle { margin-right: 24px; }
.HeaderLink { display: block; margin-left: 24px; color: #e1e4e8; text-decoration: none; }
.headerBox { display: flex; height: 56px; padding: 0 16px; align-items: center; justify-content: space-between; background-color: #333333; border-bottom: 1px solid #444d56; }
.navDesktop { display: none; gap: 16px; }
.navMobile { display: flex; align-items: center; gap: 8px; }
@media (min-width: 768px) {
  .navDesktop { display: flex; }
  .navMobile { display: none; }
}
EOF

cat <<'EOF' > src/components/link.js
const FALLBACK = `http://_${Math.random().toString().slice(2)}._${Math.random().toString().slice(2)}`;

export const getLocalPath = (href) => {
  if (!href || href.startsWith('#')) return null;
  try {
    const url = new URL(href, FALLBACK);
    if (url.host === 'docs.npmjs.com' || url.origin === FALLBACK) {
      return `${url.pathname}${url.search}${url.hash}`;
    }
  } catch {
    return null;
  }
  return null;
};

export const renderLink = (href, label, className = '') => {
  const local = getLocalPath(href);
  const attrs = local
    ? `href="${local}"`
    : `href="${href}" target="_blank" rel="noreferrer noopener"`;
  return `<a ${attrs} class="${className}">${label}</a>`;
};

export default { getLocalPath, renderLink };
EOF

cat <<'EOF' > src/components/link.css
a { color: inherit; }
a:hover { text-decoration: underline; }
EOF

cat <<'EOF' > src/components/nav-drawer.js
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
EOF

cat <<'EOF' > src/components/nav-drawer.css
.DrawerButton { background: transparent; border: 0; color: inherit; cursor: pointer; padding: 8px; }
.NavDrawer { position: fixed; inset: 0; display: none; z-index: 100; }
.NavDrawer.open { display: block; }
.NavDrawerOverlay { position: absolute; inset: 0; background: rgba(0, 0, 0, 0.5); }
.NavDrawerPanel { position: absolute; right: 0; top: 0; width: min(85vw, 360px); height: 100%; background: var(--bgColor-default); padding: 16px; overflow-y: auto; }
.NavDrawerTitle { display: block; margin-bottom: 16px; }
EOF

cat <<'EOF' > src/components/nav-items.js
import * as getNav from '../util/get-nav.js';
import headerNavItems from '../../content/header-nav.json';

export const renderNavItems = (pathname, repositoryUrl) => {
  const items = getNav.getHierarchy(null, pathname, { hideVariants: true });

  const buildTree = (nodes, depth = 1) =>
    nodes
      .map((item) => {
        const isCurrent = getNav.isActiveUrl(pathname, item.url);
        const children = getNav.getHierarchy(item, item.url, { hideVariants: true });
        const depthClass = depth === 1 ? 'NavList_Item_depth1' : 'NavList_Item_depth2';
        let html = `<a href="${item.url}" class="NavListItem ${depthClass}" ${isCurrent ? 'aria-current="page"' : ''}>${item.shortName || item.title}</a>`;
        if (children.length) html += `<div class="NavChildren">${buildTree(children, depth + 1)}</div>`;
        return html;
      })
      .join('');

  const externalLinks = headerNavItems
    .filter((item) => /^https?:\/\//.test(item.url))
    .map((item) => `<a class="NavListItem" href="${item.url}" target="_blank" rel="noreferrer noopener">${item.title}</a>`)
    .join('');

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

export default renderNavItems;
EOF

cat <<'EOF' > src/components/nav-items.css
.NavListRoot { display: grid; gap: 4px; }
.NavListItem { display: block; padding: 8px 0; color: inherit; text-decoration: none; }
.NavList_Item_depth1 { font-size: 16px; font-weight: 600; }
.NavList_Item_depth2 { font-size: 14px; margin-left: 16px; opacity: 0.9; }
.NavListItem[aria-current="page"] { font-weight: 700; text-decoration: underline; }
.NavDivider { border: 0; border-top: 1px solid var(--borderColor-default); margin: 12px 0; }
.NavChildren { margin-left: 12px; }
EOF

cat <<'EOF' > src/components/page-footer.js
const months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
const format = (d) => `${months[d.getMonth()]} ${d.getDate()}, ${d.getFullYear()}`;
const pluralize = (word, count) => `${count} ${word}${count === 1 ? '' : 's'}`;

export const renderPageFooter = (contributors = []) => {
  let contributorsHtml = '';

  if (contributors.length) {
    const avatars = contributors
      .map(
        (login) => `
          <a href="https://github.com/${login}" class="FooterLink" title="${login}">
            <img src="https://github.com/${login}.png?size=40" alt="${login}" class="Avatar" />
          </a>
        `
      )
      .join('');
    contributorsHtml = `<div class="FooterContributors">${avatars}</div>`;
  }

  return `
    <div class="PageFooter">
      <p class="FooterMeta">Updated ${format(new Date())}</p>
      <p class="FooterMeta">${pluralize('contributor', contributors.length)}</p>
      ${contributorsHtml}
    </div>
  `;
};

export default renderPageFooter;
EOF

cat <<'EOF' > src/components/page-footer.css
.PageFooter { margin-top: 32px; padding: 24px 0; border-top: 1px solid var(--borderColor-default); }
.FooterMeta { margin: 0 0 8px; color: var(--fgColor-muted); }
.FooterLink { display: inline-flex; margin-right: 8px; }
.Avatar { width: 40px; height: 40px; border-radius: 999px; }
.FooterContributors { display: flex; flex-wrap: wrap; gap: 8px; }
EOF

cat <<'EOF' > src/components/search.js
import { HEADER_BAR, HEADER_HEIGHT, Z_INDEX } from '../constants.js';

export const renderSearchDesktop = () => `
  <div class="SearchBox_2">
    <input type="text" placeholder="Search" aria-label="Search" class="TextInput DesktopSearchInput" id="search-desktop" />
    <div class="SearchResultsContainer" id="search-results-desktop" style="z-index:${Z_INDEX.SEARCH_OVERLAY};"></div>
  </div>
`;

export const renderSearchMobile = () => `
  <div class="MobileSearchOverlay" id="mobile-search-overlay">
    <div class="MobileSearchHeader" style="height:${HEADER_HEIGHT}px;">
      <input type="text" placeholder="Search" aria-label="Search" class="TextInput MobileTextInput" id="search-mobile" />
      <button aria-label="Cancel" class="SearchCancelBtn" onclick="document.getElementById('mobile-search-overlay').classList.remove('open')">X</button>
    </div>
    <div class="MobileSearchResults LightTheme" id="search-results-mobile"></div>
  </div>
`;

export default { renderSearchDesktop, renderSearchMobile };
EOF

cat <<'EOF' > src/components/search.css
.SearchBox_2 { position: relative; }
.SearchResultsContainer { position: absolute; left: 0; right: 0; top: 100%; background: var(--bgColor-default); border: 1px solid var(--borderColor-default); }
.MobileSearchOverlay { display: none; position: fixed; inset: 0; background: var(--bgColor-default); z-index: 50; }
.MobileSearchOverlay.open { display: block; }
.MobileSearchHeader { display: flex; align-items: center; gap: 8px; padding: 8px 12px; border-bottom: 1px solid var(--borderColor-default); }
.SearchCancelBtn { background: transparent; border: 0; cursor: pointer; }
.TextInput { width: 100%; padding: 8px 12px; border: 1px solid var(--borderColor-default); border-radius: 6px; font-size: 16px; }
.DesktopSearchInput { min-width: 220px; }
.MobileTextInput { flex: 1; }
EOF

cat <<'EOF' > src/components/sidebar.js
import { FULL_HEADER_HEIGHT } from '../constants.js';

export const renderSidebar = () => `
  <nav class="SidebarBox" style="top:${FULL_HEADER_HEIGHT}px; height: calc(100vh - ${FULL_HEADER_HEIGHT}px);">
    <div id="sidebar-scroll" class="SidebarBox_1" onscroll="window.sessionStorage.setItem('sidebar', this.scrollTop)">
      <div class="SidebarBox_2" id="sidebar-nav-mount"></div>
    </div>
  </nav>
`;

export default renderSidebar;
EOF

cat <<'EOF' > src/components/sidebar.css
.SidebarBox { position: sticky; overflow: hidden; }
.SidebarBox_1 { overflow-y: auto; max-height: 100%; padding: 16px; }
.SidebarBox_2 { display: grid; gap: 8px; }
EOF

cat <<'EOF' > src/components/site-title.js
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

export default renderSiteTitle;
EOF

cat <<'EOF' > src/components/site-title.css
.SiteTitleLink { display: inline-flex; align-items: center; gap: 8px; color: inherit; text-decoration: none; font-weight: 700; }
.NpmLogoBox { display: inline-flex; width: 32px; height: 32px; }
EOF

cat <<'EOF' > src/components/skip-nav.js
import { SCROLL_MARGIN_TOP, SKIP_TO_CONTENT_ID, SKIP_TO_SEARCH_ID } from '../constants.js';

export const renderSkipNav = () => `
  <div class="SkipBox">
    <a class="SkipLink" href="#${SKIP_TO_CONTENT_ID}">Skip to content</a>
    <a class="SkipLink" href="#${SKIP_TO_SEARCH_ID}">Skip to search</a>
  </div>
`;

export const renderSkipNavPlaceholder = () => `
  <div id="${SKIP_TO_CONTENT_ID}" style="scroll-margin-top:${SCROLL_MARGIN_TOP}px;"></div>
`;

export default renderSkipNav;
EOF

cat <<'EOF' > src/components/visually-hidden.js
export const VISUALLY_HIDDEN_CLASS = 'VisuallyHidden';
EOF

cat <<'EOF' > src/components/util.css
.VisuallyHidden {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}
.SkipBox {
  display: inline-flex;
  z-index: 20;
  left: 10px;
  gap: 3px;
  position: absolute;
  transform: translateY(-100%);
  transition: transform 0.3s;
  padding: 8px;
  background-color: var(--bgColor-default);
  border: 1px solid var(--fgColor-accent);
  border-top: 0;
  font-size: 12px;
  border-radius: 0 0 6px 6px;
}
.SkipBox:focus-within { transform: translateY(0%); }
.SkipLink { color: var(--fgColor-accent); padding: 4px; }
.SkipLink:focus { text-decoration: underline; }
EOF

cat <<'EOF' > src/components/table-of-contents.js
export const renderTOCItems = (items) => {
  if (!items || !items.length) return '';
  return `<ul class="TOCNavList">${items.map(item => `
    <li>
      <a href="${item.url}">${item.title}</a>
      ${item.items ? renderTOCItems(item.items) : ''}
    </li>
  `).join('')}</ul>`;
};

export const renderTOCDesktop = (items) => {
  if (!items) return '';
  return `
    <aside class="tocDesktop">
      <nav class="TOCDetails">
        <div class="TOCHeading">Table of contents</div>
        ${renderTOCItems(items)}
      </nav>
    </aside>
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

export default { renderTOCItems, renderTOCDesktop, renderTOCMobile };
EOF

cat <<'EOF' > src/components/table-of-contents.css
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

cat <<'EOF' > src/components/text-input.js
export const renderTextInput = (props = {}) => {
  const {
    id = '',
    placeholder = 'Search',
    ariaLabel = 'Search',
    className = 'TextInput',
    type = 'text',
    value = '',
  } = props;

  return `<input type="${type}" id="${id}" placeholder="${placeholder}" aria-label="${ariaLabel}" class="${className}" value="${value}" />`;
};

export default renderTextInput;
EOF

cat <<'EOF' > src/components/text-input.css
.TextInput {
  width: 100%;
  box-sizing: border-box;
  padding: 8px 12px;
  border: 1px solid var(--borderColor-default);
  border-radius: 6px;
  font-size: 16px;
}
.TextInput::placeholder { opacity: 0.7; }
EOF

cat <<'EOF' > src/components/variant-select.js
import * as getNav from '../util/get-nav.js';

export const renderVariantSelect = (pathname) => {
  const variantPages = getNav.getVariantsForPath(pathname);
  if (!variantPages || !variantPages.length) return '';

  const result = {
    title: 'Select CLI Version:',
    current: null,
    latest: null,
    prerelease: null,
    legacy: [],
  };

  variantPages.forEach((item) => {
    switch (item.type) {
      case 'latest': result.latest = item; break;
      case 'current': result.current = item; break;
      case 'prerelease': result.prerelease = item; break;
      default: result.legacy.push(item);
    }
  });

  const link = (item) => `<a class="VariantItem ${item.active ? 'active' : ''}" href="${item.url}">${item.title}</a>`;

  return `
    <div class="VariantBox_1">
      <p id="label-versions" class="VariantLabel">${result.title}</p>
      <div class="VariantDropdown">
        <button class="VariantMenuButton" onclick="this.nextElementSibling.classList.toggle('active')">${result.current?.title || 'Versions'} ▼</button>
        <div class="VariantOverlay">
          ${result.current ? `<div class="VariantGroup"><strong>Current</strong></div>${link(result.current)}` : ''}
          ${result.latest ? `<div class="VariantGroup"><strong>Latest</strong></div>${link(result.latest)}` : ''}
          ${result.prerelease ? `<div class="VariantGroup"><strong>Prerelease</strong></div>${link(result.prerelease)}` : ''}
          ${result.legacy.length ? `<div class="VariantGroup"><strong>Legacy</strong></div>${result.legacy.map(link).join('')}` : ''}
        </div>
      </div>
    </div>
  `;
};

export default renderVariantSelect;
EOF

cat <<'EOF' > src/components/variant-select.css
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

cat <<'EOF' > src/components/page-footer.test.js
import { renderPageFooter } from '../page-footer.js';

console.assert(typeof renderPageFooter === 'function', 'renderPageFooter should be a function');
EOF

cat <<'EOF' > src/layout.css
.Box { width: 100%; max-width: 960px; }
.Box_1 { width: 100%; }
.Box_2 {
  justify-content: center;
  display: flex;
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
  padding: 24px;
}
@media (min-width: 544px) { .Box_2 { padding: 32px; } }
@media (min-width: 768px) { .Box_2 { padding: 40px; } }
@media (min-width: 1012px) { .Box_2 { padding: 48px; } }
.Box_3 { margin-bottom: 24px; }
.layout-root { min-height: 100vh; display: flex; flex-direction: column; }
.main-container { display: flex; flex: 1 1 auto; }
EOF

cat <<'EOF' > src/page.css
.PageBox {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}
.PageBox_1 {
  z-index: 0;
  display: flex;
  flex: 1 1 auto;
  flex-direction: row;
}
.PageBox_2 { width: 100%; padding: 24px; }
.sidebarContainer { display: none; }
@media (min-width: 1012px) {
  .sidebarContainer { display: block; }
}
EOF

cat <<'EOF' > src/root.js
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
EOF

cat <<'EOF' > src/pages/assistance.js
export default function renderAssistancePage() {
  return `<section><h1>Assistance</h1><p>Help and support content.</p></section>`;
}
EOF

cat <<'EOF' > src/pages/devices.js
export default function renderDevicesPage() {
  return `<section><h1>Devices</h1><p>Device compatibility content.</p></section>`;
}
EOF

cat <<'EOF' > src/pages/disclaimer.js
export default function renderDisclaimerPage() {
  return `<section><h1>Disclaimer</h1><p>Disclaimer content.</p></section>`;
}
EOF

cat <<'EOF' > src/pages/download.js
export default function renderDownloadPage() {
  return `<section><h1>Download</h1><p>Download instructions.</p></section>`;
}
EOF

cat <<'EOF' > src/pages/iwl.js
export default function renderIwlPage() {
  return `<section><h1>IWL</h1><p>IWL content.</p></section>`;
}
EOF

cat <<'EOF' > src/pages/platforms.js
export default function renderPlatformsPage() {
  return `<section><h1>Platforms</h1><p>Platform support content.</p></section>`;
}
EOF

cat <<'EOF' > src/pages/report.js
export default function renderReportPage() {
  return `<section><h1>Report</h1><p>Report content.</p></section>`;
}
EOF

cat <<'EOF' > src/pages/request.js
export default function renderRequestPage() {
  return `<section><h1>Request</h1><p>Request content.</p></section>`;
}
EOF

cat <<'EOF' > src/pages/review.js
export default function renderReviewPage() {
  return `<section><h1>Review</h1><p>Review content.</p></section>`;
}
EOF

cat <<'EOF' > src/pages/search.js
export default function renderSearchPage() {
  return `<section><h1>Search</h1><p>Search content.</p></section>`;
}
EOF

cat <<'EOF' > src/pages/share.js
export default function renderSharePage() {
  return `<section><h1>Share</h1><p>Share content.</p></section>`;
}
EOF

cat <<'EOF' > src/pages/sponsor.js
export default function renderSponsorPage() {
  return `<section><h1>Sponsor</h1><p>Sponsor content.</p></section>`;
}
EOF

cat <<'EOF' > src/pages/terminal.js
export default function renderTerminalPage() {
  return `<section><h1>Terminal</h1><p>Terminal content.</p></section>`;
}
EOF

cat <<'EOF' > src/pages/upload.js
export default function renderUploadPage() {
  return `<section><h1>Upload</h1><p>Upload content.</p></section>`;
}
EOF
