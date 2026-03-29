import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../routes/app_routes.dart';
import '../../services/secure_storage_service.dart';

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
    final url = Uri.parse("https://www.termsfeed.com/live/your-link");
    await launchUrl(url);
  }

  /// 🔗 Open Terms
  void openTerms() async {
    final url = Uri.parse("https://your-terms-link.com");
    await launchUrl(url);
  }

  /// ⭐ Rate App
  void rateApp() async {
    final review = InAppReview.instance;
    if (await review.isAvailable()) {
      review.requestReview();
    }
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
}