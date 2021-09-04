import * as functions from "firebase-functions";
import SeededRandomUtilities from "seeded-random-utilities";
import data from "./assets/app_data.json";

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
export const main = functions.https.onRequest((request, response) => {
  if (request.query.version){
    response.send({ version: 8 });
  } else if(request.query.challenge) {
    const dayCode: number = request.query.daycode;
    const rand = new SeededRandomUtilities(dayCode.toString());

    const challengeWords: string[] = [];

    for (let i = 0; i < 15; i++) {
      challengeWords.push(data[rand.getRandomIntegar(data.length)].word)
    }

    response.send(challengeWords);
  }
  else {
    response.send(data);
  }
});
