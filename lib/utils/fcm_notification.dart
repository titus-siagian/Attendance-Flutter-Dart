import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ess_iris/pages/announcement/announcement.dart';
import 'package:ess_iris/repositories/auth_repository.dart';
import 'package:ess_iris/repositories/fcm_repository.dart';
import 'package:ess_iris/services/request/fcm.dart';
import 'package:ess_iris/utils/logger.dart';

class FCMNotification {
  final FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();
  final _fcmRepository = FCMRepository();

  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'general', // title
    importance: Importance.max,
  );
  final AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('ic_stat_notification');
  final IOSInitializationSettings initializationSettingsIos =
      const IOSInitializationSettings();

  late BuildContext context;
  static final FCMNotification _fcmNotification = FCMNotification._internal();

  factory FCMNotification() {
    return _fcmNotification;
  }

  FCMNotification._internal();

  static FCMNotification of(BuildContext context) {
    FCMNotification notification = FCMNotification();
    notification.context = context;
    return notification;
  }

  Future<void> initialize() async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIos,
    );

    await localNotification.initialize(
      initializationSettings,
      onSelectNotification: (String? val) {
        notificationAction(val ?? '');
      },
    );

    await localNotification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.instance.getToken().then((value) {
      logger.d('firebase token $value');
      String? userId = AuthRepository().getUserId;
      if (userId?.isNotEmpty ?? false) {
        _fcmRepository.syncFCM(userId!, FCMRequest(token: value));
      }
    });

    // handling open notification from terminated background
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      notificationAction(jsonEncode(message.data));
    }

    // handling foreground notification
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      RemoteNotification? notification = event.notification;

      if (notification != null) {
        localNotification.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          payload: jsonEncode(event.data),
        );
      }
    });

    // handling open notification from background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      notificationAction(jsonEncode(event.data));
    });
  }

  void notificationAction(String value) {
    final convertJson = jsonDecode(value);
    final jsonValue = convertJson['value'] as String?;
    if (jsonValue?.isNotEmpty ?? false) {
      final splitValue = jsonValue!.split(' ');
      logger.d("split value ${splitValue[0]}");
      if (splitValue[0] == 'announcement') {
        Navigator.of(context).pushNamed(
          AnnouncementPage.routeName,
          arguments: int.parse(splitValue[1]),
        );
      }
    }
  }
}
