import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

// تهيئة Firebase Admin
admin.initializeApp(enforceAppCheck: false);

// دالة إنشاء مستخدم جديد
export const createWorkerAuth = functions.runWith({
    enforceAppCheck: false,
    }).https.onCall(
  async (data, context) => {
    try {
//       if (!context.auth) {
//         throw new functions.https.HttpsError(
//           "unauthenticated",
//           "You must be logged in"
//         );
//       }

      // إنشاء المستخدم
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
  }
);

// دالة حذف مستخدم
export const deleteWorkerAuth = functions.https.onCall(
  async (data, context) => {
    try {
//       if (!context.auth) {
//         throw new functions.https.HttpsError(
//           "unauthenticated",
//           "You must be logged in"
//         );
//       }

      await admin.auth().deleteUser(data.workerId);
      return {success: true};
    } catch (error) {
      const message = error instanceof Error ? error.message : "Unknown error";
      throw new functions.https.HttpsError("internal", message);
    }
  }
);
