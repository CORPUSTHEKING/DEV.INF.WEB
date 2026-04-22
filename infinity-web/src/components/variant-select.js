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
