import useSiteMetadata from './hooks/use-site-metadata.js';

const buildTitle = (...parts) => [...new Set(parts.filter(Boolean))].join(' | ');

export const updateHead = (frontmatter = {}) => {
  const siteMetadata = useSiteMetadata();
  const title = buildTitle(frontmatter.title, siteMetadata.title);
  const description = frontmatter.description || siteMetadata.description;

  document.title = title;

  const ensureMeta = (name, content, attr = 'name') => {
    let el = document.head.querySelector(`meta[${attr}="${name}"]`);
    if (!el) {
      el = document.createElement('meta');
      el.setAttribute(attr, name);
      document.head.appendChild(el);
    }
    el.setAttribute('content', content || '');
  };

  ensureMeta('description', description);
  ensureMeta('og:title', title, 'property');
  ensureMeta('og:description', description, 'property');
  ensureMeta('og:image', siteMetadata.imageUrl || '/favicon.png', 'property');
  ensureMeta('twitter:card', 'summary_large_image', 'name');
};

export default updateHead;
