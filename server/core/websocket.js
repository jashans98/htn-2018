const WebSocket = require('ws');

const ws = new WebSocket('wss://cloud.myscript.com/api/v4.0/iink/document');


// Initializes handshake and returns the iink session id to reconnect in case
// of failure
function initHandshake(dpi, width, height) {
  ws.send({
    type: "newContentPackage",
    applicationKey: process.env.API_KEY,
    xDpi: dpi,
    yDpi: dpi,
    viewSizeHeight: height,
    viewSizeWidth: width
  });
}

// Creates a new part
// ContentType is one of "MATH" or "TEXT"
function newPart(contentType) {
  ws.send({
    type: "newContentPart",
    contentType,
  });
}

// Add a new stroke
function addStroke(stroke) {
  ws.send({
    type: "PEN",
    strokes: [stroke],
  });
}

function undo() {
  ws.send({ type: 'undo' });
}

function redo() {
  ws.send({ type: 'redo' });
}

module.exports = {
  initHandshake,
  newPart,
  addStroke,
  undo,
  redo,
}
