const db = require('./index');

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
  await collection.doc(docId).set({
    read: { username: true },
    write: { username: true },
    blocks: [],
  });
  return docId;
}

// Deletes doc and returns the list of users that are associated with the doc
async function deleteDoc(docId) {
  const docRef = collection.doc(docId);
  let users = [];
  try {
    await db.runTransaction(async t => {
      const doc = await t.get(docRef);
      const data = doc.data();
      const readUsers = Object.keys(data.read);
      const writeUsers = Object.keys(data.write);
      users = readUsers.concat(writeUsers);
    });
    await collection.doc(docId).delete();
  } catch(err) {
    console.log(err);
  }
  return users;
}

async function addReadUser(docId, username) {
  const readRef = collection.doc(`${docId}.read`);
  await readRef.update({ username: true });
}

async function removeReadUser(docId, username) {
  await collection.doc(docId).doc(`read.${username}`).delete();
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
  getDoc,
};
