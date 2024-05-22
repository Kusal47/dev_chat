import 'package:dev_chat/core/resources/ui_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../core/resources/colors.dart';
import '../../core/routes/app_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {


  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () async {
      Get.offAllNamed(Routes.dashboard);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: SvgPicture.asset(
            UIAssets.appLogo,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
