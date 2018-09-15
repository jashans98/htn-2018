const createTextBlock = (text) => ({
  type: 'text',
  text,
});

const createImageBlock = (url) => ({
  type: 'image',
  url,
});

const createMathBlock = (url) => ({
  type: 'math',
  url,
});

module.exports = {
  createTextBlock,
  createImageBlock,
  createMathBlock,
};
