export const renderTOCItems = (items) => {
  if (!items || !items.length) return '';
  return `<ul class="TOCNavList">${items.map(item => `
    <li>
      <a href="${item.url}">${item.title}</a>
      ${item.items ? renderTOCItems(item.items) : ''}
    </li>
  `).join('')}</ul>`;
};

export const renderTOCDesktop = (items) => {
  if (!items) return '';
  return `
    <aside class="tocDesktop">
      <nav class="TOCDetails">
        <div class="TOCHeading">Table of contents</div>
        ${renderTOCItems(items)}
      </nav>
    </aside>
  `;
};

export const renderTOCMobile = (items) => {
  if (!items) return '';
  return `
    <div class="tocMobile">
      <details class="TOCDetails" open>
        <summary class="TOCSummary">Table of contents</summary>
        <nav class="TableOfContents">
          ${renderTOCItems(items)}
        </nav>
      </details>
    </div>
  `;
};

export default { renderTOCItems, renderTOCDesktop, renderTOCMobile };
