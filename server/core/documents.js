const users = require('../models/users');
const documents = require('../models/documents');

function getDoc(docId) {
  return documents.getDoc(docId);
}

async function createDoc(username) {
  const docId = await documents.createDoc(username);
  await users.addDoc(username, docId);
}

async function deleteDoc(docId) {
  const doc = await getDoc(docId);
  const usernames = await documents.deleteDoc(docId);
  await Promise.all(usernames.map(async username => {
    await users.removeDoc(username, docId);
  }));
}

function addReadUser(docId, username) {
  return documents.addReadUser(docId, username);
}

function removeReadUser(docId, username) {
  return documents.removeReadUser(docId, username);
}

function isReadUser(docId, username) {
  return documents.isReadUser(docId, username);
}

function addWriteUser(docId, username) {
  return documents.addWriteUser(docId, username);
}

function removeWriteUser(docId, username) {
  return documents.removeWriteUser(docId, username);
}

function isWriteUser(docId, username) {
  return documents.isWriteUser(docId, username);
}

module.exports = {
  getDoc,
  createDoc,
  deleteDoc,
  addReadUser,
  removeReadUser,
  isReadUser,
  addWriteUser,
  removeWriteUser,
  isWriteUser,
};
