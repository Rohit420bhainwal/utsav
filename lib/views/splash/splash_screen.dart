import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsav/views/splash/splash_controller.dart';
import '../../utils/app_colors.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  //final SplashController controller = Get.put(SplashController());
  final SplashController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'Utsav',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
