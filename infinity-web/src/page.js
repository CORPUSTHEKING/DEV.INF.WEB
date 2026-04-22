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
