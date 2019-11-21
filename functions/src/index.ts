import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
const firebase = admin.initializeApp();

export const deletePlantPhotos = functions.firestore
  .document("users/{userId}/userPlants/{plantId}")
  .onDelete((snap, context) => {
    const { userId } = context.params;
    const { plantId } = context.params;
    const bucket = firebase.storage().bucket();

    return bucket.deleteFiles({
      prefix: `users/${userId}/plants/${plantId}`
    });
  });