import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_solar/controllers/notification_controller.dart';
import 'package:smart_solar/storage/storage.dart';
import '../routes/route_names.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async{
  storeMessage(message);
}

Future<void> handleForegroundMessage(RemoteMessage message) async{
  AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      'id_1','channel_name',
      priority: Priority.high,
      importance: Importance.max,
      playSound: true
  );

  NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(0, message.notification!.title ?? '', message.notification!.body ?? '', notificationDetails);
  storeMessage(message);
}

void storeMessage(RemoteMessage message){
  String date = DateTime.now().toString();
  date = "${date.substring(8,10)}-${date.substring(5,7)}-${date.substring(0,4)}\n${date.substring(11,16)}";
  NotificationController.addNotification(message.notification!.title!, message.notification!.body!, date);
}

class FirebaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance;
  static FirebaseApi instance = FirebaseApi._();
  FirebaseApi._();

  Future<void> initNotifications() async{
    try {
      await _firebaseMessaging.requestPermission();
      FirebaseMessaging.onMessage.listen(handleForegroundMessage);
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true, badge: true, sound: true);
      initPushNotifications();
    }
    catch(e){
      log(e.toString());
    }
  }

  Future<String?> addToken() async {
    String? fcmToken;
    bool isThere = await Storage.instance.containsKeys('fcmToken');
    if(!isThere){
      fcmToken = await _firebaseMessaging.getToken();
      if(fcmToken != null) {
        Storage.instance.write('fcmToken', fcmToken);
      }
      log("not");
    }else{
      fcmToken = (await Storage.instance.read('fcmToken')).data;
    }
    return fcmToken;
  }

  void handleMessage(RemoteMessage? remoteMessage){
    if(remoteMessage==null) return;
    navigatorKey.currentState?.pushNamed(Routes.home, arguments: remoteMessage);
    storeMessage(remoteMessage);
  }

  Future initPushNotifications() async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  static init() async {
    instance.initNotifications();
    await initLocalNotifications();
  }

  static Future initLocalNotifications() async {
    var androidSettings = const AndroidInitializationSettings('mipmap/ic_launcher');
    var initSettings = InitializationSettings(android: androidSettings);
    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }
}