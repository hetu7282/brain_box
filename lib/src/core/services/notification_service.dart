// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';

// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:brain_box/src/config/router/router.dart';
// import 'package:brain_box/src/core/utils/enums.dart';
// import 'package:brain_box/src/core/utils/log.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:go_router/go_router.dart';

// /// handle background notification
// @pragma('vm:entry-point')
// Future<void> handleBackground(RemoteMessage message) async {
//   Log.d('📨 Background Notification Received');
//   Log.d('Title:- ${message.notification?.title}');
//   Log.d('Body:- ${message.notification?.body}');
//   Log.d('Data:- ${message.data}');

//   // Check notification type from data payload
//   final notificationType = message.data['type'] ?? 'general';

//   if (notificationType == 'call' ||
//       message.notification?.title == 'Incoming Call') {
//     // Show call notification with action buttons
//     await _showCallNotificationInBackground(message);
//   } else {
//     // Show regular notification
//     await _showRegularNotificationInBackground(message);
//   }
// }

// /// Show call notification in background
// Future<void> _showCallNotificationInBackground(RemoteMessage message) async {
//   // Convert Map<String, dynamic> to Map<String, String?>
//   final Map<String, String?> payload = message.data.map(
//     (key, value) => MapEntry(key, value?.toString()),
//   );

//   await AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: 123,
//       channelKey: "call_channel",
//       color: Colors.white,
//       title: message.notification?.title ?? 'Incoming Call',
//       body: message.notification?.body ?? 'You have an incoming call',
//       category: NotificationCategory.Call,
//       displayOnBackground: true,
//       displayOnForeground: true,
//       wakeUpScreen: true,
//       fullScreenIntent: true,
//       autoDismissible: false,
//       backgroundColor: Colors.orange,
//       payload: payload,
//     ),
//     actionButtons: [
//       NotificationActionButton(
//         key: "ACCEPT",
//         label: "Accept Call",
//         color: Colors.green,
//         autoDismissible: true,
//       ),
//       NotificationActionButton(
//         key: "REJECT",
//         label: "Reject Call",
//         color: Colors.red,
//         autoDismissible: true,
//       ),
//     ],
//   );
// }

// /// Show regular notification in background
// Future<void> _showRegularNotificationInBackground(RemoteMessage message) async {
//   // This will be handled by Flutter Local Notifications
//   // when the app comes to foreground
// }

// /// handle local notification on tap event in foreground and background
// void onDidReceiveNotificationResponse(
//   NotificationResponse notificationResponse,
// ) async {
//   final payload = notificationResponse.payload;
//   if (payload == null) return;

//   try {
//     final data = jsonDecode(payload);
//     final context = AppRouterNavigationKey.navigatorKey.currentContext;

//     if (context != null) {
//       // Navigate to notification screen for regular notifications
//       context.goNamed(Routes.notification.name);
//     }
//   } catch (e) {
//     Log.e('Error handling notification response: $e');
//   }
// }

// /// [NotificationService] use for handle firebase notification using flutter local notification
// class NotificationService {
//   NotificationService._();

//   static final _instance = NotificationService._();

//   factory NotificationService() {
//     return _instance;
//   }

//   static final firebaseMessaging = FirebaseMessaging.instance;

//   final _flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

//   final _androidChannel = const AndroidNotificationChannel(
//     'channel_id',
//     'Music Booth High Importance Notification',
//     description:
//         'This channel is used for important notifications, such as booking updates.',
//     importance: Importance.high,
//     playSound: true,
//     enableLights: true,
//     enableVibration: true,
//   );
//   final icon = '@drawable/ic_notification';

//   /// Show call notification with action buttons
//   Future<void> showCallingNotification(RemoteMessage message) async {
//     String? title = message.notification?.title ?? 'Incoming Call';
//     String? body = message.notification?.body ?? 'You have an incoming call';

//     // Convert Map<String, dynamic> to Map<String, String?>
//     final Map<String, String?> payload = message.data.map(
//       (key, value) => MapEntry(key, value?.toString()),
//     );

