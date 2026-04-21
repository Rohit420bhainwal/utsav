import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  static Future<void> rateApp() async {
    final InAppReview inAppReview = InAppReview.instance;

    try {
      // ✅ Check if in-app review is available
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      } else {
        // 🔁 Fallback → Open Play Store
        await _openStore();
      }
    } catch (e) {
      // 🔁 Fallback in case of error
      await _openStore();
    }
  }

  static Future<void> _openStore() async {
    const String packageName = "com.digitalbhikari.app.digital_bhikari"; // 🔴 CHANGE THIS

    final Uri url = Uri.parse(
      "https://play.google.com/store/apps/details?id=$packageName",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Could not launch $url";
    }
  }

  static Future<void> callPhone(String phone) async {
    final Uri uri = Uri.parse("tel:$phone");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw "Cannot open dialer";
    }
  }

  static Future<void> sendEmail(String email) async {
    final Uri uri = Uri.parse("mailto:$email");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw "Cannot open email app";
    }
  }

  static Future<void> openWhatsApp(String phone) async {
    final Uri uri = Uri.parse("https://wa.me/$phone");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw "WhatsApp not installed";
    }
  }
}