const FALLBACK = `http://_${Math.random().toString().slice(2)}._${Math.random().toString().slice(2)}`;

export const getLocalPath = (href) => {
  if (!href || href.startsWith('#')) return null;
  try {
    const url = new URL(href, FALLBACK);
    if (url.host === 'docs.npmjs.com' || url.origin === FALLBACK) {
      return `${url.pathname}${url.search}${url.hash}`;
    }
  } catch {
    return null;
  }
  return null;
};

export const renderLink = (href, label, className = '') => {
  const local = getLocalPath(href);
  const attrs = local
    ? `href="${local}"`
    : `href="${href}" target="_blank" rel="noreferrer noopener"`;
  return `<a ${attrs} class="${className}">${label}</a>`;
};

export default { getLocalPath, renderLink };
