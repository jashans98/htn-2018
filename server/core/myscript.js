const url = "https://cloud.myscript.com/api/v4.0/iink/batch";
const request = require('request');

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
  dpi,
  width,
  height,
  strokes,
}) {
  const json = {
    xDPI: dpi,
    yDPI: dpi,
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

module.exports = {
  translate,
};
