import siteData from '../../config/site.json';

let cache = null;

export default function useSiteMetadata() {
  if (!cache) {
    cache = {
      title: siteData.title || 'Infinity Web',
      description: siteData.description || '',
      imageUrl: siteData.imageUrl || '/favicon.png',
      repositoryUrl: siteData.repositoryUrl || '',
      navigation: siteData.navigation || [],
    };
  }
  return cache;
}
