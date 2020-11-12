const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions

exports.helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  
  functions.pubsub.schedule('* * * * *').onRun((context) => {
    functions.logger.info("RODOU A CADA MINUTO", {structuredData: true});
    response.send("Hello from Firebase!");
    return null;
  })

  response.send("asasdasdsadasd");
});