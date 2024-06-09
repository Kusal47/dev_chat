import 'package:dev_chat/features/dashboard/presentation/home_screen/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../../core/resources/colors.dart';
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
    return GetBuilder<HomeController>(

        // init: DashBoardHandleController(),
        builder: (controller) {
      return PopScope(
        canPop: true,
        child: Scaffold(
          body: IndexedStack(
            //key: ValueKey<int>(controller.currentIndex),
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

            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  12,
                ),
                topRight: Radius.circular(
                  12,
                ),
              ),
              color: Colors.white,
            ),
            // color: Color.fromARGB(1, 132, 86, 86),
            child: ClipRRect(
              // borderRadius: const BorderRadius.only(
              //   topLeft: Radius.circular(12.0),
              //   topRight: Radius.circular(12.0),
              // ),
              child: BottomNavigationBar(
                unselectedItemColor: Colors.black,
                selectedItemColor: primaryColor,
                onTap: controller.changeIndex,
                currentIndex: controller.currentIndex,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                unselectedLabelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                selectedFontSize: 11,
                type: BottomNavigationBarType.fixed,
                // backgroundColor: const Color.fromARGB(1, 239, 233, 233),
                selectedLabelStyle: const TextStyle(
                  color: primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                elevation: 0.01,
                selectedIconTheme: const IconThemeData(
                  color: primaryColor,
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
        ),
      );
    });
  }

  _bottomNavigationBarItem({
    required String label,
    required IconData logoPath,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(
        logoPath,
        // color: isSelected ? primaryColor : null,
        // colorFilter: ColorFilter.mode(
        //   isSelected ? primaryColor : Colors.black,
        //   BlendMode.srcIn,
        // ),
      ),
      label: label,
    );
  }
}
