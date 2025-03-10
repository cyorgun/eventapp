const functions = require("firebase-functions");
const firebaseFunctions = require("firebase-functions/v1");
const admin = require("firebase-admin");
const fetch = require("node-fetch");

admin.initializeApp();
const firestore = admin.firestore();

const GOOGLE_PLAY_API_URL = "https://androidpublisher.googleapis.com/androidpublisher/v3/applications";
const APPLE_API_URL = "https://buy.itunes.apple.com/verifyReceipt";

// Dinamik olarak Google Play ve Apple Secret Key'i almak için fonksiyon
async function getConfigValue(key) {
  const doc = await firestore.collection("config").doc("api_keys").get();
  if (!doc.exists) {
    throw new Error(`Config document does not exist for key: ${key}`);
  }
  return doc.data()[key];
}

exports.verifyUserSubscription = functions.https.onCall(async (data, context) => {
  let userId;

  if (data.data.idToken) {
    // Flutter tarafından gönderilen idToken varsa doğrula
    try {
      const decodedToken = await admin.auth().verifyIdToken(data.data.idToken);
      userId = decodedToken.uid;
    } catch (error) {
      console.error("Token doğrulama başarısız:", error);
      throw new functions.https.HttpsError("unauthenticated", "Token doğrulanamadı.");
    }
  } else {
    console.error("Kimlik doğrulama eksik!");
    throw new functions.https.HttpsError("unauthenticated", "Kimlik doğrulaması gerekli.");
  }

  const userRef = firestore.collection("users").doc(userId);
  const userDoc = await userRef.get();

  if (!userDoc.exists || !userDoc.data().subscription) {
    throw new functions.https.HttpsError("not-found", "Abonelik bulunamadı.");
  }

  const subscription = userDoc.data().subscription;
  const token = subscription.purchaseToken;
  const plan = subscription.plan;
  const platform = subscription.platform; // "android" veya "ios"

  let isValid = false;
  let newEndDate = null;

  if (platform === "android") {
    const GOOGLE_PLAY_ACCESS_TOKEN = await getConfigValue("GOOGLE_PLAY_ACCESS_TOKEN");
    const response = await fetch(
      `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/YOUR_PACKAGE_NAME/purchases/subscriptions/${plan}/tokens/${token}`,
      {
        method: "GET",
        headers: { "Authorization": `Bearer ${GOOGLE_PLAY_ACCESS_TOKEN}` }
      }
    );
    const result = await response.json();
    if (result.expiryTimeMillis > Date.now()) {
      isValid = true;
      newEndDate = firestore.Timestamp.fromMillis(result.expiryTimeMillis);
    }
  } else if (platform === "ios") {
    const APPLE_SHARED_SECRET = await getConfigValue("APPLE_SHARED_SECRET");
    const response = await fetch("https://buy.itunes.apple.com/verifyReceipt", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        "receipt-data": token,
        "password": APPLE_SHARED_SECRET
      })
    });
    const result = await response.json();
    if (result.latest_receipt_info) {
      const lastReceipt = result.latest_receipt_info.sort((a, b) => b.expires_date_ms - a.expires_date_ms)[0];
      if (lastReceipt.expires_date_ms > Date.now()) {
        isValid = true;
        newEndDate = firestore.Timestamp.fromMillis(lastReceipt.expires_date_ms);
      }
    }
  }

  if (isValid) {
    let updateData = { "subscription.endDate": newEndDate };
    if (plan === "temel_plan_subscription") {
      updateData["eventCount"] = 3;
    }
    await userRef.update(updateData);
    return { success: true, newEndDate: newEndDate.toDate() };
  } else {
    await userRef.update({ "subscription": admin.firestore.FieldValue.delete(), "eventCount": admin.firestore.FieldValue.delete() });
    return { success: false };
  }
});

exports.verifySubscriptions = firebaseFunctions.pubsub.schedule("every 24 hours").onRun(async (context) => {
  const usersRef = firestore.collection("users");
  const snapshot = await usersRef.get();

  const GOOGLE_PLAY_ACCESS_TOKEN = await getConfigValue("GOOGLE_PLAY_ACCESS_TOKEN");
  const APPLE_SHARED_SECRET = await getConfigValue("APPLE_SHARED_SECRET");

  const batch = firestore.batch();
  for (let doc of snapshot.docs) {
    const data = doc.data();
    if (data.subscription && data.subscription.purchaseToken) {
      const userRef = usersRef.doc(doc.id);
      const token = data.subscription.purchaseToken;
      const plan = data.subscription.plan;
      const platform = data.subscription.platform;

      let isValid = false;
      let newEndDate = null;

      if (platform === "android") {
        const response = await fetch(
          `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/YOUR_PACKAGE_NAME/purchases/subscriptions/${plan}/tokens/${token}`,
          {
            method: "GET",
            headers: { "Authorization": `Bearer ${GOOGLE_PLAY_ACCESS_TOKEN}` }
          }
        );
        const result = await response.json();
        if (result.expiryTimeMillis > Date.now()) {
          isValid = true;
          newEndDate = firestore.Timestamp.fromMillis(result.expiryTimeMillis);
        }
      }

      if (isValid) {
        let updateData = { "subscription.endDate": newEndDate };
        if (plan === "temel_plan_subscription") {
          updateData["eventCount"] = 3;
        }
        batch.update(userRef, updateData);
      } else {
        batch.update(userRef, { "subscription": admin.firestore.FieldValue.delete(), "eventCount": admin.firestore.FieldValue.delete() });
      }
    }
  }
  await batch.commit();
  console.log("Tüm kullanıcı abonelikleri doğrulandı.");
});
