const admin = require('firebase-admin');
const serviceAccount = require('../config/firebase-admin.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://mathtex-htn.firebaseio.com",
  storageBucket: 'mathtex-htn.appspot.com',
});

const db = admin.firestore();
const storage = admin.storage();

module.exports = {
  db,
  storage,
};
