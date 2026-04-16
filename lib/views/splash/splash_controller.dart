import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../routes/app_routes.dart';
import '../../services/secure_storage_service.dart';

class SplashController extends GetxController {
  final String? initialPayload;

  SplashController(this.initialPayload);

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    final token = await SecureStorageService.getToken();

    if (token != null && token.isNotEmpty) {

      /// 🔥 HANDLE NOTIFICATION HERE ONLY
      if (initialPayload != null) {
        final data = initialPayload!.split("|");

        final type = data[0];
        final leadId = data.length > 1 ? data[1] : null;

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
      }

      Get.offAllNamed(AppRoutes.dashboard);

    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}