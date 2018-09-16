const Latex         = require('node-latex');
const Promise       = require('bluebird');
const fs            = require('fs');
const { storage }   = require('../models/index');

const bucket        = storage.bucket();

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
          Promise.resolve({
            url,
            fileName
          });
        })
        .catch(err => {
          console.error(`Could not upload ${fileName}`, err);
          Promise.reject(err)
        });

        // to Firebase
        // ref.put(blob, metadata).then(snapshot => {
        //   const url = snapshot.ref.getDownloadUrl();
        //   console.log(`Finished upload for ${fileName} at ${url}`);
        //   Promise.resolve({
        //     url,
        //     fileName
        //   });
        // });
      });
    });
}

const testDoc = `
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
Hi my name is dog
\\end{document}
`

// const DEFAULT_PACKAGES = [
//   { title: 'geometry', options: { margin: '1in' }},
//   { title: 'fancyhdr' },
//   { title: 'amsfonts' },
//   { title: 'amsmath' },
//   { title: 'listings' },
//   { title: 'graphicx' },
//   { title: 'enumitem' }
// ];

// class Math extends Block {
//   constructor(latex) {
//     this.latex = latex;
//   }

//   convert() {
//     return `$$${this.latex}$$\n`;
//   }
// }

// class Text extends Block {
//   constructor(content) {
//     this.content = content;
//   }

//   convert() {
//     return `${this.content}\n`;
//   }
// }

// class TextDocument {
//   constructor(...blocks) {
//     this.blocks = blocks;
//   }

//   convert() {
//     return `
//     \\documentclass{article}

//     \\usepackage[margin=1in]{geometry}
//     \\usepackage{fancyhdr}
//     \\usepackage{amsfonts}
//     \\usepackage{amsmath}
//     \\usepackage{listings}
//     \\usepackage{graphicx}
//     \\usepackage{enumitem}

//     \\graphicspath{ {./media} }

//     \\pagestyle{fancy}
//     \\fancyhf{}

//     \\setlength{\parskip}{\baselineskip}
//     \\setlength{\parindent}{0pt}

//     \\lhead{Demo purposes only.}
//     \\rhead{Hack the North 2018}

//     \\lstset{language=Python, captionpos=b}

//     \\begin{document}

//     ${this.blocks.forEach(block => block.convert())};

//     \\end{document}
//     \\begin{document}
//     \\documentclass{}
//     \\end{document}
//     `;
//   }
// }

console.log(testDoc);

toPdf(testDoc, 'testName.pdf');

//module.exports = toPdf;