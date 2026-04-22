export const renderTextInput = (props = {}) => {
  const {
    id = '',
    placeholder = 'Search',
    ariaLabel = 'Search',
    className = 'TextInput',
    type = 'text',
    value = '',
  } = props;

  return `<input type="${type}" id="${id}" placeholder="${placeholder}" aria-label="${ariaLabel}" class="${className}" value="${value}" />`;
};

export default renderTextInput;
