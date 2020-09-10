import * as functions from "firebase-functions";
import data from "./assets/app_data.json";

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
export const main = functions.https.onRequest((request, response) => {
  if (request.query.version) response.send({ version: 6 });
  else response.send(data);
});
