const months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
const format = (d) => `${months[d.getMonth()]} ${d.getDate()}, ${d.getFullYear()}`;
const pluralize = (word, count) => `${count} ${word}${count === 1 ? '' : 's'}`;

export const renderPageFooter = (contributors = []) => {
  let contributorsHtml = '';

  if (contributors.length) {
    const avatars = contributors
      .map(
        (login) => `
          <a href="https://github.com/${login}" class="FooterLink" title="${login}">
            <img src="https://github.com/${login}.png?size=40" alt="${login}" class="Avatar" />
          </a>
        `
      )
      .join('');
    contributorsHtml = `<div class="FooterContributors">${avatars}</div>`;
  }

  return `
    <div class="PageFooter">
      <p class="FooterMeta">Updated ${format(new Date())}</p>
      <p class="FooterMeta">${pluralize('contributor', contributors.length)}</p>
      ${contributorsHtml}
    </div>
  `;
};

export default renderPageFooter;
