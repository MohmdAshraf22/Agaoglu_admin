// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:http/http.dart' as http;
// import 'package:tasks_admin/modules/main/data/models/app_notification.dart';
// import 'package:tasks_admin/modules/main/data/services/local_norification_services.dart';
//
// class NotificationService {
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   static LocalNotificationService _localNotificationService =
//       LocalNotificationService();
//   Future<void> initialize() async {
//     await _fcm.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     String? token = await _fcm.getToken();
//     if (token != null) {
//       await _saveTokenToFirestore(token);
//     }
//
//     _fcm.onTokenRefresh.listen(_saveTokenToFirestore);
//
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
//   }
//
//   Future<void> _saveTokenToFirestore(String token) async {
//     String userId = _auth.currentUser!.uid;
//     await _firestore.collection('tokens').doc(userId).set({
//       'fcmToken': token,
//       'lastTokenUpdate': FieldValue.serverTimestamp(),
//     });
//   }
//
//   static Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     _localNotificationService
//         .showNotification(AppNotification.fromJson(message.data));
//   }
//
//   Future<void> _handleForegroundMessage(RemoteMessage message) async {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//
//     if (notification != null && android != null) {
//       AppNotification appNotification = AppNotification(
//         title: notification.title ?? '',
//         body: notification.body ?? '',
//         taskId: message.data['taskId'] ?? '',
//       );
//
//       await _saveNotificationToFirestore(appNotification);
//     }
//   }
//
//   Future<void> _saveNotificationToFirestore(
//       AppNotification notification) async {
//     String userId = _auth.currentUser!.uid;
//     await _firestore
//         .collection('users')
//         .doc(userId)
//         .collection('notifications')
//         .add({
//       ...notification.toJson(),
//       'timestamp': FieldValue.serverTimestamp(),
//       'read': false,
//     });
//   }
//
//   Future<void> sendNotificationToUser({
//     required String userId,
//     required AppNotification notification,
//   }) async {
//     DocumentSnapshot userDoc =
//         await _firestore.collection('tokens').doc(userId).get();
//     String? userToken = userDoc.get('fcmToken');
//
//     if (userToken != null) {
//       await _sendFcmMessage(
//         token: userToken,
//         notification: notification,
//       );
//     }
//   }
//
//   Future<void> _sendFcmMessage({
//     required String token,
//     required AppNotification notification,
//   }) async {
//     try {
//       final String serverKey = '';
//       final Uri fcmUrl = Uri.parse('https://fcm.googleapis.com/fcm/send');
//
//       final response = await http.post(
//         fcmUrl,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'key=$serverKey',
//         },
//         body: jsonEncode({
//           'to': token,
//           'notification': {
//             'title': notification.title,
//             'body': notification.body,
//           },
//           'data': notification.toJson(), // لإرسال بيانات إضافية مع الإشعار
//         }),
//       );
//
//       if (response.statusCode != 200) {
//         print('خطأ في إرسال الإشعار: ${response.body}');
//       }
//     } catch (e) {
//       print('استثناء أثناء إرسال الإشعار: $e');
//       throw e;
//     }
//   }
//
//   Stream<QuerySnapshot> getUserNotifications() {
//     String userId = _auth.currentUser!.uid;
//     return _firestore
//         .collection('users')
//         .doc(userId)
//         .collection('notifications')
//         .orderBy('timestamp', descending: true)
//         .snapshots();
//   }
//
//   Future<void> markNotificationAsRead(String notificationId) async {
//     String userId = _auth.currentUser!.uid;
//     await _firestore
//         .collection('users')
//         .doc(userId)
//         .collection('notifications')
//         .doc(notificationId)
//         .delete();
//   }
// }
