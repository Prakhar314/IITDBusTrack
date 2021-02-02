import * as admin from 'firebase-admin';

admin.initializeApp({
    credential: admin.credential.applicationDefault(),
    databaseURL: 'https://iitdbustrack-default-rtdb.firebaseio.com/'
  });

export default admin;