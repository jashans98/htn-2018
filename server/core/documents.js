const users = require('../models/users');
const documents = require('../models/documents');
const blocks = require('./blocks');
const myscript = require('./myscript');

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

// BLOCKS

async function removeBlock(docId, index) {
  await documents.removeBlock(docId, index);
}

async function addBlocks(docId, blockArr) {
  blockArr = blockArr.map(({ type, data }) => {
    if (type === 'math') return blocks.createMathBlock(data);
    else return blocks.createTextBlock(data);
  });
  await documents.addBlocks(docId, blockArr);
}

async function addTextBlock(docId, text) {
  const block = blocks.createTextBlock(text);
  await documents.addBlock(docId, block);
}

async function editTextBlock(docId, text, index) {
  const block = blocks.createTextBlock(text);
  await documents.editBlock(docId, block, index);
}

async function addMathBlock(docId, strokes, width, height) {
  const block = blocks.createMathBlock(strokes);
  await documents.addBlock(docId, block);
  const pipe = await myscript.translateToPNG({ width, height, strokes, image: true });
  return pipe;
}

async function editMathBlock(docId, strokes, width, height, index) {
  const block = blocks.createMathBlock(strokes);
  await documents.editBlock(docId, block, index);
  const img = await myscript.translate({ width, height, strokes, image: true });
  return img;
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
  removeBlock,
  addBlocks,
  addTextBlock,
  editTextBlock,
  addMathBlock,
  editMathBlock,
};
