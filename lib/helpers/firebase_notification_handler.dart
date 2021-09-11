import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_handler.dart';

class FirebaseNotifications {
  FirebaseMessaging _messaging;
  BuildContext myContext;

  void setupFirebase(BuildContext context) {
    _messaging = FirebaseMessaging.instance;
    NotificationHandler.initNotification(context);
    firebaseCloudMessageListener(context);
    myContext = context;
  }

  void firebaseCloudMessageListener(BuildContext context) async {
    NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    print('Setting ${settings.authorizationStatus}');
    //Get Token
    //We will use token to receive notification
    // _messaging.getToken().then((token) => print('MyToken: $token'));
    //subscribe to topic
    //we will send the topic for group notification
    _messaging
        .subscribeToTopic('fridge_items')
        .whenComplete(() => print('Fridge Subscribe OK'));
    //we will send the topic for group notification
    _messaging
        .subscribeToTopic('shopping_list')
        .whenComplete(() => print('Shopping List Subscribe OK'));
    _messaging
        .subscribeToTopic('users')
        .whenComplete(() => print('User Subscribe OK'));
    //Handle message
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      print('Receive $remoteMessage');
      if (Platform.isAndroid) {
        print(remoteMessage);
        print(remoteMessage.notification);
        print(remoteMessage.data);
        showNotification(
            remoteMessage.data['title'], remoteMessage.data['body']);
      } else if (Platform.isIOS) {
        showNotification(
            remoteMessage.notification.title, remoteMessage.notification.body);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      print('REceive open app: $remoteMessage');
      if (Platform.isIOS) {
        showDialog(
            context: myContext,
            builder: (context) => CupertinoAlertDialog(
                  title: Text(remoteMessage.notification.title),
                  content: Text(remoteMessage.notification.body),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Text('OK'),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                    )
                  ],
                ));
      } else if (Platform.isAndroid) {
        final flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        flutterLocalNotificationsPlugin.cancel(0);
      }
    });
  }

  static void showNotification(title, body) async {
    print('title $title body $body');
    var androidChannel = AndroidNotificationDetails(
        'com.example.fridge_app', 'My Channel', 'Description',
        autoCancel: false,
        ongoing: true,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,);
    var ios = IOSNotificationDetails();
    var platform = NotificationDetails(android: androidChannel, iOS: ios);
    await NotificationHandler.flutterLocalNotificationsPlugin
        .show(0, title, body, platform, payload: 'My Payload');
  }
}
