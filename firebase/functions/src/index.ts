import * as functions from "firebase-functions";
import SeededRandomUtilities from "seeded-random-utilities";
import data from "./assets/app_data.json";
import fetch from "node-fetch-commonjs";

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
export const main = functions.https.onRequest((request, response) => {
  if (request.query.version) {
    response.send({ version: 9 });
  } else if (request.query.translate) {
    const word = request.query.word;
    const lang = request.query.lang;

    if (!data.some(ent => ent.word == word)) {
      response.sendStatus(404);
      return;
    }

    fetch(
      `https://translation.googleapis.com/language/translate/v2?key=${process.env.TRANSLATE_API_KEY}`,
      {
        method: "POST",
        body: JSON.stringify({
          'q': word,
          'source': 'de',
          'target': lang
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      }).then(resp => {
        return resp.json();
      }).then((resp: any) => {
        response.send(resp['data']['translations'][0]['translatedText']);
      }).catch(_ => response.sendStatus(500));
  } else if (request.query.challenge) {
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
