import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
const firebase = admin.initializeApp();

export const deletePlantPhotos = functions.firestore
  .document("plants/{plantId}")
  .onDelete((snap, context) => {
    const { userId } = context.params;
    const { plantId } = context.params;
    const bucket = firebase.storage().bucket();

    return bucket.deleteFiles({
      prefix: `users/${userId}/plants/${plantId}`
    });
  });

export const getTopCollectors = functions.firestore
.document("users/{userId}")
.onWrite(async () => {
//***ON WRITE TO USER FILE, GET AND CACHE TOP RANKED USERS

  //get the data
  const snapUsers = await admin.firestore().collection("users/")
  .orderBy("userTotalPlants", "desc").limit(50).get();
  //use .docs() to get an array of DocumentSnapshots for QuerySnapshot
  //but just use forEach to skip this first step
  const data: any[] = [];
  snapUsers.forEach(userSnap => {
      const object = userSnap.data();
      data.push(object);
  });

  //if no, nothing can be done
  if (data === []) return null;

  //remove the old value and user reference
  return admin.firestore().doc("app/user_stats_top").update({
        byPlants : data
        });
//FUNCTION END
});

export const updateUserFriendList = functions.firestore
.document("users/{userID}/userConnections/{friend}")
.onCreate((snap, context) => {
//*** AUTOMATICALLY ADD THE NEW CONNECTION ID TO USER DOCUMENT
    //get the data Object
    const data = snap.data();
    const {userID} = context.params;

    //make sure it exists and that there has been a change
    if (data === undefined || data === null) return null;

    //get the friend ID
    const friend: string = data.userID;

    //check to make sure a userID is actually present
    if (friend === undefined || friend === null) return null;

    //upload the package
    //user set to overwrite so empty fields are cleared
    return admin.firestore().doc('users/'  + userID).update({
        userFriends: admin.firestore.FieldValue.arrayUnion(friend)
    });
//FUNCTION END
});

export const removeUserFriendList = functions.firestore
.document("users/{userID}/userConnections/{friend}")
.onDelete((snap, context) => {
//*** AUTOMATICALLY REMOVE CONNECTION ID FROM USER DOCUMENT
    //get the data Object
    const data = snap.data();
    const {userID} = context.params;

    //make sure it exists and that there has been a change
    if (data === undefined || data === null) return null;

    //get the friend ID
    const friend: string = data.userID;

    //check to make sure a userID is actually present
    if (friend === undefined || friend === null) return null;

    //upload the package
    //user set to overwrite so empty fields are cleared
    return admin.firestore().doc('users/'  + userID).update({
        userFriends: admin.firestore.FieldValue.arrayRemove(friend)
    });
//FUNCTION END
});