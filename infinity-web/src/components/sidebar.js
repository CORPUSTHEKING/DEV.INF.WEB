import { FULL_HEADER_HEIGHT } from '../constants.js';

export const renderSidebar = () => `
  <nav class="SidebarBox" style="top:${FULL_HEADER_HEIGHT}px; height: calc(100vh - ${FULL_HEADER_HEIGHT}px);">
    <div id="sidebar-scroll" class="SidebarBox_1" onscroll="window.sessionStorage.setItem('sidebar', this.scrollTop)">
      <div class="SidebarBox_2" id="sidebar-nav-mount"></div>
    </div>
  </nav>
`;

export default renderSidebar;
