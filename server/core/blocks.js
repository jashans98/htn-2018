const createTextBlock = (text) => ({
  type: 'text',
  text,
});

const createImageBlock = (url) => ({
  type: 'image',
  url,
});

const createMathBlock = (strokes) => ({
  type: 'math',
  strokes,
});

module.exports = {
  createTextBlock,
  createImageBlock,
  createMathBlock,
};
