import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:one_context/one_context.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  //print message title body and data
}

class MessagingAPI {
  //creating an instance of firebase messaging
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _androidChannel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.defaultImportance,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();
  //method to initialise notifications

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    // navigate to new screen when message is received and user taps notification
    OneContext().navigator.key.currentState?.pushNamed(
          '/',
        );
  }

  Future initPushNotifications() async {
    // handle notification if the app was terminated and now opened
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    //handle app opening
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    // attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print message title body and data
      final notification = message.notification;
      if (notification == null) return;
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_launcher.png',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future subscribeToTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic("Offers");
  }

  Future unSubscribeToTopic() async {
    await FirebaseMessaging.instance.unsubscribeFromTopic("Offers");
  }

  Future initLocalNotifications() async {
    // const iOS = IOSInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher.png');
    // const settings = InitializationSettings(iOS: iOS, android: android);
    final settings = InitializationSettings(android: android);
    await _localNotifications.initialize(
      settings,
      // onSelectNotification: (payload) async {
      //   if (payload != null) {
      //     final message = RemoteMessage.fromMap(jsonDecode(payload));
      //     handleMessage(message);
      //   }
      // },
    );
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> initNotifications() async {
    //ask for permission
    _firebaseMessaging.requestPermission(provisional: true);
    //get FCM token for device
    final FCMToken = await _firebaseMessaging.getToken();

    initPushNotifications();
    initLocalNotifications();
  }
}
