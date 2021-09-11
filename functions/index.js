const functions = require("firebase-functions");
const admin = require("firebase-admin");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

admin.initializeApp();

// exports.myFunction = functions.firestore
//     .document("fridge_items/{item}")
//     .onCreate((snap, context) => {
//       return admin.messaging().sendToTopic("fridge_items", {
//         notification: {
//           title: "Fridge",
//           body: snap.data().product_name + " " +
//             snap.data().product_quantity + " " +
//             snap.data().quantity_type + " bought",
//           clickAction: "FLUTTER_NOTIFICATION_CLICK",
//         },
//       });
//     });
// exports.myFunction2 = functions.firestore
//     .document("shopping_list/{item}")
//     .onCreate((snap, context) => {
//       return admin.messaging().sendToTopic("shopping_list", {
//         notification: {
//           title: "Shopping List",
//           body: snap.data().product_name + " added to shopping list",
//           clickAction: "FLUTTER_NOTIFICATION_CLICK",
//         },
//       });
//     });

exports.myFunction3 = functions.firestore
    .document("fridge_items/{item}")
    .onCreate((snap, context) => {
      return admin.messaging().sendToTopic("fridge_items", {
        data: {
          title: "Fridge",
          body: snap.data().product_quantity + " " +
            snap.data().quantity_type + " of " +
            snap.data().product_name + " bought",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      });
    });
exports.myFunction4 = functions.firestore
    .document("shopping_list/{item}")
    .onCreate((snap, context) => {
      return admin.messaging().sendToTopic("shopping_list", {
        data: {
          title: "Shopping List",
          body: snap.data().product_name + " added to shopping list",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      });
    });

exports.myFunction5 = functions.firestore
    .document("users/{item}")
    .onUpdate((snap, context) => {
      return admin.messaging().sendToTopic("users", {
        data: {
          title: "Added to Fridge",
          body: snap.data().username + " added you to their fridge",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      });
    });
