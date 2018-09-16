const Latex         = require('node-latex');
const Promise       = require('bluebird');
const fs            = require('fs');
const { storage }   = require('../models/index');

const bucket        = storage.bucket();

const build = async (blocks, fileName) => {
  const renders = (await Promise.map(blocks, block => block.render())).join('\n');

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
    ${renders}
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
      reject(err);
    });

    pdfConversion.on('finish', err => {
      if (err) {
        console.error(`Something bad happened while writing blob, ${err}`);
        reject(err);
      }

      const metadata = {
        contentType: 'application/pdf',
      }

      bucket.upload(fileName, { public: true })
        .then(response => {
          console.log(`Finished upload for ${fileName}`);
          const { mediaLink } = response[1];
          resolve({
            url: mediaLink,
            fileName
          });
        })
        .catch(err => {
          console.error(`Could not upload ${fileName}`, err);
          reject(err)
        });
      });
    }
  );
}

module.exports = build;
