export const renderNavHierarchy = (items = []) => {
  if (!items.length) return '';
  return `
    <ul class="NavHierarchy">
      ${items
        .map(
          (item) => `
            <li>
              <a href="${item.url}">${item.title}</a>
              ${item.children?.length ? renderNavHierarchy(item.children) : ''}
            </li>
          `
        )
        .join('')}
    </ul>
  `;
};

export default renderNavHierarchy;
