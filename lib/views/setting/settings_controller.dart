import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utsav/services/api_service.dart';
import '../../config/api_config.dart';
import '../../routes/app_routes.dart';
import '../../services/secure_storage_service.dart';
import '../../utils/app_utils.dart';

class SettingController extends GetxController {
  final box = GetStorage();

  var isNotificationEnabled = true.obs;
  var isDarkMode = false.obs;

  void toggleNotification(bool value) {
    isNotificationEnabled.value = value;
  }

  void toggleTheme(bool value) {
    isDarkMode.value = value;
  }

  /// 🔗 Open Privacy Policy
  void openPrivacyPolicy() async {
   /* Get.to(() => WebViewScreen(
      title: "Privacy Policy",
      url: "https://www.google.com/",
    ));*/
   // AppUtils.openUrl("https://www.termsfeed.com/live/4b3e7855-cf9d-4dc8-a019-87fc4f392581");
    AppUtils.openUrl("${ApiConfig.imageBaseUrl}/privacy_policy.html");
    /*final url = Uri.parse("https://www.termsfeed.com/live/your-link");
    await launchUrl(url);*/
  }

  /// 🔗 Open Terms
  void openTerms() async {
    AppUtils.openUrl("${ApiConfig.imageBaseUrl}/terms_conditions.html");
    /*final url = Uri.parse("https://your-terms-link.com");
    await launchUrl(url);*/
  }

  /// ⭐ Rate App
  void rateApp() async {

    AppUtils.rateApp();

    /*final review = InAppReview.instance;
    if (await review.isAvailable()) {
      review.requestReview();
    }*/
  }

  /// 📤 Share App
  void shareApp() {
    Share.share("Check out Utsav app: https://play.google.com/store/apps/details?id=your.package");
  }

  Future<void> logout() async {
    await SecureStorageService.clearAll();
    await box.erase();
    Get.offAllNamed(AppRoutes.login);
  }

  void contactCall() {
    AppUtils.callPhone("+919999999999");
  }

  void contactEmail() {
    AppUtils.sendEmail("support@utsav.com");
  }

  void contactWhatsApp() {
    AppUtils.openWhatsApp("919999999999");
  }
}