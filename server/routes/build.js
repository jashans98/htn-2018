const Latex         = require('node-latex');
const Promise       = require('bluebird');
const fs            = require('fs');
const toBlob        = require('stream-to-blob');
const { storage }   = require('../models/index');

const ref           = storage.ref('pdfs');

module.exports = (texStream, fileName) => {
  return new Promise((resolve, reject) => {
    const output = fs.createWriteStream(fileName);
    const pdfConversion = await Latex(texStream);
  
    pdfConversion.pipe(output);
    pdfConversion.on('error', err => {
      console.error(`Something bad happened while pdf converting ${fileName}`);
      Promise.reject(err);
    });

    pdfConversion.on('finish', () => {
      toBlob(fs.createReadStream(fileName), (err, blob) => {
        if (err) {
          console.error(`Something bad happened while writing blob, ${err}`);
          Promise.reject(err);
        }

        const metadata = {
          contentType: 'application/pdf',
        }

        // to Firebase
        ref.put(blob, metadata).then(snapshot => {
          const url = snapshot.ref.getDownloadUrl();
          console.log(`Finished upload for ${fileName} at ${url}`);
          Promise.resolve({
            url,
            fileName
          });
        });
      });
    });
  });
}