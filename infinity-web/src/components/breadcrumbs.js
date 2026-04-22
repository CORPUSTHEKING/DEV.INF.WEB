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
