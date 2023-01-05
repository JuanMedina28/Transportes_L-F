/*Variant: profileUnitTest
Config: debug
Store: C:\Users\jonny\.android\debug.keystore
Alias: AndroidDebugKey
MD5: 8D:17:24:73:89:BE:47:63:21:DF:C7:10:71:5A:91:A2
SHA1: 16:4C:9A:8C:56:81:78:3D:E3:2E:7C:0E:37:30:B5:1C:07:EB:94:8E
SHA-256: F5:37:31:A8:6D:78:3A:0E:3B:5F:A7:01:71:C1:74:C1:9E:00:79:01:23:A5:9A:33:B7:FE:28:73:03:5E:6B:E9
Valid until: sßbado 13 de enero de 2052*/

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:muyp_p1_flutter/vistas/estudiante.dart';
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//const initializationSettingsIOS = IOSInitializationSettings();
const initializationSettingsAndroid =
AndroidInitializationSettings('launch_background');
const initializationSettings = InitializationSettings(
  android: initializationSettingsAndroid,
  //iOS: initializationSettingsIOS,
);
class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static StreamController<String> _messagesStream =
      new StreamController.broadcast();

  static Stream<String> get messgeStream => _messagesStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    print('Backkground ${message.messageId}');
    print('Datos: ${message.data}');
    print('Mensaje:  ${message}');
    myList() => message.data.entries.map((e) => e.value).toList();
    print('Alumno:' + myList()[0]);
    print('DVenta:' + myList()[1]);
    _messagesStream.add(message.notification?.title ?? 'No Title');
    flutterLocalNotificationsPlugin
        .initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: (dynamic payload) async {
          if (payload != null) {
            navigatorKey.currentState?.push(MaterialPageRoute(
                builder: (context) => Pasajeros(
                    text: myList()[0],
                    id_dv: myList()[1])));
          }
        });

  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print('On Message ${message.messageId}');
    print('Datos: ${message.data.toString()}');
    print('Mensaje:  ${message}');
    myList()=> message.data.entries.map((e)=>e.value).toList();
    print('Alumno:'+myList()[0]);
    print('DVenta:'+myList()[1]);
    _messagesStream.add(message.notification?.title ?? 'No Title');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    print('onMessageOpenApp ${message.messageId}');
    print('Datos: ${message.data}');
    _messagesStream.add(message.notification?.title ?? 'No Title');
    myList() => message.data.entries.map((e) => e.value).toList();
    navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => Pasajeros(
            text: myList()[0],
            id_dv: myList()[1])));
  }

  static Future initializeAPP() async {
    //Push Notifications
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print("Token firebase:" + token.toString());

    //Hanlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    //Local Notifications
  }

  static closeStrams() {
    _messagesStream.close();
  }
}
