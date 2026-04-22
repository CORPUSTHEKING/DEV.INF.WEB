export const renderMdxComponents = (content = '') => {
  const wrapper = document.createElement('div');
  wrapper.className = 'mdx-components';
  wrapper.innerHTML = content;
  return wrapper;
};

export default renderMdxComponents;
