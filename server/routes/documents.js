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

// Add read user
DocumentsRouter.get('/read/add/:docId/:username', async function(req, res) {
  const { docId, username } = req.params;
  await documents.addReadUser(docId, username);
  res.send(`${username} has been given read access to doc ${docId}`);
});

// Remove read user
DocumentsRouter.get('/read/remove/:docId/:username', async function(req, res) {
  const { docId, username } = req.params;
  await documents.removeReadUser(docId, username);
  res.send(`${username}'s read access to doc ${docId} has been revoked`);
});

// Checks if user has read access
DocumentsRouter.get('/read/:docId/:username', async function(req, res) {
  const { docId, username } = req.params;
  const isReadUser = await documents.isReadUser(docId, username);
  res.send(isReadUser);
});

// Add write user
DocumentsRouter.get('/write/add/:docId/:username', async function(req, res) {
  const { docId, username } = req.params;
  await documents.addWriteUser(docId, username);
  res.send(`${username} has been given write access to doc ${docId}`);
});

// Remove write user
DocumentsRouter.get('/write/remove/:docId/:username', async function(req, res) {
  const { docId, username } = req.params;
  await documents.removeWriteUser(docId, username);
  res.send(`${username}'s write access to doc ${docId} has been revoked`);
});

// Checks if user has write access
DocumentsRouter.get('/write/:docId/:username', async function(req, res) {
  const { docId, username } = req.params;
  const isWriteUser = await documents.isWriteUser(docId, username);
  res.send(isWriteUser);
});

// Adds text block
DocumentsRouter.post('/blocks/add/text/:docId', async function(req, res) {
  const { docId } = req.params;
  const text = req.body.text;
  await documents.addTextBlock(docId, text);
  res.send('Success!');
});

// Adds math block
DocumentsRouter.post('/blocks/add/math/:docId', async function(req, res) {
  const { docId } = req.params;
  const { strokes, width, height } = req.body;
  const pipe = await documents.addMathBlock(docId, strokes, width, height);
  res.writeHead(200, { 'Content-Type': 'image/png' });
  pipe.pipe(res);
});

// Edits text block
DocumentsRouter.post('/blocks/edit/text/:docId', async function(req, res) {
  const { docId } = req.params;
  const { text, index } = req.body;
  await documents.editTextBlock(docId, text, index);
  res.send('Success!');
});

// Edits math block
DocumentsRouter.post('/blocks/edit/math/:docId', async function(req, res) {
  const { docId } = req.params;
  const { strokes, index, width, height } = req.body;
  const pipe = await documents.editMathBlock(docId, strokes, width, height, index);
  res.writeHead(200, { 'Content-Type': 'image/png' });
  pipe.pipe(res);
});

DocumentsRouter.post('/blocks/add/:docId', async function(req, res) {
  const { docId } = req.params;
  const blocks = req.body;
  await documents.addBlocks(docId, blocks);
  res.send('Success!');
});

// Removes block at index
DocumentsRouter.get('/blocks/remove/:docId/:index', async function(req, res) {
  const { docId, index } = req.params;
  await documents.removeBlock(docId, index);
  res.send('Success!');
});

module.exports = DocumentsRouter;
