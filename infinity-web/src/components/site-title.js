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
