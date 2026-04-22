export const createLocationChangeWatcher = (onChange) => {
  if (typeof window === 'undefined') return () => {};
  let previous = window.location.pathname;

  const handler = () => {
    const current = window.location.pathname;
    if (current !== previous) {
      onChange?.({ change: true, previous, current });
      previous = current;
    }
  };

  window.addEventListener('popstate', handler);
  window.addEventListener('hashchange', handler);

  return () => {
    window.removeEventListener('popstate', handler);
    window.removeEventListener('hashchange', handler);
  };
};

export default createLocationChangeWatcher;
