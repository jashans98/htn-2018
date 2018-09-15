const DocumentsRouter = require('express').Router();
const documents = require('../core/documents');

DocumentsRouter.get('/:docId', async function(req, res) {
  const docId = req.params.docId;
  const doc = await documents.getDoc(docId);
  res.json(doc);
});

// Create document
DocumentsRouter.get('/create/:username', async function(req, res) {
  const username = req.params.username.toLowerCase();
  await documents.createDoc(username);
  res.send(`Document for ${username} has been created.`);
});

// Delete document
DocumentsRouter.get('/delete/:docId', async function(req, res) {
  const docId = req.params.docId;
  await documents.deleteDoc(docId);
  res.send(`Document ${docId} has been deleted.`);
});

module.exports = DocumentsRouter;
