import 'package:dev_chat/features/dashboard/presentation/home_screen/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../../core/resources/colors.dart';
import '../../../../../core/widgets/common/base_widget.dart';
import '../../../../people_suggestion/presentation/people_suggestion.dart';
import '../../../../more/presentation/app_setting.dart';
import 'home_screen.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    Get.put(HomeController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return BaseWidget(builder: (context, config, theme) {
        return Scaffold(
          body: IndexedStack(
            index: controller.currentIndex,
            children: const [
              HomeScreen(),
              PeopleScreen(),
              AppSetting(),
            ],
          ),
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              color: theme.bottomNavigationBarTheme.backgroundColor,
            ),
            child: ClipRRect(
              child: BottomNavigationBar(
                unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,
                selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
                onTap: controller.changeIndex,
                currentIndex: controller.currentIndex,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                unselectedLabelStyle: TextStyle(
                  color: theme.bottomNavigationBarTheme.unselectedItemColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                selectedFontSize: 11,
                type: BottomNavigationBarType.fixed,
                selectedLabelStyle: TextStyle(
                  color: theme.bottomNavigationBarTheme.selectedItemColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                elevation: 0.01,
                selectedIconTheme: IconThemeData(
                  color: theme.bottomNavigationBarTheme.selectedItemColor,
                ),
                items: [
                  _bottomNavigationBarItem(
                    logoPath: Bootstrap.chat,
                    label: 'Chats',
                    isSelected: controller.currentIndex == 0,
                  ),
                  _bottomNavigationBarItem(
                    logoPath: Bootstrap.people,
                    label: 'People',
                    isSelected: controller.currentIndex == 1,
                  ),
                  _bottomNavigationBarItem(
                    logoPath: HeroIcons.user,
                    label: 'Profile',
                    isSelected: controller.currentIndex == 2,
                  ),
                ],
              ),
            ),
          ),
        );
      });
    });
  }

  BottomNavigationBarItem _bottomNavigationBarItem({
    required String label,
    required IconData logoPath,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(
        logoPath,
      ),
      label: label,
    );
  }
}
