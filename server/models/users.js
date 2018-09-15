const db = require('./index');

const collection = db.collection('users');

/****************************
 *													*
 *			S E T T E R S 			*
 *													*
 ****************************/

async function createUser(username, password) {
  await collection.doc(username.toLowerCase()).set({
    password,
    docs: [],
  });
}

function addDoc(username, docId) {
  const userRef = collection.doc(username);
  db.runTransaction(t => t.get(userRef).then(doc => {
    if (!doc.exists) return;
    const docIds = doc.get('docs') || [];
    docIds.push(docId);
    t.set(userRef, { docs: docIds }, { merge: true });
  }));
}

function removeDoc(username, docId) {
  const userRef = collection.doc(username);
  db.runTransaction(t => t.get(userRef).then(doc => {
    if (!doc.exists) return;
    const docIds = doc.get('docs').filter(id => id !== docId);
    t.set(userRef, { docs: docIds }, { merge: true });
  }));
}

/****************************
 *													*
 *			G E T T E R S 			*
 *													*
 ****************************/

async function getDocIds(username) {
  const userRef = collection.doc(username);
  try {
    const doc = await userRef.get('docs');
    if (!doc.exists) return [];
    return doc.data().docs;
  } catch (err) {
    console.log(err);
    return [];
  }
}

module.exports = {
  createUser,
  addDoc,
  removeDoc,
  getDocIds,
};
