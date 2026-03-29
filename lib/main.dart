import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsav/themes/app_theme.dart';
import 'package:utsav/routes/app_pages.dart';
import 'package:utsav/routes/app_routes.dart';

void main() {
  runApp(const UTsav());
}

class UTsav extends StatelessWidget {
  const UTsav({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UTsav',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
