import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const createWorkerAuth = functions
  .runWith({enforceAppCheck: false}) // هنا يتم تعطيل App Check
  .https.onCall(async (data, context) => {
    try {
      const userRecord = await admin.auth().createUser({
        email: data.email,
        password: data.password,
      });

      return {uid: userRecord.uid};
    } catch (error) {
      const message = error instanceof Error ? error.message : "Unknown error";
      console.log(message);
      throw new functions.https.HttpsError("internal", message);
    }
  });

export const updateWorkerPassword = functions
  .runWith({enforceAppCheck: false}) // إضافة نفس الإعداد
  .https.onCall(async (data, context) => {
    try {
      await admin.auth().updateUser(data.workerId, {
        password: data.newPassword,
      });

      return {success: true};
    } catch (error) {
      const message = error instanceof Error ? error.message : "Unknown error";
      console.log(message);
      throw new functions.https.HttpsError("internal", message);
    }
  });

export const deleteWorkerAuth = functions
  .runWith({enforceAppCheck: false}) // إضافة نفس الإعداد
  .https.onCall(async (data, context) => {
    try {
      await admin.auth().deleteUser(data.workerId);
      return {success: true};
    } catch (error) {
      const message = error instanceof Error ? error.message : "Unknown error";
      throw new functions.https.HttpsError("internal", message);
    }
  });
