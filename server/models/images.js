const { storage } = require('./index');
const stream = require('stream');

const bucket = storage.bucket('images');
bucket.create().then(data => console.log(data)).catch(e => console.log(e))

async function addImage(base64Str, contentType) {
  const bufferStream = new stream.PassThrough();
  bufferStream.end(Buffer.from(base64Str, 'base64'));

  let imageId = '';
  let file = null;
  let exists = true;
  while (exists) {
    imageId = createImageId();
    file = bucket.file(imageId);
    const data = await file.exists();
    exists = data[0];
  }

  const publicUrl = `https://storage.googleapis.com/${bucket.name}/${file.name}?alt=media`;

  return new Promise((resolve, reject) => {
    bufferStream
      .pipe(file.createWriteStream({
        public: true,
        metadata: {
          contentType,
          cacheControl: 'public, max-age=3600'
        },
      }))
      .on('error', err => resolve({ err }))
      .on('finish', () => resolve({ publicUrl }));
  });
}

function createImageId() {
  return String(Math.floor(Math.random()*10000) + 1);
}

module.exports = {
  addImage,
};
