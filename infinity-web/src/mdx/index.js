import { renderMdxComponents } from './components.js';
import { renderCodeBlock } from './code.js';

export const renderMarkdown = (content) => {
  const container = document.createElement('div');
  container.className = 'mdx-content';
  container.innerHTML = String(content || '')
    .replace(/```(\w+)?\n([\s\S]*?)```/g, (_, lang = '', code = '') => {
      const block = renderCodeBlock(code.trimEnd(), lang);
      return `<pre class="CodeBlock language-${lang}"><code>${block.textContent}</code></pre>`;
    });

  return renderMdxComponents(container.innerHTML);
};

export default renderMarkdown;
