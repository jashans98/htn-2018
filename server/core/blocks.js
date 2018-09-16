const recognize = require('../core/myscript');

const createTextBlock = (text) => ({
  type: 'text',
  text,
});

const createImageBlock = (url) => ({
  type: 'image',
  url,
});

const createMathBlock = (strokes, width, height) => ({
  type: 'math',
  strokes,
  width,
  height
});

class Stroke {
  constructor(x, y, type, time) {
    this.x = x;
    this.y = y;
    this.type = type;
    this.time = time;
  }
}

class Block {
  constructor(type) {
    this.type = type;
  }
}

class Text extends Block {
  constructor(content) {
    super('text');
    this.content = content;
  }

  render() {
    return `${this.content}\n`;
  }
}

class Math extends Block {
  constructor(strokes, width, height) {
    super('math');
    this.strokes = strokes;
    this.width = width;
    this.height = height;
  }

  async render() {
    const line = await recognize.translate({
      dpi: 264,
      width: this.width,
      height: this.height,
      strokes: this.strokes
    });
    console.log('rendered shit')
    if (line == null) return '';
    return `$$${line}$$\n`;
  }
}

module.exports = {
  Text,
  Math,
  createTextBlock,
  createImageBlock,
  createMathBlock,
};
