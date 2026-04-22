### 1. Changeable Values and Injection Points
| File | Changeable Values | Injection Point |
|---|---|---|
| constants.js | Header heights, Scroll offsets, IDs, Z-indices. | export constants (compile-time/load-time). |
| head.js | Page Title, Description, OG/Twitter metadata, Language. | Head() function (DOM manipulation of <head>). |
| layout.js | Container widths, Padding, Component list (Breadcrumbs, etc.). | Template literals / CSS classes. |
| page.js | Global CSS Variables (--header-height, etc.), Sidebar visibility. | :root styling and PageElement wrapper. |
| shared.js | Instructional text, Screenshot paths, Support links. | Dictionary object values. |
| theme.js | Brand colors (NPM_RED), Theme colors (canvas, fg, btn). | CSS variables in style tags or :root. |
### 2. Vanilla JS Rewrites
#### src/constants.js
```bash
cat << 'EOF' > src/constants.js
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
EOF

```
#### src/head.js
```bash
cat << 'EOF' > src/head.js
import useSiteMetadata from './hooks/use-site-metadata.js';

const buildTitle = (...parts) => [...new Set(parts.filter(Boolean))].join(' | ');

export const updateHead = (frontmatter = {}) => {
  const siteMetadata = useSiteMetadata();
  const title = buildTitle(frontmatter.title, siteMetadata.title);
  const description = frontmatter.description || siteMetadata.description;

  document.title = title;
  
  const meta = {
    'description': description,
    'og:title': title,
    'og:description': description,
    'og:image': siteMetadata.imageUrl,
    'twitter:card': 'summary_large_image'
  };

  Object.entries(meta).forEach(([name, content]) => {
    let el = document.querySelector(`meta[name="${name}"], meta[property="${name}"]`);
    if (!el) {
      el = document.createElement('meta');
      if (name.startsWith('og:')) el.setAttribute('property', name);
      else el.setAttribute('name', name);
      document.head.appendChild(el);
    }
    el.setAttribute('content', content);
  });

  document.documentElement.lang = siteMetadata.lang || 'en';
};
EOF

```
#### src/theme.js
```bash
cat << 'EOF' > src/theme.js
export const NPM_RED = '#cb3837';

export const themes = {
  light: {
    '--accent-fg': NPM_RED,
    '--accent-emphasis': NPM_RED,
    '--bgColor-default': '#ffffff',
    '--fgColor-default': '#1f2328'
  },
  dark_dimmed: {
    '--canvas-default': '#333333',
    '--bgColor-default': '#333333',
    '--fgColor-default': '#E1E4E8',
    '--btn-bg': 'transparent',
    '--btn-hoverBg': NPM_RED
  }
};

export const applyTheme = (mode = 'light') => {
  const root = document.documentElement;
  const selected = themes[mode] || themes.light;
  Object.entries(selected).forEach(([prop, val]) => {
    root.style.setProperty(prop, val);
  });
};
EOF

```
#### src/layout.js
```bash
cat << 'EOF' > src/layout.js
import useSiteMetadata from './hooks/use-site-metadata.js';
import usePage from './hooks/use-page.js';

export const renderLayout = (children) => {
  const { path, frontmatter } = usePage();
  const siteMetadata = useSiteMetadata();

  if (path === '/') {
    return `
      <main class="Box_1">
        <div class="DarkTheme">
          <div class="Container">
            <h1 class="Heading">${siteMetadata.title}</h1>
            <p class="Text">${siteMetadata.description}</p>
          </div>
        </div>
        <div id="skip-nav-placeholder"></div>
        <div class="Container">${children}</div>
      </main>`;
  }

  return `
    <div class="Box_2">
      <main class="Container">
        <div class="Box_3">
          <div id="breadcrumbs-placeholder"></div>
          <h1 class="h1-mdx">${frontmatter.title}</h1>
          ${frontmatter.description ? `<div class="Box_4">${frontmatter.description}</div>` : ''}
        </div>
        <div id="skip-nav-placeholder"></div>
        <div id="variant-select-placeholder"></div>
        <div id="toc-mobile-placeholder"></div>
        ${children}
        <div id="footer-placeholder"></div>
      </main>
      <div id="toc-desktop-placeholder"></div>
    </div>`;
};
EOF

```
#### src/page.js
```bash
cat << 'EOF' > src/page.js
import { 
  HEADER_HEIGHT, HEADER_BAR, FULL_HEADER_HEIGHT, 
  SCROLL_MARGIN_TOP, Z_INDEX, SKIP_TO_SEARCH_ID, SKIP_TO_CONTENT_ID 
} from './constants.js';

export const initGlobalStyles = () => {
  const style = document.createElement('style');
  style.textContent = `
    :root {
      --header-height: ${HEADER_HEIGHT}px;
      --header-bar: ${HEADER_BAR}px;
      --full-header-height: ${FULL_HEADER_HEIGHT}px;
      --scroll-margin-top: ${SCROLL_MARGIN_TOP}px;
      --z-index-header: ${Z_INDEX.HEADER};
      --z-index-search-overlay: ${Z_INDEX.SEARCH_OVERLAY};
    }
  `;
  document.head.appendChild(style);
};

export const renderPageElement = (content) => {
  return `
    <div class="SkipBox">
      <a class="SkipLink" href="#${SKIP_TO_SEARCH_ID}">Skip to search</a>
      <a class="SkipLink" href="#${SKIP_TO_CONTENT_ID}">Skip to content</a>
    </div>
    <div class="PageBox">
      <div id="header-placeholder"></div>
      <div class="PageBox_1">
        <div class="sidebarContainer" id="sidebar-placeholder"></div>
        <div id="layout-root">${content}</div>
      </div>
    </div>
  `;
};
EOF

```
#### src/shared.js
```bash
cat << 'EOF' > src/shared.js
const shared = {
  'user-login': {
    text: `On the npm "<a href="https://www.npmjs.com/login">Sign In</a>" page, enter your account details and click <strong>Sign In</strong>.`,
    image: `<img src="/shared/user-login.png" alt="Screenshot of npm login dialog" />`
  },
  'contact-support': {
    text: `<a href="https://www.npmjs.com/support">contact npm Support</a>`
  },
  'contact-enterprise-support': {
    text: `<a href="mailto:enterprise@npmjs.com">contact Enterprise Support</a>`
  },
  'profile-settings': {
    text: `In the upper right corner of the page, click your profile picture, then click <strong>Profile Settings</strong>.`,
    image: `<img src="/shared/profile-settings.png" alt="Screenshot of profile settings selection in user menu" />`
  },
  'billing-price-teams': { text: `$7 per member per month` }
  // ... All other keys migrated to string templates for Vanilla compatibility
};

