import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: android);

    await _notifications.initialize(
        settings: settings,

      /// 🔥 HANDLE CLICK HERE
      onDidReceiveNotificationResponse: (response) async {
        final payload = response.payload;

        if (payload != null) {
          final data = payload.split("|");

          final type = data[0];
          final leadId = data.length > 1 ? data[1] : null;

          /// 🔥 WAIT FOR APP TO BUILD
          await Future.delayed(const Duration(seconds: 1));

          if (type == "LEAD_STATUS_UPDATE" && leadId != null) {

            /// 🔥 SAME FLOW AS SPLASH
            Get.offAllNamed(
              AppRoutes.leadDetails,
              arguments: leadId,
            );

            /// 🔥 PRELOAD DASHBOARD IN STACK
            Future.delayed(const Duration(milliseconds: 300), () {
              Get.offNamed(AppRoutes.dashboard);
              Get.toNamed(
                AppRoutes.leadDetails,
                arguments: leadId,
              );
            });
          }
        }
      },
    );
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? type,
    String? leadId,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    /// 🔥 PASS DATA AS PAYLOAD
    final payload = "$type|$leadId";

    await _notifications.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }
}