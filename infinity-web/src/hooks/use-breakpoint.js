export const useMediaQuery = (query) => {
  if (typeof window === 'undefined') return false;
  return window.matchMedia(query).matches;
};

export const useBreakpoint = (breakpoint, minMax = 'min') => {
  const px = typeof breakpoint === 'string' ? parseInt(breakpoint, 10) : breakpoint;
  const adjusted = minMax === 'min' ? px : px - 1;
  return useMediaQuery(`(${minMax}-width: ${adjusted}px)`);
};

export const useIsMobile = () => useBreakpoint(768, 'max');

export default useBreakpoint;
