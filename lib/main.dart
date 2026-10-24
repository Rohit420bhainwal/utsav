
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
import 'package:flutter/foundation.dart';
import 'notification/notification_controller.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await LocalNotificationService.showNotification(
    title: message.data["title"] ?? "Notification",
    body: message.data["body"] ?? "",
    type: message.data["type"],
    leadId: message.data["leadId"],
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific configuration.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize local storage.
  await GetStorage.init();

  // Register Firebase background message handler.
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  // Handle app launch from a terminated state via notification.
  RemoteMessage? initialMessage;

  if (!kIsWeb) {
    initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
  }

  // Initialize local notifications only on supported native platforms.
  if (!kIsWeb) {
    await LocalNotificationService.init();
  }

  String? payload;

  if (!kIsWeb) {
    final details = await FlutterLocalNotificationsPlugin()
        .getNotificationAppLaunchDetails();

    if (details?.didNotificationLaunchApp ?? false) {
      payload = details!.notificationResponse?.payload;
    }
  }

  if (initialMessage != null) {
    debugPrint("MAIN: Opened from notification");

    final box = GetStorage();
    box.write("notification_type", initialMessage.data["type"]);
    box.write("notification_leadId", initialMessage.data["leadId"]);
  }

  Get.put(NotificationController());

  runApp(UTsav(initialPayload: payload));
}

class UTsav extends StatelessWidget {
  final String? initialPayload;

  const UTsav({
    super.key,
    this.initialPayload,
  });

  @override
  Widget build(BuildContext context) {
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