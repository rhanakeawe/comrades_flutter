import 'package:Comrades/data/manageCache.dart';
import 'package:Comrades/data/notificaitonData.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveBackgroundNotification(
      NotificationResponse notificationResponse) async {}

  // Initialize the notification plugin
  static Future<void> init() async {
    // Define the Android initialization settings
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    // Define the IOS initialization settings
    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings();

    // Combine
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotification,
      onDidReceiveNotificationResponse: onDidReceiveBackgroundNotification,
    );

    // Request Permission
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<bool> checkNotificationSettings() async {
    bool isToggled = true;
    final manageCache = ManageCache();
    var loadedNotificationSetting = await manageCache.loadListFromCache('notification_setting.json');
    if (loadedNotificationSetting != null) {
      loadedNotificationSetting = loadedNotificationSetting as List<NotificationData>;
      for (var setting in loadedNotificationSetting) {
        if (setting.toggled != "true") {
          isToggled = false;
        }
      }
    } else {
      print("No loaded setting");
      List<NotificationData> notificationData = [];
      notificationData.add(NotificationData(toggled: "true"));
      await manageCache.saveListToCache('notification_setting.json', notificationData);
    }
    return isToggled;
  }

  // Show instant notification
  static Future<void> showInstantNotification(String title, String body) async {
    bool isToggled = await checkNotificationSettings();
    if (isToggled == true) {
      print(isToggled);
      const NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: AndroidNotificationDetails("channelId", "channelName",
              importance: Importance.high, priority: Priority.high),
          iOS: DarwinNotificationDetails());
      await flutterLocalNotificationsPlugin.show(
          0, title, body, platformChannelSpecifics);
    }
  }

  // Show scheduled notification
  static Future<void> scheduleNotification(
      String title, String body, DateTime scheduledDate) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails("channelId", "channelName",
            importance: Importance.high, priority: Priority.high),
        iOS: DarwinNotificationDetails());
    await flutterLocalNotificationsPlugin.zonedSchedule(0, title, body,
        tz.TZDateTime.from(scheduledDate, tz.local), platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
  }
}
