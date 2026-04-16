import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';

import '../routes/app_routes.dart';
import '../services/local_notification_service.dart';


class NotificationController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    initFCM();
  }

  void initFCM() async {

    await FirebaseMessaging.instance.requestPermission();

    /// 🔹 TOKEN
    String? token = await FirebaseMessaging.instance.getToken();
    print("🔥 FCM TOKEN: $token");

    /// 🔹 FOREGROUND (DATA ONLY)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("🔔 FOREGROUND DATA: ${message.data}");

      LocalNotificationService.showNotification(
        title: message.data["title"] ?? "Notification",
        body: message.data["body"] ?? "",
        type: message.data["type"],
        leadId: message.data["leadId"],
      );
    });

    /// 🔹 BACKGROUND CLICK
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("🔔 Clicked (background)");

      handleNavigation(message);
    });
  }



  /// 🔥 NAVIGATION HANDLER
  void handleNavigation(RemoteMessage message) {
    final type = message.data["type"];
    final leadId = message.data["leadId"];

    print("TYPE: $type");
    print("LEAD ID: $leadId");

    if (type == "LEAD_STATUS_UPDATE" && leadId != null) {

      /// 🔥 CLEAR STACK + CONTROL BACK
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

      return;
    }

    /*if (type == "LEAD_STATUS_UPDATE" && leadId != null) {

      Future.delayed(const Duration(milliseconds: 300), () {

        /// 🔥 CLEAR EVERYTHING → GO DASHBOARD → THEN OPEN LEAD
        Get.offAllNamed(AppRoutes.dashboard);

        Future.delayed(const Duration(milliseconds: 200), () {
          Get.offAllNamed(
            AppRoutes.leadDetails,
            arguments: leadId.toString(),
          );
        });

      });
    }*/
  }
}