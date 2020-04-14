import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
const firebase = admin.initializeApp();

export const deletePlantPhotos = functions.firestore
    .document("plants/{plantId}")
    .onDelete((snap) => {
        if (snap) {
            const data = snap.data();
            if (data) {
                const userId = data.plantOwner;
                const plantId = data.plantID;
                const bucket = firebase.storage().bucket();

                return bucket.deleteFiles({
                    prefix: `users/${userId}/plants/${plantId}`
                });
            } else {
                console.log('No data in snapshot');
                return;
            }
        } else {
            console.log('No snapshot information');
            return;
        }
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