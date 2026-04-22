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
