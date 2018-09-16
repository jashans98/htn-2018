const Latex         = require('node-latex');
const Promise       = require('bluebird');
const fs            = require('fs');
const { storage }   = require('../models/index');

const bucket        = storage.bucket();

const build = (blocks, fileName) => {
  const templateString = `
    \\documentclass{article}
    \\usepackage[margin=1in]{geometry}
    \\usepackage{fancyhdr}
    \\usepackage{amsfonts}
    \\usepackage{amsmath}
    \\usepackage{graphicx}
    \\pagestyle{fancy}
    \\fancyhf{}
    \\setlength{\\parskip}{\\baselineskip}
    \\setlength{\\parindent}{0pt}
    \\lhead{Demo purposes only.}
    \\rhead{Hack the North 2018}
    \\begin{document}
    ${blocks.map(async b => await b.render())}
    \\end{document}
  `
  return toPdf(templateString, fileName);
}

const toPdf = (doc, fileName) => {
  return new Promise((resolve, reject) => {
    const output = fs.createWriteStream(fileName);
    const pdfConversion = Latex(doc);

    pdfConversion.pipe(output);
    pdfConversion.on('error', err => {
      console.error(`Something bad happened while pdf converting ${fileName}`);
      Promise.reject(err);
    });

    pdfConversion.on('finish', err => {
      if (err) {
        console.error(`Something bad happened while writing blob, ${err}`);
        Promise.reject(err);
      }

      const metadata = {
        contentType: 'application/pdf',
      }

      const url = `https://www.googleapis.com/storage/v1/b/mathtex-htn.appspot.com/o/${fileName}?alt=media`;

      bucket.upload(fileName)
        .then(() => {
          console.log(`Finished upload for ${fileName}`);
          console.log(url);
          Promise.resolve({
            url,
            fileName
          });
        })
        .catch(err => {
          console.error(`Could not upload ${fileName}`, err);
          Promise.reject(err)
        });
      });
    }
  );
}

module.exports = build;
