import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

// This needs to be a top-level function
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // Handle notification tap when the app is in the background here
  print('Notification tapped in background: ${notificationResponse.payload}');
}

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final RxBool _isInitialized = false.obs;

  Future<NotificationService> init() async {
    await _initializeNotifications();

    return NotificationService();
  }

  Future<void> _initializeNotifications() async {
    if (_isInitialized.value) return;

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    _isInitialized.value = true;
  }

  Future<bool> _requestPermissions() async {
    if (GetPlatform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final int sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        // For Android 13 (API 33) and above

        final status = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
        return status ?? false;
      } else if (sdkInt >= 30) {
        // For Android 11 (API 30) to Android 12L (API 32)
        final status = await Permission.notification.request();
        return status.isGranted;
      } else {
        // For Android 10 (API 29) and below
        return true; // Permissions are granted upon app installation
      }
    } else if (GetPlatform.isIOS) {
      final status = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return status ?? false;
    }
    return false;
  }

  void _onDidReceiveNotification(NotificationResponse notificationResponse) {
    print(
        "Notification received in foreground: ${notificationResponse.payload}");
    // Add custom logic here, e.g., navigating to a specific screen
  }

  Future<bool> showInstantNotification(String title, String body,
      {String? payload}) async {
    if (!_isInitialized.value) await _initializeNotifications();

    final permissionGranted = await _requestPermissions();
    if (!permissionGranted) {
      print("Notification permission not granted");
      return false;
    }

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'instant_notification_channel_id',
        'Instant Notifications',
        icon: 'assets/images/logo.png',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    try {
      await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        platformChannelSpecifics,
        payload: payload ?? 'instant_notification',
      );
      return true;
    } catch (e) {
      print("Error showing notification: $e");
      return false;
    }
  }

  Future<bool> scheduleNotification(
      int id, String title, String body, DateTime scheduledTime,
      {String? payload}) async {
    if (!_isInitialized.value) await _initializeNotifications();

    final permissionGranted = await _requestPermissions();
    if (!permissionGranted) {
      print("Notification permission not granted");
      return false;
    }

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          iOS: DarwinNotificationDetails(),
          android: AndroidNotificationDetails(
            'reminder_channel',
            'Reminder Channel',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exact,
      );
      return true;
    } catch (e) {
      print("Error scheduling notification: $e");
      return false;
    }
  }

  Future<bool> cancelNotification(int id) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id);
      return true;
    } catch (e) {
      print("Error cancelling notification: $e");
      return false;
    }
  }

  Future<bool> cancelAllNotifications() async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
      return true;
    } catch (e) {
      print("Error cancelling all notifications: $e");
      return false;
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  Future<bool> clearNotificationHistory() async {
    try {
      if (GetPlatform.isAndroid) {
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.deleteNotificationChannelGroup('reminder_channel');
      }
      return true;
    } catch (e) {
      print("Error clearing notification history: $e");
      return false;
    }
  }
}
