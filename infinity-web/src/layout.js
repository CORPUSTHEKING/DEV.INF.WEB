export class Layout {
  render() {
    const wrapper = document.createElement('div');
    wrapper.className = 'layout-root';
    wrapper.innerHTML = `
      <header id="site-header"></header>
      <div class="main-container">
        <aside id="site-sidebar"></aside>
        <main id="page-content"></main>
      </div>
      <footer id="site-footer"></footer>
    `;
    return wrapper;
  }
}

export const renderLayout = () => new Layout().render();
