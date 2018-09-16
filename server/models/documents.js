const { db } = require('./index');

const collection = db.collection('documents');

/****************************
 *													*
 *			S E T T E R S 			*
 *													*
 ****************************/

async function createDoc(username) {
  let docId = 0;
  let exists = true;
  while (exists) {
    docId = createDocId();
    exists = await docIdExists(docId);
  }
  const doc = {
    read: {},
    write: {},
    blocks: [],
  };

  doc.read[username] = true;
  doc.write[username] = true;
  await collection.doc(docId).set(doc);
  return docId;
}

// Deletes doc and returns the list of users that are associated with the doc
async function deleteDoc(docId) {
  const docRef = collection.doc(docId);
  let users = [];
  try {
    await db.runTransaction(async t => {
      const doc = await t.get(docRef);
      if (!doc.exists) return;
      const data = doc.data();
      users = Object.keys(Object.assign(data.read, data.write));
    });
    await collection.doc(docId).delete();
  } catch(err) {
    console.log(err);
  }
  return users;
}

async function addReadUser(docId, username) {
  const docRef = collection.doc(docId);
  const updateObj = {};
  updateObj[`read.${username}`] = true;
  await docRef.update(updateObj);
}

async function removeReadUser(docId, username) {
  const docRef = collection.doc(docId);
  db.runTransaction(t => t.get(docRef).then(doc => {
    if (!doc.exists) return;
    const read = doc.data().read;
    delete read[username];
    t.update(docRef, { read });
  }));
}

async function addWriteUser(docId, username) {
  const docRef = collection.doc(docId);
  const updateObj = {};
  updateObj[`write.${username}`] = true;
  await docRef.update(updateObj);
}

async function removeWriteUser(docId, username) {
  const docRef = collection.doc(docId);
  db.runTransaction(t => t.get(docRef).then(doc => {
    if (!doc.exists) return;
    const write = doc.data().write;
    delete write[username];
    t.update(docRef, { write });
  }));
}

async function addBlock(docId, block) {
  const docRef = collection.doc(docId);
  db.runTransaction(async t => {
    const doc = await t.get(docRef);
    if (!doc.exists) return;
    const blocks = doc.get('blocks') || [];
    blocks.push(block);
    await t.update(docRef, { blocks });
  });
}

async function addBlocks(docId, newBlocks) {
  const docRef = collection.doc(docId);
  db.runTransaction(async t => {
    const doc = await t.get(docRef);
    if (!doc.exists) return;
    let blocks = doc.get('blocks') || [];
    blocks = blocks.concat(newBlocks);
    await t.update(docRef, { blocks });
  });
}

async function removeBlock(docId, index) {
  const docRef = collection.doc(docId);
  db.runTransaction(async t => {
    const doc = await t.get(docRef);
    if (!doc.exists) return;
    const blocks = doc.get('blocks') || [];
    if (index >= blocks.length) return;
    blocks.splice(index, 1);
    await t.update(docRef, { blocks });
  });
}

async function editBlock(docId, block, index) {
  const docRef = collection.doc(docId);
  db.runTransaction(async t => {
    const doc = await t.get(docRef);
    if (!doc.exists) return;
    const blocks = doc.get('blocks') || [];
    if (index >= blocks.length) return;
    blocks[index] = block;
    await t.update(docRef, { blocks });
  });
}

/****************************
 *													*
 *			G E T T E R S 			*
 *													*
 ****************************/

async function getDoc(docId) {
  const docRef = collection.doc(docId);
  try {
    const doc = await docRef.get();
    if (!doc.exists) return {};
    return doc.data();
  } catch (err) {
    console.log(err);
    return {};
  }
}

async function isReadUser(docId, username) {
  const docRef = collection.doc(docId);
  try {
    const doc = await docRef.get();
    if (!doc.exists) return false;
    return doc.data().read.hasOwnProperty(username);
  } catch (err) {
    console.log(err);
    return false;
  }
}

async function isWriteUser(docId, username) {
  const docRef = collection.doc(docId);
  try {
    const doc = await docRef.get();
    if (!doc.exists) return false;
    return doc.data().write.hasOwnProperty(username);
  } catch (err) {
    console.log(err);
    return false;
  }
}

/****************************
 *													*
 *		      M I S C			    *
 *													*
 ****************************/

function createDocId() {
  return String(Math.floor(Math.random()*10000) + 1);
}

// Returns true if doc id exists
async function docIdExists(docId) {
  const docRef = collection.doc(docId);
  try {
    const doc = await docRef.get();
    return doc.exists;
  } catch (err) {
    console.log(err);
    return false;
  }
}

module.exports = {
  createDoc,
  deleteDoc,
  addReadUser,
  removeReadUser,
  addWriteUser,
  removeWriteUser,
  addBlock,
  addBlocks,
  removeBlock,
  editBlock,
  getDoc,
  isReadUser,
  isWriteUser,
};
