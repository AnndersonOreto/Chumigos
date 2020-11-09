const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//

exports.helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

export const userLifeUpdate = functions.database
// aqui vai o caminho da vida exemplo: users/{userId}/life/{lifeId}
.ref('')
.onUpdate((change, context) => {

    //Valor antigo
    const beforeValue = change.before.val()
    //Valor novo
    const afterValue = change.after.val()
    //Valor que foi editado
    const timeEdited = Date.now()
    //Valor para alterar
    const lifeValue = 0

    //Para nao atualizar pra sempre, verifica se os valores estão iguais
    if (beforeValue === afterValue) {
        return null
    }

    //Quando tu chama isso, tu da um update no valor, consequentemente tu chama o onUpdate de novo.
    //Para isso nao acontecer existe o if da linha 27
    return change.after.ref.update({lifeValue, timeEdited})
})