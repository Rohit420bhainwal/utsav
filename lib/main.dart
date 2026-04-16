import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:utsav/services/local_notification_service.dart';
import 'package:utsav/themes/app_theme.dart';
import 'package:utsav/routes/app_pages.dart';
import 'package:utsav/routes/app_routes.dart';
import 'package:utsav/views/splash/splash_controller.dart';

import 'notification/notification_controller.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  await LocalNotificationService.showNotification(
    title: message.data["title"] ?? "Notification",
    body: message.data["body"] ?? "",
    type: message.data["type"],
    leadId: message.data["leadId"],
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await GetStorage.init(); // ✅ MUST be before usage
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  /// 🔥 HANDLE KILLED STATE
  RemoteMessage? initialMessage =
  await FirebaseMessaging.instance.getInitialMessage();
  await LocalNotificationService.init();
  final details =
  await FlutterLocalNotificationsPlugin()
      .getNotificationAppLaunchDetails();
  String? payload;

  if (details?.didNotificationLaunchApp ?? false) {
    payload = details!.notificationResponse?.payload;
  }

  if (initialMessage != null) {
    print("🔥 MAIN: Opened from notification");

    final box = GetStorage();
    box.write("notification_type", initialMessage.data["type"]);
    box.write("notification_leadId", initialMessage.data["leadId"]);
  }

  Get.put(NotificationController());

  runApp(UTsav(initialPayload: payload));
}

class UTsav extends StatelessWidget {
  final String? initialPayload;

  const UTsav({super.key, this.initialPayload});


  @override
  Widget build(BuildContext context) {

    /*if (initialPayload != null) {
      Future.delayed(const Duration(seconds: 1), () {
        final data = initialPayload!.split("|");

        final type = data[0];
        final leadId = data.length > 1 ? data[1] : null;

        if (type == "LEAD_STATUS_UPDATE" && leadId != null) {
          Get.offAllNamed(
            AppRoutes.leadDetails,
            arguments: leadId,
          );
        }
      });
    }*/

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UTsav',
      theme: AppTheme.lightTheme,
      initialBinding: BindingsBuilder(() {
        Get.put(SplashController(initialPayload));
      }),
      getPages: AppPages.pages,
    );
  }
}
