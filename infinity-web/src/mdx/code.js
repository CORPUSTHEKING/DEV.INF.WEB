export const renderCodeBlock = (code = '', language = '') => {
  const pre = document.createElement('pre');
  pre.className = `CodeBlock language-${language}`.trim();
  pre.textContent = code;
  return pre;
};

export default renderCodeBlock;