//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: 123,
//         channelKey: "call_channel",
//         color: Colors.white,
//         title: title,
//         body: body,
//         category: NotificationCategory.Call,
//         displayOnBackground: true,
//         displayOnForeground: true,
//         roundedBigPicture: true,
//         wakeUpScreen: true,
//         fullScreenIntent: true,
//         autoDismissible: false,
//         backgroundColor: Colors.orange,
//         payload: payload,
//       ),
//       actionButtons: [
//         NotificationActionButton(
//           key: "ACCEPT",
//           label: "Accept Call",
//           color: Colors.green,
//           autoDismissible: true,
//         ),
//         NotificationActionButton(
//           key: "REJECT",
//           label: "Reject Call",
//           color: Colors.red,
//           autoDismissible: true,
//         ),
//       ],
//     );
//   }

//   /// Setup AwesomeNotifications action stream listener
//   void setupAwesomeNotificationsListener() {
//     AwesomeNotifications().setListeners(
//       onActionReceivedMethod: onActionReceivedMethod,
//       onNotificationCreatedMethod: onNotificationCreatedMethod,
//       onNotificationDisplayedMethod: onNotificationDisplayedMethod,
//       onDismissActionReceivedMethod: onDismissActionReceivedMethod,
//     );
//   }

//   /// Handle notification action button press
//   @pragma('vm:entry-point')
//   static Future<void> onActionReceivedMethod(
//     ReceivedAction receivedAction,
//   ) async {
//     Log.d('🔔 Action received: ${receivedAction.buttonKeyPressed}');

//     final context = AppRouterNavigationKey.navigatorKey.currentContext;
//     if (context == null) {
//       Log.e('Navigator context is null');
//       return;
//     }

//     if (receivedAction.buttonKeyPressed == "REJECT") {
//       Log.d('📞 Call Rejected');
//       // Dismiss the notification
//       await AwesomeNotifications().dismiss(123);
//     } else if (receivedAction.buttonKeyPressed == "ACCEPT") {
//       Log.d('📞 Call Accepted - Navigating to call screen');
//       // Navigate to call screen
//       context.goNamed(Routes.call.name, extra: CallScreenType.other.name);
//     } else {
//       // Notification tapped (not button)
//       Log.d('🔔 Notification tapped');
//       // Check if it's a call notification
//       if (receivedAction.payload?['type'] == 'call' ||
//           receivedAction.title == 'Incoming Call') {
//      context.goNamed(Routes.call.name, extra: CallScreenType.other.name);
//       } else {
//         context.goNamed(Routes.notification.name);
//       }
//     }
//   }

//   @pragma('vm:entry-point')
//   static Future<void> onNotificationCreatedMethod(
//     ReceivedNotification receivedNotification,
//   ) async {
//     Log.d('📨 Notification created: ${receivedNotification.id}');
//   }

//   @pragma('vm:entry-point')
//   static Future<void> onNotificationDisplayedMethod(
//     ReceivedNotification receivedNotification,
//   ) async {
//     Log.d('📨 Notification displayed: ${receivedNotification.id}');
//   }

//   @pragma('vm:entry-point')
//   static Future<void> onDismissActionReceivedMethod(
//     ReceivedAction receivedAction,
//   ) async {
//     Log.d('🔔 Notification dismissed: ${receivedAction.id}');
//   }

//   Future<void> init(BuildContext context) async {
//     // Setup notification listeners (AwesomeNotifications already initialized in main.dart)
//     setupAwesomeNotificationsListener();

//     // Request notification permissions
//     await AwesomeNotifications().requestPermissionToSendNotifications();

//     // Request permission and initialize Firebase
//     await firebaseMessaging.requestPermission();
//     final fcmToken = await firebaseMessaging.getToken();
//     Log.d('FCM TOKEN:- $fcmToken');

//     await initPushNotification(context);
//     await initLocalNotification();

//     Log.d('✅ NotificationService fully initialized');
//   }

//   Future<void> initPushNotification(BuildContext context) async {
//     await firebaseMessaging.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     // Handle notification when app is opened from background/terminated state
//     FirebaseMessaging.onMessageOpenedApp.listen(
//       (event) => onMessageOpenedApp(event, context),
//     );

