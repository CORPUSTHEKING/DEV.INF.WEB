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
