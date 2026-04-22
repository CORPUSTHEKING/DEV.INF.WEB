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