//     // Register background message handler
//     FirebaseMessaging.onBackgroundMessage(handleBackground);
//     FirebaseMessaging.instance.setAutoInitEnabled(true);

//     // Handle foreground notifications
//     FirebaseMessaging.onMessage.listen((event) {
//       final notification = event.notification;
//       if (notification == null) return;

//       Log.d('📨 Foreground notification received');
//       Log.d('Title: ${notification.title}');
//       Log.d('Body: ${notification.body}');
//       Log.d('Data: ${event.data}');

//       // Check notification type from data payload
//       final notificationType = event.data['type'] ?? 'general';
//       final isCallNotification =
//           notificationType == 'call' || notification.title == 'Incoming Call';

//       if (isCallNotification) {
//         // Show call notification with action buttons
//         Log.d('📞 Showing call notification');
//         showCallingNotification(event);
//       } else {
//         // Show regular notification (Android only, iOS handles automatically)
//         Log.d('🔔 Showing regular notification');
//         if (Platform.isAndroid) {
//           showNotification(
//             title: notification.title!,
//             body: notification.body!,
//             paylod: event.data.isNotEmpty ? event.data : notification.toMap(),
//           );
//         }
//       }
//     });
//   }

//   Future<void> initLocalNotification() async {
//     const iosInitializationSettings = DarwinInitializationSettings();
//     final androidInitializationSettings = AndroidInitializationSettings(icon);

//     final settings = InitializationSettings(
//       android: androidInitializationSettings,
//       iOS: iosInitializationSettings,
//     );

//     await _flutterLocalNotificationPlugin.initialize(
//       settings,
//       onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
//       onDidReceiveBackgroundNotificationResponse:
//           onDidReceiveNotificationResponse,
//     );

//     final androidPlartformImplementation = _flutterLocalNotificationPlugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >();
//     androidPlartformImplementation?.createNotificationChannel(_androidChannel);
//     final iosPlartformImplementation = _flutterLocalNotificationPlugin
//         .resolvePlatformSpecificImplementation<
//           IOSFlutterLocalNotificationsPlugin
//         >();
//     iosPlartformImplementation?.requestPermissions(
//       alert: true,
//       sound: true,
//       badge: true,
//     );
//   }

//   static Future<String> get fcmToken async {
//     return (await firebaseMessaging.getToken())!;
//   }

//   void showNotification({
//     required String title,
//     required String body,
//     required Map<String, dynamic> paylod,
//   }) {
//     final id = Random().nextInt(1000);
//     final notificationDetails = getNotificationDetails();
//     _flutterLocalNotificationPlugin.show(
//       id,
//       title,
//       body,
//       notificationDetails,
//       payload: jsonEncode(paylod),
//     );
//   }

//   NotificationDetails getNotificationDetails() {
//     return NotificationDetails(
//       android: AndroidNotificationDetails(
//         _androidChannel.id,
//         _androidChannel.name,
//         channelDescription: _androidChannel.description,
//         icon: icon,
//         importance: _androidChannel.importance,
//       ),
//       iOS: const DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//       ),
//     );
//   }

//   bool onInitialMessage(RemoteMessage? message) {
//     if (message == null) return false;
//     return true;
//   }

//   void onMessageOpenedApp(RemoteMessage? message, BuildContext context) {
//     if (message == null) return;

//     Log.d('📨 App opened from notification');
//     Log.d('Data: ${message.data}');

//     // Check notification type from data payload
//     final notificationType = message.data['type'] ?? 'general';
//     final isCallNotification =
//         notificationType == 'call' ||
//         message.notification?.title == 'Incoming Call';

//     if (isCallNotification) {
//       // Navigate to call screen
//       Log.d('📞 Navigating to call screen');
//       context.goNamed(Routes.call.name, extra: CallScreenType.other.name);
//     } else {
//       // Navigate to notification screen
//       Log.d('🔔 Navigating to notification screen');
//       context.goNamed(Routes.notification.name);
//     }
//   }

//   Future<bool> requestNotification() async {
//     final notificationSetting = await firebaseMessaging.requestPermission();
//     if (notificationSetting.authorizationStatus ==
//         AuthorizationStatus.authorized) {
//       return true;
//     }
//     return false;
//   }
// }
