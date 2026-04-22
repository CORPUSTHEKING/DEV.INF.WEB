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
