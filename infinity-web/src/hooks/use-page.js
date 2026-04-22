export const usePage = async (pageName) => {
  try {
    const module = await import(`../pages/${pageName}.js`);
    return module.default || module;
  } catch (err) {
    console.error('Page load failed:', err);
    return null;
  }
};

export default usePage;
