import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
const firebase = admin.initializeApp();

/////////////////////////////////////////////////////////////////

export const pushFriendMessage = functions.firestore
    .document("conversations/{conversation}/messages/{message}").onCreate(async (snapshot, context) => {
        //****FUNCTION TO PUSH FRIEND MESSAGE NOTIFICATIONS****/
        if (snapshot === undefined || snapshot === null) {
            console.log('No Content');
            return;
        }

        //extract the data from the snapshot
        const data = snapshot.data();

        //check to ensure it isn't empty
        if (data === undefined || data === null) {
            console.log('No Content');
            return;
        }

        //extract the data
        const target = data.targetDevices;
        if (target === undefined || target === null) return;
        let sender = data.senderName;
        if (sender === undefined || sender === null) sender = '';
        let body = data.messageText;
        if (body === undefined || body === null) body = 'New Message';

        //create a payload to deliver via message
        const payload = {
            notification: {
                title: sender,
                body: body,
                sound: 'default'
            },
            data: {
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
                message: 'Plant Collector Message',
                screen: 'FriendsScreen'
            },
        };

        //send the payload to the device
        try {
            await admin.messaging().sendToDevice(target, payload);
            console.log('Message Pushed');

        } catch (err) {
            console.log('Message Error');
        }
        //****FUNCTION END****/
    });

/////////////////////////////////////////////////////////////////

export const pushFriendRequest = functions.firestore
    .document("conversations/{conversation}").onCreate(async (snapshot, context) => {
        //****FUNCTION TO PUSH FRIEND REQUEST NOTIFICATIONS****/
        if (snapshot === undefined || snapshot === null) {
            console.log('No Devices');
            return;
        }

        //extract the data from the snapshot
        const data = snapshot.data();

        //check to ensure it isn't empty
        if (data === undefined || data === null) {
            console.log('No Content');
            return;
        }

        //extract the token data
        //make sure this comes in as an iterable and has info
        const tokens = data.initialRequestPushTokens;
        if (tokens === undefined || tokens === null || tokens === []) return;

        //create a payload to deliver via message
        const payload = {
            notification: {
                title: 'Friend Request',
                body: 'You have received a new Friend Request.',
                sound: 'default'
            },
            data: {
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
                message: 'Plant Collector Message',
                screen: 'FriendsScreen'
            },
        };

        //send the payload to the device
        try {
            await admin.messaging().sendToDevice(tokens, payload);
            console.log('Notification Sent');

        } catch (err) {
            console.log('Notification Error');
        }
        //****FUNCTION END****/
    });

/////////////////////////////////////////////////////////////////

export const pushFriendPlantAdds = functions.pubsub.schedule('every sat 11:45')
    .onRun(async (context) => {

        //****FUNCTION TO PUSH FRIEND UPDATES****/
        //push every sat 11:45

        //initialize list of people to update
        const friendsToNotify: string[] = [];
        const devicesToNotify: string[] = [];
        //check for updates in last x days
        const cutOff = Date.now() - (7 * 86400000);

        //get all the users who have recently updated or added plants
        await admin.firestore().collection('users').where('lastPlantAdd', '>=', cutOff).get()
            .then((result) => {

                //check to see if it's empty
                if (result === undefined || result === null) {
                    console.log('No Recent User Updates');
                    return;
                }
                //extract the data from the result
                result.forEach(doc => {

                    //check that the snapshot, user data, and friend list have data
                    if (doc === undefined || doc === null) return;
                    const data = doc.data();
                    if (data === undefined || data === null) return;
                    const friendList = data.userFriends;
                    if (friendList === undefined || friendList === null || friendList === []) return;

                    //if not already in the notify list, add the friends
                    //note for in loop provides index, for of loop provides value
                    for (const entry of friendList) {
                        if (!friendsToNotify.includes(entry)) {
                            friendsToNotify.push(entry);
                        }
                    }
                });
                console.log(friendsToNotify);
            });

        //for each friend to notify get the device tokens
        for (const user of friendsToNotify) {
            //now get the device tokens for each user
            await admin.firestore().doc('users/' + user).get()
                .then((doc) => {

                    //check that the snapshot, user data, and friend list have data
                    if (doc === undefined || doc === null) return;
                    const data = doc.data();
                    if (data === undefined || data === null) return;
                    const deviceTokens = data.devicePushTokens;
                    if (deviceTokens === undefined || deviceTokens === null || deviceTokens === []) return;

                    //if not already in the notify list, add the friends
                    //note for in provides index, for of provides value
                    for (const entry of deviceTokens) {
                        if (devicesToNotify.includes(entry) === false) {
                            devicesToNotify.push(entry);
                        }
                    }
                });
        }

        console.log(devicesToNotify);

        //now notify the users
        //create a payload to deliver via message
        const payload = {
            notification: {
                title: 'Updates',
                body: 'Your friends have added new plants this week!',
                sound: 'default'
            },
            data: {
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
                message: 'Plant Collector Message',
                screen: 'FriendsScreen'
            },
        };

        //send the payload to the devices
        try {
            await admin.messaging().sendToDevice(devicesToNotify, payload);
            console.log('Friend Update Notifications Sent');

        } catch (err) {
            console.log('Friend Update Notifications Error');
        }

        //****FUNCTION END****/
    });

/////////////////////////////////////////////////////////////////

export const pushMissYou = functions.pubsub.schedule('15 of month 19:00')
    .onRun(async (context) => {

        //****FUNCTION TO PUSH MISS YOU****/
        //push the 15th of every month at 19:00
        const tokenList: string[] = [];

        //check for updates in last x days
        const cutOff = Date.now() - (14 * 86400000);

        //get all the users who have not recently logged in
        await admin.firestore().collection('users').where('lastActive', '<=', cutOff).get()
            .then((result) => {

                //check to see if it's empty
                if (result === undefined || result === null) {
                    console.log('Results Undefined or Null');
                    return;
                }
                //extract the data
                result.forEach(user => {

                    //check that the snapshot, user data, and friend list have data
                    if (user === undefined || user === null) return;
                    const data = user.data();
                    if (data === undefined || data === null) return;
                    const deviceTokens = data.devicePushTokens;
                    if (deviceTokens === undefined || deviceTokens === null || deviceTokens === []) return;

                    //if not already in the notify list, add the friends
                    //note for in loop provides index, for of loop provides value
                    for (const token of deviceTokens) {
                        if (!tokenList.includes(token)) {
                            tokenList.push(token);
                        }
                    }
                    console.log('Token List Complete');
                });
            });

        //now notify the users
        //create a payload to deliver via message
        const payload = {
            notification: {
                title: 'How\'s it Growing?',
                body: 'Don\'t forget to update so your friends can watch your collection grow!  Nothing new?  Get inspired by other people\'s plants in the Discover section.',
                sound: 'default'
            },
            data: {
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
                message: 'Plant Collector Message',
            },
        };

        //send the payload to the devices
        try {
            await admin.messaging().sendToDevice(tokenList, payload);
            console.log('Miss You Notifications Sent');

        } catch (err) {
            console.log('Miss You Notifications Error');
        }

        //****FUNCTION END****/
    });

    /////////////////////////////////////////////////////////////////

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