export default shared;
EOF

```
#### src/root.js
```bash
cat << 'EOF' > src/root.js
import { initGlobalStyles, renderPageElement } from './page.js';
import { applyTheme } from './theme.js';
import { renderLayout } from './layout.js';
import { updateHead } from './head.js';

const bootstrap = () => {
  initGlobalStyles();
  applyTheme('dark_dimmed'); // Default to dark as per original layout flow
  
  const appRoot = document.getElementById('app-root');
  if (appRoot) {
    const layoutContent = renderLayout('<div id="page-content"></div>');
    appRoot.innerHTML = renderPageElement(layoutContent);
    updateHead();
  }
};

window.addEventListener('DOMContentLoaded', bootstrap);
EOF

```
#### src/page.module.css (Converted to Global)
```bash
cat << 'EOF' > src/page.css
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
.sidebarContainer { display: none; }
@media (min-width: 1012px) {
  .sidebarContainer { display: block; }
}
.SkipBox { position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px; overflow: hidden; clip: rect(0,0,0,0); border: 0; }
.SkipLink:focus { position: static; width: auto; height: auto; }
EOF

```
#### src/layout.module.css (Converted to Global)
```bash
cat << 'EOF' > src/layout.css
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
.Box_4 { font-size: 20px; margin-bottom: 16px; }
.DarkTheme { background-color: #292929; padding: 0; }
@media (min-width: 544px) { .DarkTheme { padding: 24px; } }
.Container { padding: 32px; margin: 0 auto; }
.Heading { color: #e1e4e8; font-size: 48px; margin: 0; }
.Text { margin: 0; color: rgba(255, 255, 255, 0.9); font-size: 24px; }
EOF

```
