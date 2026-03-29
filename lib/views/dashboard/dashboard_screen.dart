import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsav/views/createbooking/create_booking_screen.dart';
import 'package:utsav/views/home/home_screen.dart';
import 'package:utsav/views/mybooking/my_booking_screen.dart';
import 'package:utsav/views/profile/profile_screen.dart';
import 'package:utsav/views/setting/settings_screen.dart';
import '../../utils/app_colors.dart';
import '../leads/leads_screen.dart';
import '../services/services_screen.dart';
import 'dashboard_screen_controller.dart';



class DashboardScreen extends StatelessWidget {
   DashboardScreen({super.key});

   final DashboardScreenController controller = Get.put(DashboardScreenController());


  final List<Widget> pages = [
    HomeScreen(),
    // ServicesScreen(),
    LeadsScreen(),
    SettingsScreen(),

  ];

   @override
   Widget build(BuildContext context) {
     final textTheme = Theme.of(context).textTheme;

     return Obx(
           () => Scaffold(
         body: IndexedStack(
           index: controller.selectedIndex.value,
           children: pages,
         ),

         bottomNavigationBar: BottomNavigationBar(
           currentIndex: controller.selectedIndex.value,
           onTap: controller.changeTab,
           type: BottomNavigationBarType.fixed,
           backgroundColor: AppColors.surface,

           selectedItemColor: AppColors.primary,
           unselectedItemColor: AppColors.textSecondary,

           selectedLabelStyle: textTheme.labelMedium?.copyWith(
             fontWeight: FontWeight.w600,
           ),
           unselectedLabelStyle: textTheme.labelMedium,

           items: const [
             BottomNavigationBarItem(
               icon: Icon(Icons.home_filled),
               label: "Home",
             ),
             // BottomNavigationBarItem(
             //   icon: Icon(Icons.add_circle_outline),
             //   label: "Create",
             // ),

             // BottomNavigationBarItem(
             //   icon: Icon(Icons.menu),
             //   label: "Services",
             // ),
             BottomNavigationBarItem(
               icon: Icon(Icons.message),
               label: "Leads",
             ),
             BottomNavigationBarItem(
               icon: Icon(Icons.settings),
               label: "Settings",
             ),

           ],
         ),
       ),
     );
   }
}
