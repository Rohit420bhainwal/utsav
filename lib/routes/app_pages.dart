import 'package:get/get.dart';
import 'package:utsav/views/dashboard/dashboard_screen.dart';
import 'package:utsav/views/editprofile/edit_profile_screen.dart';
import 'package:utsav/views/home/home_screen.dart';
import 'package:utsav/views/login/login_screen.dart';
import 'package:utsav/views/profile/profile_screen.dart';
import 'package:utsav/views/register/register_screen.dart';
import 'package:utsav/views/splash/splash_screen.dart';


import '../views/forgotpassword/forgot_password_screen.dart';
import '../views/leads/lead_detail_screen.dart';
import '../views/verifyotp/verify_otp_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: ()=>EditProfileScreen()
    ),
    GetPage(
        name: AppRoutes.profile,
        page: ()=>ProfileScreen()
    ),

    GetPage(
      name: AppRoutes.leadDetails,
      page: () => LeadDetailScreen(),
    ),

    GetPage(
      name: AppRoutes.verifyOtp,
      page: () => VerifyOtpScreen(),
    ),

    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => ForgotPasswordScreen(),
    ),
  ];
}
