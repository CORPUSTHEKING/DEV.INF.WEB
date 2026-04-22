export const createSearchIndex = (items = []) => {
  const flat = [];
  const walk = (nodes) => {
    for (const node of nodes || []) {
      flat.push(node);
      if (node.children?.length) walk(node.children);
    }
  };
  walk(items);
  return flat;
};

export const searchItems = (items, query = '') => {
  const q = query.trim().toLowerCase();
  if (!q) return [];
  return createSearchIndex(items).filter((item) => {
    const haystack = [item.title, item.shortName, item.url].filter(Boolean).join(' ').toLowerCase();
    return haystack.includes(q);
  });
};

export default searchItems;
