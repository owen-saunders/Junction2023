/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const messaging = admin.messaging();

exports.notifySubscribers = functions.https.onCall(async (data, _) => {

    try {
        const multiCastMessage = {
            notification: {
                title: data.messageTitle,
                body: data.messageBody
            },
            tokens: data.targetDevices
        }

        await messaging.sendMulticast(multiCastMessage);

        return true;

    } catch (ex) {
        return ex;
    }
});