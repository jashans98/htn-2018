const UsersRouter = require('express').Router();
const users = require('../models/users');

// Create user
UsersRouter.post('/create', async function(req, res) {
  const username = req.body.username;
  const password = req.body.password;
  await users.createUser(username, password);
  res.send(`User ${username} has been created.`);
});

// Verifies user
UsersRouter.post('/verify', async function(req, res) {
  const username = req.body.username;
  const password = req.body.password;
  const isValid = await users.verifyUser(username, password);
  res.send(isValid);
});

// Get user's doc ids
UsersRouter.get('/docs/:username', async function(req, res) {
  const username = req.params.username.toLowerCase();

  const docIds = await users.getDocIds(username);
  res.json(docIds);
});

// Add doc
UsersRouter.get('/docs/add/:username/:docId', async function(req, res) {
  const username = req.params.username.toLowerCase();
  const docId = req.params.docId;

  await users.addDoc(username, docId);
  res.send(`Successfully added doc ${docId} to user ${username}`);
});

// Remove doc
UsersRouter.get('/docs/remove/:username/:docId', async function(req, res) {
  const username = req.params.username.toLowerCase();
  const docId = req.params.docId;

  await users.removeDoc(username, docId);
  res.send(`Successfully removed doc ${docId} from user ${username}`);
});

UsersRouter.get('/docs/:username', async function(req, res) {
  const username = req.params.username.toLowerCase();
  const docIds = await users.getDocIds(username);
  res.json(docIds);
});

module.exports = UsersRouter;
