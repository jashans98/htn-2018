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
  // thisdoesnt work yet
  await Promise.all(usernames.map(async username => {
    console.log(username);
    await users.removeDoc(username, docId);
  }));
}

module.exports = {
  getDoc,
  createDoc,
  deleteDoc,
};
