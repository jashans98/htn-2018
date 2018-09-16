const url = "https://cloud.myscript.com/api/v4.0/iink/batch";
const request = require('request');
const fs = require('fs');

const options = {
  url,
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json, application/x-latex, text/plain, application/vnd.myscript.jiix',
    'applicationKey': 'd44cfc60-68b8-49ae-8a46-fb0a234b431b',
    'hmac': 'bcb5cd96-9904-4bb5-bc97-e11c1477f243',
  },
};

function translate({
  width,
  height,
  strokes,
}) {
  const json = {
    xDPI: 90,
    yDPI: 90,
    width,
    height,
    contentType: 'Math',
    strokeGroups: [{
      strokes
    }]
  };
  const ops = Object.assign({}, options);
  ops.json = json;
  return new Promise(resolve => {
    request(ops, (err, resp, body) => resolve(body));
  });
}

function translateToPNG({ width, height, strokes }) {
  const json = {
    xDPI: 90,
    yDPI: 90,
    width,
    height,
    contentType: 'Math',
    conversionState: 'DIGITAL_EDIT',
    strokeGroups: [{
      strokes
    }]
  };
  const ops = Object.assign({}, options);
  ops.json = json;
  ops.headers.Accept = 'application/json, image/png';
  return new Promise(resolve => resolve(request(ops)));
}

module.exports = {
  translate,
  translateToPNG,
};
